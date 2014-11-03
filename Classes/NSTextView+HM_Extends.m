//
//  NSTextView+Extends.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "NSTextView+HM_Extends.h"
#import "NSString+HM_Extends.h"
#import "NSString+HM_SourceCode.h"

@implementation NSTextView (HM_Extends)


-(NSInteger)ex_cursolPosition {
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

// カーソル行を返す
-(NSString*)ex_currentLine {
    NSString* line = [self.textStorage.string ex_getLineFromPos:[self ex_cursolPosition]];
    return line;
}

// 現在カーソルの位置のシグネチャを取得する
// 取得できなかったらnilを返す
-(NSString*)ex_currentFunctionSignature {
    NSString* text = self.textStorage.string;
    return [text ex_searchFuncDefinition:[self ex_cursolPosition]];
}


@end