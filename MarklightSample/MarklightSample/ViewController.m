//
//  ViewController.m
//  MarklightSample
//
//  Created by vvveiii on 2018/7/5.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "ViewController.h"
#import <Marklight/MarklightTextStorage.h>

@interface ViewController () {
    UITextView *_textView;
}

@property(nonatomic,copy) MarklightTextStorage *textStorage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = NSLocalizedString(@"Marklight", nil);

    self.textStorage = [[MarklightTextStorage alloc] init];
    self.textStorage.marklightTextProcessor.codeColor = [UIColor orangeColor];
    self.textStorage.marklightTextProcessor.quoteColor = [UIColor darkGrayColor];
    self.textStorage.marklightTextProcessor.syntaxColor = [UIColor blueColor];
    self.textStorage.marklightTextProcessor.codeFontName = @"Courier";
    self.textStorage.marklightTextProcessor.fontTextStyle = UIFontTextStyleSubheadline;
    self.textStorage.marklightTextProcessor.hideSyntax = NO;

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];

    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];

    _textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:textContainer];
    [self.view addSubview:_textView];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"md"];
    NSString *md = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    _textView.text = md;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
