//  NSString+EX_Extends.h
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RANGE_IS_NOT_FOUND(range) (NSEqualRanges(range, NSMakeRange(NSNotFound, 0)))
#define RANGE_IS_FOUND(range) (!RANGE_IS_NOT_FOUND(range))

@interface NSString (HM_Extends)

-(NSRange)ex_findWithPattern:(NSString*)pattern;

-(BOOL)ex_isStartChars:(NSString*)characterSet;
-(BOOL)ex_hasCharas:(NSString*)characterSet withOption:(NSStringCompareOptions)options;
-(NSString*)ex_replaceFrom:(NSString*)fromStr to:(NSString*)toStr;
-(NSString*)ex_trimWhitespaces;
-(NSRange)ex_findWithPattern:(NSString*)pattern fromRange:(NSRange)range;
-(NSRange)ex_findWithPattern:(NSString*)pattern fromRange:(NSRange)range andIsBackwward:(BOOL)isBackwards;
-(NSString*)ex_getLineFromPos:(NSInteger)pos;
-(NSString*)ex_escapeMetaCharacters:(NSCharacterSet*)charaSet;

@end
