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
-(NSString*)ex_searchFuncDefinition:(NSInteger)currentPos;
-(BOOL)ex_isFunctionDeclaration;
-(NSString*)ex_toDefinition;
-(BOOL)ex_hasNotFunctionDefinition:(NSString*)functionDeclaration inClass:(NSString*)className;
-(NSRange)ex_getClassInterfaceBeginPos:(NSString*)className;
-(NSRange)ex_getClassInterfaceEndPos:(NSString*)className;
-(NSRange)ex_getClassImplementationEnd:(NSString*)className;

@end
