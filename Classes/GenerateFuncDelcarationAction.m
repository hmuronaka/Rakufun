//
//  GenerateFuncDelcarationAction.m
//  Rakufun
//
//  Created by MURONAKA HIROAKI on 2014/11/04.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "GenerateFuncDelcarationAction.h"
#import "NSTextView+HM_Extends.h"
#import "NSString+HM_SourceCode.h"
#import "NSString+HM_Extends.h"
#import "XcodeHelper.h"

@implementation GenerateFuncDelcarationAction

-(id)initWithTextView:(NSTextView*)textView andDocument:(IDESourceCodeDocument*)document {
    self = [super init];
    if(self) {
        self.sourceCodeView = textView;
        self.sourceCodeDocument = document;
    }
    return self;
}

-(void)run {
    // シグネチャを取得する
    NSString* signatureStr = [self.sourceCodeView ex_currentFunctionSignature];
    DbgLog(@"signature=%@", signatureStr);
    
    // 現在のカーソル行が、関数定義であれば、ヘッダーに関数宣言を追加する
    if( signatureStr != nil ) {
        // ソースファイルからヘッダーファイルにジャンプ
        [XcodeHelper moveSourceCode:self];
        
        // ヘッダーを解析する
        NSTextView* headerView = [XcodeHelper currentSourceCodeView];
        NSString* headerText = headerView.textStorage.string;
        NSString* className = [self.sourceCodeDocument.fileURL.absoluteString ex_className];
        NSString* declStr = [signatureStr ex_toDeclaration];
        BOOL hasNotFunction = [headerText ex_hasNotFunctionDeclaration:declStr inClass:className];
        DbgLog(@"has decl=%d class=%@", hasNotFunction, className);
        
        // ヘッダーに関数定義が無い場合にのみ追加する
        // *ただしコメントアウト行は考慮しない。
        if(hasNotFunction) {
            NSRange endPoint = [headerText ex_getClassInterfaceEndPos:className];
            if( RANGE_IS_FOUND(endPoint) ) {
                endPoint.length = 0;
                [headerView insertText:[declStr stringByAppendingString:@"\n"] replacementRange:endPoint];
            }
        }
        // ソースコードに戻る
        [XcodeHelper moveSourceCode:self];
    }
}

@end
