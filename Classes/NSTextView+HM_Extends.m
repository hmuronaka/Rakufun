//
//  NSTextView+Extends.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "NSTextView+HM_Extends.h"

@implementation NSTextView (HM_Extends)

-(NSInteger)ex_cursolPosition {
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

-(NSString*)ex_currentLine {
    NSString* line = [self getLineFromPos:[self ex_cursolPosition]];
    return line;
}

// 当該位置の1行を取得する
-(NSString*)getLineFromPos:(NSInteger)pos {
    // 手前の¥n又は開始位置を探す
    NSInteger currentPos = pos;
    NSRange range = NSMakeRange(0, currentPos);
    NSString* text = self.textStorage.string;
    NSRange thisLineRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch range:range];
   
    NSRange afterRange = NSMakeRange(currentPos, text.length - currentPos);
    NSRange thisLineEndRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0 range:afterRange];
    
    // 改行の次の位置から開始する
    NSInteger beginPos = (thisLineRange.length > 0) ? thisLineRange.location + 1 : 0;
    NSInteger endPos = (thisLineEndRange.length > 0) ? thisLineEndRange.location : text.length;
    NSRange substrRange = NSMakeRange(beginPos, endPos - beginPos);
    
    NSString* result = [text substringWithRange:substrRange];
    return result;
}


@end