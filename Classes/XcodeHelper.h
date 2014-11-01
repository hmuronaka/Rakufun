//
//  XcodeHelper.h
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XcodeComponents.h"

@interface XcodeHelper : NSObject

+(IDESourceCodeEditor*)currentEditor;
+(IDESourceCodeDocument*)currentDocument;
+(NSTextView*)currentSourceCodeView;

@end
