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
    NSString* trimmedStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmedStr;
}

-(NSRange)ex_findWithPattern:(NSString*)pattern fromRange:(NSRange)range {
    return  [self rangeOfString:pattern options:NSRegularExpressionSearch range:range];
}

-(NSRange)ex_findWithPattern:(NSString*)pattern {
    return [self ex_findWithPattern:pattern fromRange:NSMakeRange(0, self.length)];
}


@end
