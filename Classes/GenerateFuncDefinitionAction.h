//
//  GenerateFuncDefinitionAction.h
//  Rakufun
//
//  Created by MURONAKA HIROAKI on 2014/11/04.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "AppKit/AppKit.h"
#import <Foundation/Foundation.h>
#import "XcodeComponents.h"


// objective-cの関数プロトタイプ宣言から、ソースコードの
// テンプレートを生成する
@interface GenerateFuncDefinitionAction : NSObject

@property(nonatomic) NSTextView* sourceCodeView;
@property(nonatomic) IDESourceCodeDocument* sourceDocument;

@end
