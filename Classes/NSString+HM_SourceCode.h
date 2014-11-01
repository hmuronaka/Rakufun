//
//  NSString+SourceCode.h
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/02.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HM_SourceCode)

-(BOOL)ex_isFuncDefinition;
-(NSString*)ex_toDeclaration;
-(NSString*)ex_className;
-(BOOL)ex_hasNotFunctionDeclaration:(NSString*)functionDeclaration inClass:(NSString*)className;
-(NSRange)ex_getClassEndPos:(NSString*)className;

@end
