//
//  ViewController.m
//  MarklightSample macOS
//
//  Created by vvveiii on 2018/7/5.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "ViewController.h"
#import <Marklight_macOS/MarklightTextStorage.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 550, 780)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    MarklightTextStorage *textStorage = [[MarklightTextStorage alloc] init];
    textStorage.marklightTextProcessor.codeColor = [NSColor orangeColor];
    textStorage.marklightTextProcessor.quoteColor = [NSColor darkGrayColor];
    textStorage.marklightTextProcessor.syntaxColor = [NSColor blueColor];
    textStorage.marklightTextProcessor.codeFontName = @"Courier";
    textStorage.marklightTextProcessor.hideSyntax = NO;

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];

    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];

    // Setting Up the Scroll View
    NSScrollView *scrollview = [[NSScrollView alloc] initWithFrame:self.view.frame];
    NSSize contentSize = scrollview.contentSize;
    scrollview.borderType = NSNoBorder;
    scrollview.hasVerticalScroller = YES;
    scrollview.hasHorizontalScroller = NO;
    scrollview.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    // Setting Up the Text View
    NSTextView *textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height) textContainer:textContainer];
    textView.minSize = NSMakeSize(0.0, contentSize.height);
    textView.maxSize = NSMakeSize(FLT_MAX, FLT_MAX);
    textView.verticallyResizable = YES;
    textView.horizontallyResizable = NO;
    textView.autoresizingMask = NSViewWidthSizable;
    textView.textContainer.containerSize = NSMakeSize(contentSize.width, FLT_MAX);
    textView.textContainer.widthTracksTextView = YES;

    scrollview.documentView = textView;
    [self.view addSubview:scrollview];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"md"];
    NSString *md = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    textView.string = md;
}

@end
