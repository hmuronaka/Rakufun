//
//  NSString+EX_Extends.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "NSString+HM_Extends.h"

@implementation NSString (HM_Extends)


// characterSetで文字列が始まるかどうか
-(BOOL)ex_isStartChars:(NSString*)characterSet {
    if( self.length == 0 ) {
        return NO;
    }
    
    NSRange range = NSMakeRange(0, 1);
    NSRange result = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:characterSet] options:0 range:range];
    return result.length > 0;
}

// 文中にcharacterSetを持つかどうか
-(BOOL)ex_hasCharas:(NSString*)characterSet withOption:(NSStringCompareOptions)options {
    NSRange range = NSMakeRange(0, self.length);
    NSRange result = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:characterSet] options:options range:range];
    return result.length > 0;
}

// 1回だけの置換
-(NSString*)ex_replaceFrom:(NSString*)fromStr to:(NSString*)toStr {
    NSRange rangeOfFirstMatch = [self ex_findWithPattern:fromStr];
    NSString* result;
    if( RANGE_IS_FOUND(rangeOfFirstMatch) ) {
        result = [self stringByReplacingCharactersInRange:rangeOfFirstMatch withString:toStr];
    }
    return result;
}

// 前後の空白除去
-(NSString*)ex_trimWhitespaces {
    NSString* trimmedStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedStr;
}

// 複数行対応
// backwards時は最後にマッチした結果を返す
-(NSRange)ex_findWithPattern:(NSString*)pattern fromRange:(NSRange)range {
    return [self ex_findWithPattern:pattern fromRange:range andIsBackwward:NO];
}

// 複数行対応
// backwards時は最後にマッチした結果を返す
-(NSRange)ex_findWithPattern:(NSString*)pattern fromRange:(NSRange)range andIsBackwward:(BOOL)isBackwards {
    NSRegularExpression* regexp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSRange result;
    // 前方探索
    if( !isBackwards ) {
        result = [regexp rangeOfFirstMatchInString:self options:0 range:range];
    // 後方探索もどき
    // 最後にマッチした要素を返す
    } else {
        NSArray* array = [regexp matchesInString:self options:0 range:range];
        if( array.count == 0 ) {
            DbgLog(@"not match!! pattern=%@", pattern);
            return NSMakeRange(NSNotFound, 0);
        }
        DbgLog(@"checkingResults=%@", array);
        NSTextCheckingResult* checkingResult = [array lastObject];
        result = [checkingResult rangeAtIndex:0];
        DbgLog(@"checkingResult=%@", checkingResult);
    }
    return result;
}

-(NSRange)ex_findWithPattern:(NSString*)pattern {
    return [self ex_findWithPattern:pattern fromRange:NSMakeRange(0, self.length)];
}

// 当該位置の1行を取得する
-(NSString*)ex_getLineFromPos:(NSInteger)pos {
    // 手前の¥n又は開始位置を探す
    NSInteger currentPos = pos;
    NSRange range = NSMakeRange(0, currentPos);
    NSRange thisLineRange = [self rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];
   
    NSRange afterRange = NSMakeRange(currentPos, self.length - currentPos);
    NSRange thisLineEndRange = [self rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:afterRange];
    
    // 改行の次の位置から開始する
    NSInteger beginPos = (thisLineRange.length > 0) ? thisLineRange.location + 1 : 0;
    NSInteger endPos = (thisLineEndRange.length > 0) ? thisLineEndRange.location : self.length;
    NSRange substrRange = NSMakeRange(beginPos, endPos - beginPos);
    
    NSString* result = [self substringWithRange:substrRange];
    return result;
}




@end
