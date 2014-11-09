//
//  GenerateFuncDelcarationAction.h
//  Rakufun
//
//  Created by MURONAKA HIROAKI on 2014/11/04.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "XcodeComponents.h"

@interface GenerateFuncDelcarationAction : NSObject

@property(nonatomic) NSTextView* sourceCodeView;
@property(nonatomic) IDESourceCodeDocument* sourceCodeDocument;

-(id)initWithTextView:(NSTextView*)textView andDocument:(IDESourceCodeDocument*)document;
-(void)run;
@end
