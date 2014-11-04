//
//  XcodeHelper.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "XcodeHelper.h"

@implementation XcodeHelper

// 現在のソースコードエディターを返す
+(IDESourceCodeEditor*)currentEditor {
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController *workspaceController = (IDEWorkspaceWindowController *)currentWindowController;
        IDEEditorArea *editorArea = [workspaceController editorArea];
        IDEEditorContext *editorContext = [editorArea lastActiveEditorContext];
        IDEEditor* editor = (IDEEditor*)[editorContext editor];
        
        if( [editor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")] ) {
            DbgLog(@"(get source code editor");
            return (IDESourceCodeEditor*)editor;
        }
    }
    return nil;
}

+(IDESourceCodeDocument*)currentDocument {
    IDESourceCodeEditor* editor = [self currentEditor];
    if( editor ) {
        return editor.sourceCodeDocument;
    }
    return nil;
}

+ (NSTextView *)currentSourceCodeView {
    IDESourceCodeEditor* editor = [self currentEditor];
    if( editor ) {
        return editor.textView;
    }
    return nil;

}

// ソースファイルとヘッダーファイル間をジャンプ
+(void)moveSourceCode:(id)from {
    [NSApp sendAction:@selector(jumpToPreviousCounterpart:) to:nil from:from];
}

@end
