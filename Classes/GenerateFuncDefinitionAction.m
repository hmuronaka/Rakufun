//
//  GenerateFuncDefinitionAction.m
//  Rakufun
//
//  Created by MURONAKA HIROAKI on 2014/11/04.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "GenerateFuncDefinitionAction.h"
#import "NSString+HM_Extends.h"
#import "NSString+HM_SourceCode.h"
#import "NSTextView+HM_Extends.h"
#import "XcodeHelper.h"

@implementation GenerateFuncDefinitionAction

-(id)initWithNSTextView:(NSTextView*)textView andDocument:(IDESourceCodeDocument*)document  {
    self = [super init];
    if( self ) {
        self.sourceCodeView = textView;
        self.sourceDocument = document;
    }
    return self;
}

// カーソル行が関数のプロトタイプ宣言の場合、trueを返す。
-(BOOL)isEnable {
    return [[self.sourceCodeView ex_currentLine] ex_isFunctionDeclaration];
}

-(void)action {
    // expect isEnable == YES
    
    NSString* declaration = [self.sourceCodeView ex_currentLine];
    
    // ソースコード上に関数定義が存在するかチェックする
    [XcodeHelper moveSourceCode:self];
    
    NSTextView* sourceView = [XcodeHelper currentSourceCodeView];
    NSString* sourceText = sourceView.textStorage.string;
    NSString* className = [self.sourceDocument.fileURL.absoluteString ex_className];
    NSString* definition = [declaration ex_toDefinition];
    BOOL hasNotFunction = [sourceText ex_hasNotFunctionDefinition:declaration inClass:className];
    DbgLog(@"has decl=%d class=%@", hasNotFunction, className);
    
    // ヘッダーに関数定義が無い場合にのみ追加する
    // *ただしコメントアウト行は考慮しない。
    if(hasNotFunction) {
        NSRange endPoint = [sourceText ex_getClassImplementationEnd:className];
        if( RANGE_IS_FOUND(endPoint) ) {
            endPoint.length = 0;
            [sourceView insertText:[definition stringByAppendingString:@"\n"] replacementRange:endPoint];
        }
    }
    // ソースコードに戻る
    [XcodeHelper moveSourceCode:self];
}
@end
