//
//  XcodeComponents.h
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#ifndef Rakufun_XcodeComponents_h
#define Rakufun_XcodeComponents_h

#import <Cocoa/Cocoa.h>

@interface DVTTextStorage : NSTextStorage
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string withUndoManager:(id)undoManager;
- (NSRange)lineRangeForCharacterRange:(NSRange)range;
- (NSRange)characterRangeForLineRange:(NSRange)range;
- (void)indentCharacterRange:(NSRange)range undoManager:(id)undoManager;
@end


@interface IDESourceCodeDocument : NSDocument
    
@property(readonly) DVTTextStorage *textStorage;

@end

@interface IDEEditor : NSObject

@property(readonly) IDESourceCodeDocument *sourceCodeDocument;

@end

@class IDESourceCodeEditor;

@interface IDESourceCodeEditor : IDEEditor
@property (retain) NSTextView *textView;
- (IDESourceCodeDocument *)sourceCodeDocument;
@end


@interface IDEEditorContext : NSObject
@property(retain, nonatomic) IDEEditor *editor;
@end

@interface IDEEditorArea : NSObject

@property(retain, nonatomic) IDEEditorContext *lastActiveEditorContext;

@end


@interface IDEWorkspaceWindowController : NSObject

@property(readonly) IDEEditorArea *editorArea;

@end

#endif
