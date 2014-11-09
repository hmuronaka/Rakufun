//
//  NSString+SourceCode.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/02.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "NSString+HM_Extends.h"
#import "NSString+HM_SourceCode.h"

@implementation NSString (HM_SourceCode)

// 関数定義かどうか
// -か+で始まり、;が無い場合に、定義と見なす
// コメント中かどうかは考慮しない。
-(BOOL)ex_isFuncDefinition {
    
    // 行頭が-か+かを調べる
    NSString* trimmedStr = [self ex_trimWhitespaces];
    if( ![trimmedStr ex_isStartChars:@"+-"] ) {
        return NO;
    }
    
    // 行中に;が無いことを調べる
    if( [trimmedStr ex_hasCharas:@";" withOption:NSBackwardsSearch] ) {
        return NO;
    }
    
    return YES;
}

// 現在の文字列が関数プロトタイプかどうか
-(BOOL)ex_isFunctionDeclaration {
    // 行頭が-か+かを調べる
    NSString* trimmedStr = [self ex_trimWhitespaces];
    if( ![trimmedStr ex_isStartChars:@"+-"] ) {
        return NO;
    }
    
    // 行中に;があることを調べる。
    return [trimmedStr ex_hasCharas:@";" withOption:NSBackwardsSearch];
}

// 指定位置がシグネチャ上であれば、その行のシグネチャを返し、
// 関数中であれば、その関数のシグネチャを返す
// 関数外の場合は、下側に探索して見つけたシグネチャを返す。（できれば除外したい）
// マッチしなければnilを返す。
-(NSString*)ex_searchFuncDefinition:(NSInteger)currentPos {
    // とりあえず{か}を下に向かって探す。
    NSRange blockRange = [self ex_findWithPattern:@"[\\{\\}]" fromRange:NSMakeRange(currentPos, self.length - currentPos)];
    if( RANGE_IS_NOT_FOUND(blockRange) ) {
        // 終端に設定する
        blockRange.location = self.length;
    } else {
        // {を探索に含めるために+1する
        blockRange.location++;
    }
    
    // 見つかったブロックの位置から上に向かってシグネチャらしきものを探す。
    NSString* pattern = @"\\s*[-+]\\s*\\(\\s*\\w[^\\)]*\\)\\s*\\w[^\\{]*\\{";
    NSRange patternRange = [self ex_findWithPattern:pattern fromRange:NSMakeRange(0, blockRange.location) andIsBackwward:YES];
    if( RANGE_IS_NOT_FOUND(patternRange) ) {
        return nil;
    }
    
    // シグネチャらしきも文字列を返す
    NSString* result = [[self substringWithRange:patternRange] ex_trimWhitespaces];
    return result;
}


// 関数定義に;を付けて、宣言にする。
-(NSString*)ex_toDeclaration {
    // expect [self isFuncDefinition] == YES or
    // expect self == [ex_searchFuncDefinition:NSMakeRange(0, self.length)]
    
    NSString* result = nil;
    NSString* trimmedStr = [self ex_trimWhitespaces];
    result = [trimmedStr ex_replaceFrom:@"\\s*\\{" to:@";"];
    return result;
}

// 関数宣言を定義に変換する
-(NSString*)ex_toDefinition {
    
    // 末尾の;を除去して、{にする
    NSString* signature = [self ex_replaceFrom:@";" to:@" {\n}"];
    return signature;
    
    
}

// ファイルパスからクラス名を抽出する
-(NSString*)ex_className {
    NSString* result = [self lastPathComponent];
    result = [result stringByDeletingPathExtension];
    return result;
}
// クラス名を想定した文字列に対して
-(NSArray*)ex_divideClassNameAndCategory {
    NSArray* array = [self componentsSeparatedByString:@"+"];
    return array;
}

// クラス定義内にfunctionDeclarationに一致する文字列があるかどうか
// 定義が無い場合のみYESを返す。
// クラス定義が無い場合、定義が既にある場合はNOを返す。
//
// コメントは無視する。
-(BOOL)ex_hasNotFunctionDeclaration:(NSString*)functionDeclaration inClass:(NSString*)className {
    
    NSRange classBeginPos = [self ex_getClassInterfaceBeginPos:className];
    if( RANGE_IS_NOT_FOUND(classBeginPos) ) {
        DbgLog(@"%@ is not found", className);
        return NO;
    }
   
    DbgLog(@"function declaration=%@", functionDeclaration);
    NSRange result = [self rangeOfString:functionDeclaration options:0 range:NSMakeRange(classBeginPos.location, self.length - classBeginPos.location)];
    if( RANGE_IS_FOUND(result) ) {
        return NO;
    }
    return YES;
}

// 指定された関数宣言が、クラスのソースコード上に存在しないことを確認する。
-(BOOL)ex_hasNotFunctionDefinition:(NSString*)functionDeclaration inClass:(NSString*)className {
    
    NSRange classBeginPos = [self ex_getClassImplementationBeginPos:className];
    if( RANGE_IS_NOT_FOUND(classBeginPos) ) {
        DbgLog(@"%@ is not found", className);
        return NO;
    }
    
    NSRange classEndPos = [self ex_getClassImplementationEnd:className];
    if( RANGE_IS_NOT_FOUND(classEndPos) ) {
        DbgLog(@"%@ end is not found", className);
        return NO;
    }
    
    // シグネチャから正規表現を生成する。
    NSString* signature = [functionDeclaration ex_replaceFrom:@";" to:@""];
    signature = [signature ex_trimWhitespaces];
    signature = [signature ex_escapeMetaCharacters:[NSCharacterSet characterSetWithCharactersInString:@"()*"]];
    NSString* pattern = [NSString stringWithFormat:@"\n\\s*%@\\s*\\{",signature];
    DbgLog(@"signature=%@", pattern);
    
    // ソースコード上にシグネチャが存在しなければYESを返す。
    NSRange fromRange = NSMakeRange(classBeginPos.location, classEndPos.location - classBeginPos.location);
    NSRange result = [self ex_findWithPattern:pattern fromRange:fromRange];
    if( RANGE_IS_FOUND(result)) {
        DbgLogRange(@"fromRange", fromRange);
        DbgLogRange(@"result", result);
        return NO;
    }
    return YES;
}

// クラス実装の開始位置を取得する
-(NSRange)ex_getClassImplementationBeginPos:(NSString*)className {
    return [self ex_getClassBeginPos:className withKeyword:@"implementation"];
}

// @interface クラス名の開始位置を返す
-(NSRange)ex_getClassInterfaceBeginPos:(NSString*)className {
    return [self ex_getClassBeginPos:className withKeyword:@"interface"];
}

// strにはinterfaceかimplementationを想定。
-(NSRange)ex_getClassBeginPos:(NSString*)className withKeyword:(NSString*)keyword {
    // expect className == "NSString"
    // expect className == "NSString+Extends"
    NSArray* classNameAndCategory = [className ex_divideClassNameAndCategory];
    
    NSString* pattern = nil;
    if( classNameAndCategory.count >= 2) {
        pattern = [NSString stringWithFormat:@"@%@\\s*%@\\s*\\(\\s*%@\\b\\s*\\)",
                   keyword,
                   classNameAndCategory[0],
                   classNameAndCategory[1]];
    } else {
        pattern = [NSString stringWithFormat:@"@%@\\s*%@\\b",
                   keyword,
                   classNameAndCategory[0]];
    }
    NSRange range = [self ex_findWithPattern:pattern];
    return range;
}

// @endの位置を返す
// @endは行頭にあると想定する
// コメント中がどうかは考慮しない
-(NSRange)ex_getClassInterfaceEndPos:(NSString*)className {
    // expect className == "NSString"
    // expect className == "NSString+Extends"
    
    NSRange classBeginPos = [self ex_getClassInterfaceBeginPos:className];
    NSRange result = [self ex_findWithPattern:@"\\n\\s*@end\\b" fromRange:NSMakeRange(classBeginPos.location, self.length - classBeginPos.location)];
    result = [self rangeOfString:@"@end" options:0 range:result];
    return result;
}

// @endの位置を返す
// @endは行頭にあると想定する
// コメント中がどうかは考慮しない
-(NSRange)ex_getClassImplementationEnd:(NSString*)className {
    // expect className == "NSString"
    // expect className == "NSString+Extends"
    
    NSRange classBeginPos = [self ex_getClassImplementationBeginPos:className];
    NSRange result = [self ex_findWithPattern:@"\\n\\s*@end\\b" fromRange:NSMakeRange(classBeginPos.location, self.length - classBeginPos.location)];
    result = [self rangeOfString:@"@end" options:0 range:result];
    return result;
}

@end