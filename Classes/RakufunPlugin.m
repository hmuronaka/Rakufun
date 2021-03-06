//
//  Rakufun.m
//  Rakufun
//
//  Created by Muronaka Hiroaki on 2014/11/01.
//  Copyright (c) 2014年 Muronaka Hiroaki. All rights reserved.
//

#import "RakufunPlugin.h"
#import <AppKit/AppKit.h>
#import "XcodeComponents.h"
#import "NSTextView+HM_Extends.h"
#import "XcodeHelper.h"
#import "NSString+HM_Extends.h"
#import "NSString+HM_SourceCode.h"
#import "GenerateFuncDefinitionAction.h"
#import "GenerateFuncDelcarationAction.h"

// メニューのショートカットキー
// 必要に応じて変更してください.
// CTRL + DEFAULT_KEY
#define DEFAULT_KEY (@"m")

@interface RakufunPlugin ()

// 解析対象とする拡張子
@property(nonatomic,strong) NSArray* targetExtensions;

@end

@implementation RakufunPlugin


static RakufunPlugin* _sharedInstance = nil;

#pragma mark entry point this plugin.

+(void)pluginDidLoad:(NSBundle*)plugin {
    DbgLog(@"load Rakufun!");
    [self sharedInstance];
}


#pragma mark class methods.

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark instance methods.

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetExtensions = @[@"m", @"mm"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

-(void)applicationDidFinishLaunching:(NSNotification*)noti {
    [self initMenu];
}

-(void)initMenu {
    [self createMenuItemWithName:@"Rakufun" action:@selector(clickMenu:) parentMenuName:@"Edit"];
}

-(NSMenuItem*)createMenuItemWithName:(NSString*)name action:(SEL)action parentMenuName:(NSString*)parent {
    NSMenu* mainMenu = [NSApp mainMenu];
    
    NSMenuItem* parentItem = [mainMenu itemWithTitle:parent];
    NSMenuItem* childItem = [[NSMenuItem alloc] initWithTitle:name action:action keyEquivalent:DEFAULT_KEY];
    [childItem setKeyEquivalentModifierMask:NSControlKeyMask];
    [childItem setTarget:self];
    [[parentItem submenu] addItem:childItem];
    return childItem;
}

-(void)clickMenu:(id)sender {
    [self generateDeclaration];
}

// 関数定義から関数宣言を生成して、ヘッダーファイルに追加する。
-(void)generateDeclaration {
    NSTextView* textView = [XcodeHelper currentSourceCodeView];
    if( textView == nil ) {
        DbgLog(@"textView is nil");
        return;
    }
    
    IDESourceCodeDocument* document = [XcodeHelper currentDocument];
    NSString* pathExtension = [document.fileURL.absoluteString pathExtension];
    DbgLog(@"fileType=%@", pathExtension);
    
    if( [@[@"m", @"mm"] containsObject:pathExtension] ) {
        if( [textView ex_currentFunctionSignature] != nil ) {
            GenerateFuncDelcarationAction* action = [[GenerateFuncDelcarationAction alloc] initWithTextView:textView andDocument:document];
            [action run];
        }
    } else if( [@[@"h"] containsObject:pathExtension] ) {
        DbgLog(@"This is header");
        if( [textView ex_currentIsFuncDeclaration] ) {
            DbgLog(@"currentFunctionSignature=%@", [textView ex_currentLine]);
            GenerateFuncDefinitionAction* action = [[GenerateFuncDefinitionAction alloc] initWithTextView:textView andDocument:document];
            [action run];
        }
    }
    
    
    
//    // シグネチャを取得する
//    NSString* signatureStr = [textView ex_currentFunctionSignature];
//    DbgLog(@"signature=%@", signatureStr);
//    
//    // 現在のカーソル行が、関数定義であれば、ヘッダーに関数宣言を追加する
//    if( signatureStr != nil ) {
//        // ソースファイルからヘッダーファイルにジャンプ
//        [XcodeHelper moveSourceCode:self];
//        
//        // ヘッダーを解析する
//        NSTextView* headerView = [XcodeHelper currentSourceCodeView];
//        NSString* headerText = headerView.textStorage.string;
//        NSString* className = [document.fileURL.absoluteString ex_className];
//        NSString* declStr = [signatureStr ex_toDeclaration];
//        BOOL hasNotFunction = [headerText ex_hasNotFunctionDeclaration:declStr inClass:className];
//        DbgLog(@"has decl=%d class=%@", hasNotFunction, className);
//        
//        // ヘッダーに関数定義が無い場合にのみ追加する
//        // *ただしコメントアウト行は考慮しない。
//        if(hasNotFunction) {
//            NSRange endPoint = [headerText ex_getClassInterfaceEndPos:className];
//            if( RANGE_IS_FOUND(endPoint) ) {
//                endPoint.length = 0;
//                [headerView insertText:[declStr stringByAppendingString:@"\n"] replacementRange:endPoint];
//            }
//        }
//        // ソースコードに戻る
//        [XcodeHelper moveSourceCode:self];
//    }
}

// 生成対象の拡張子か
-(BOOL)isTargetExtension:(NSString*)extension {
    return [self.targetExtensions containsObject:extension];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
