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

//// 指定された位置から上に向かって、関数定義を探す。
//// あればその文字列を返し、なければnilを返す。
//-(NSString*)ex_searchFuncDefinition:(NSRange)currentPos {
//    // とりあえず{か}を下に向かって探す。
//    
//}
//

// 関数定義に;を付けて、宣言にする。
-(NSString*)ex_toDeclaration {
    // expect [self isFuncDefinition] == YES
    
    NSString* result = nil;
    NSString* trimmedStr = [self ex_trimWhitespaces];
    
    // 行中の{を探す
    if( [trimmedStr ex_hasCharas:@"{" withOption:0]) {
        result = [trimmedStr ex_replaceFrom:@"\\s*\\{" to:@";"];
    // コメントらしき/がある場合
    } else if([trimmedStr ex_hasCharas:@"/" withOption:0]) {
        result = [trimmedStr ex_replaceFrom:@"\\s*/" to:@"; /"];
    // それ以外の場合
    } else {
        result = [trimmedStr stringByAppendingString:@";"];
    }
    return result;
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
    
    NSRange classBeginPos = [self ex_getClassBeginPos:className];
    if( RANGE_IS_NOT_FOUND(classBeginPos) ) {
        DbgLog(@"%@ is not found", className);
        return NO;
    }
   
    NSRange result = [self rangeOfString:functionDeclaration options:0 range:NSMakeRange(classBeginPos.location, self.length - classBeginPos.location)];
    if( RANGE_IS_FOUND(result) ) {
        return NO;
    }
    return YES;
}

// @interface クラス名の開始位置を返す
-(NSRange)ex_getClassBeginPos:(NSString*)className {
    // expect className == "NSString"
    // expect className == "NSString+Extends"
    NSArray* classNameAndCategory = [className ex_divideClassNameAndCategory];
    
    NSString* pattern = nil;
    if( classNameAndCategory.count >= 2) {
        pattern = [NSString stringWithFormat:@"@interface\\s*%@\\s*\\(\\s*%@\\b\\s*\\)",
                   classNameAndCategory[0],
                   classNameAndCategory[1]];
    } else {
        pattern = [NSString stringWithFormat:@"@interface\\s*%@\\b",
                   classNameAndCategory[0]];
    }
    NSRange range = [self ex_findWithPattern:pattern];
    return range;
}

// @endの位置を返す
-(NSRange)ex_getClassEndPos:(NSString*)className {
    // expect className == "NSString"
    // expect className == "NSString+Extends"
    
    NSRange classBeginPos = [self ex_getClassBeginPos:className];
    NSRange result = [self rangeOfString:@"@end" options:0 range:NSMakeRange(classBeginPos.location, self.length - classBeginPos.location)];
    return result;
}


@end
