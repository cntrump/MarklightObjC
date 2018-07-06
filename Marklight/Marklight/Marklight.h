//
//  Marklight.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <Foundation/Foundation.h>
#import "UniversalTypes.h"
#import "MarklightStyleApplier.h"
#import "MarklightRegex.h"
#import "MarklightTextStorage.h"

@interface Marklight : NSObject

/**
 Color used to highlight markdown syntax. Default value is light grey.
 */
@property(class,nonatomic,strong) MarklightColor *syntaxColor;

/**
 Font used for blocks and inline code. Default value is *Menlo*.
 */
@property(class,nonatomic,copy) NSString *codeFontName;

/**
 Color used for blocks and inline code. Default value is dark grey.
 */
@property(class,nonatomic,strong) MarklightColor *codeColor;

/**
 Font used for quote blocks. Default value is *Menlo*.
 */
@property(class,nonatomic,copy) NSString *quoteFontName;

/**
 Color used for quote blocks. Default value is dark grey.
 */
@property(class,nonatomic,strong) MarklightColor *quoteColor;

/**
 Quote indentation in points. Default 20.
 */
@property(class,nonatomic,assign) CGFloat quoteIndendation;

// Transform the quote indentation in the `NSParagraphStyle` required to set
//  the attribute on the `NSAttributedString`.
@property(class,nonatomic,readonly) NSParagraphStyle *quoteIndendationStyle;

/**
 If the markdown syntax should be hidden or visible
 */
@property(class,nonatomic,assign) BOOL hideSyntax;

/**
 Text size measured in points.
 */
@property(class,nonatomic,assign) CGFloat textSize;

/// Tabs are automatically converted to spaces as part of the transform
/// this constant determines how "wide" those tabs become in spaces
@property(class,nonatomic,assign) NSInteger tabWidth;

// MARK: Headers

/*
 Head
 ======

 Subhead
 -------
 */
@property(class,nonatomic,copy) NSString *headerSetextPattern;
@property(class,nonatomic,strong) MarklightRegex *headersSetextRegex;

@property(class,nonatomic,copy) NSString *setextUnderlinePattern;
@property(class,nonatomic,strong) MarklightRegex *headersSetextUnderlineRegex;

/*
 # Head

 ## Subhead ##
 */
@property(class,nonatomic,copy) NSString *headerAtxPattern;
@property(class,nonatomic,strong) MarklightRegex *headersAtxRegex;

@property(class,nonatomic,copy) NSString *headersAtxOpeningPattern;
@property(class,nonatomic,strong) MarklightRegex *headersAtxOpeningRegex;

@property(class,nonatomic,copy) NSString *headersAtxClosingPattern;
@property(class,nonatomic,strong) MarklightRegex *headersAtxClosingRegex;

// MARK: Reference links

/*
 TODO: we don't know how reference links are formed
 */
@property(class,nonatomic,copy) NSString *referenceLinkPattern;
@property(class,nonatomic,strong) MarklightRegex *referenceLinkRegex;

// MARK: Lists

/*
 * First element
 * Second element
 */
@property(class,nonatomic,copy) NSString *markerUL;
@property(class,nonatomic,copy) NSString *markerOL;
@property(class,nonatomic,copy) NSString *listMarker;
@property(class,nonatomic,copy) NSString *wholeList;
@property(class,nonatomic,copy) NSString *listPattern;
@property(class,nonatomic,strong) MarklightRegex *listRegex;
@property(class,nonatomic,strong) MarklightRegex *listOpeningRegex;

// MARK: Anchors

/*
 [Title](http://example.com)
 */
@property(class,nonatomic,copy) NSString *anchorPattern;
@property(class,nonatomic,strong) MarklightRegex *anchorRegex;

@property(class,nonatomic,copy) NSString *opneningSquarePattern;
@property(class,nonatomic,strong) MarklightRegex *openingSquareRegex;

@property(class,nonatomic,copy) NSString *closingSquarePattern;
@property(class,nonatomic,strong) MarklightRegex *closingSquareRegex;

@property(class,nonatomic,copy) NSString *coupleSquarePattern;
@property(class,nonatomic,strong) MarklightRegex *coupleSquareRegex;

@property(class,nonatomic,copy) NSString *coupleRoundPattern;
@property(class,nonatomic,strong) MarklightRegex *coupleRoundRegex;

@property(class,nonatomic,copy) NSString *parenPattern;
@property(class,nonatomic,strong) MarklightRegex *parenRegex;

@property(class,nonatomic,copy) NSString *anchorInlinePattern;
@property(class,nonatomic,strong) MarklightRegex *anchorInlineRegex;

// Mark: Images

/*
 ![Title](http://example.com/image.png)
 */
@property(class,nonatomic,copy) NSString *imagePattern;
@property(class,nonatomic,strong) MarklightRegex *imageRegex;

@property(class,nonatomic,copy) NSString *imageOpeningSquarePattern;
@property(class,nonatomic,strong) MarklightRegex *imageOpeningSquareRegex;

@property(class,nonatomic,copy) NSString *imageClosingSquarePattern;
@property(class,nonatomic,strong) MarklightRegex *imageClosingSquareRegex;

@property(class,nonatomic,copy) NSString *imageInlinePattern;
@property(class,nonatomic,strong) MarklightRegex *imageInlineRegex;

// MARK: Code

/*
 ```
 Code
 ```

 Code
 */
@property(class,nonatomic,copy) NSString *codeBlockPattern;
@property(class,nonatomic,strong) MarklightRegex *codeBlockRegex;

@property(class,nonatomic,copy) NSString *codeSpanPattern;
@property(class,nonatomic,strong) MarklightRegex *codeSpanRegex;

@property(class,nonatomic,copy) NSString *codeSpanOpeningPattern;
@property(class,nonatomic,strong) MarklightRegex *codeSpanOpeningRegex;

@property(class,nonatomic,copy) NSString *codeSpanClosingPattern;
@property(class,nonatomic,strong) MarklightRegex *codeSpanClosingRegex;

// MARK: Block quotes

/*
 > Quoted text
 */
@property(class,nonatomic,copy) NSString *blockQuotePattern;
@property(class,nonatomic,strong) MarklightRegex *blockQuoteRegex;

@property(class,nonatomic,copy) NSString *blockQuoteOpeningPattern;
@property(class,nonatomic,strong) MarklightRegex *blockQuoteOpeningRegex;

// MARK: Bold

/*
 **Bold**
 __Bold__
 */
@property(class,nonatomic,copy) NSString *strictBoldPattern;
@property(class,nonatomic,strong) MarklightRegex *strictBoldRegex;

@property(class,nonatomic,copy) NSString *boldPattern;
@property(class,nonatomic,strong) MarklightRegex *boldRegex;

// MARK: Italic

/*
 *Italic*
 _Italic_
 */
@property(class,nonatomic,copy) NSString *strictItalicPattern;
@property(class,nonatomic,strong) MarklightRegex *strictItalicRegex;

@property(class,nonatomic,copy) NSString *italicPattern;
@property(class,nonatomic,strong) MarklightRegex *italicRegex;

@property(class,nonatomic,copy) NSString *autolinkPattern;
@property(class,nonatomic,strong) MarklightRegex *autolinkRegex;

@property(class,nonatomic,copy) NSString *autolinkPrefixPattern;
@property(class,nonatomic,strong) MarklightRegex *autolinkPrefixRegex;

@property(class,nonatomic,copy) NSString *autolinkEmailPattern;
@property(class,nonatomic,strong) MarklightRegex *autolinkEmailRegex;

@property(class,nonatomic,copy) NSString *mailtoPattern;
@property(class,nonatomic,strong) MarklightRegex *mailtoRegex;

/// maximum nested depth of [] and () supported by the transform;
/// implementation detail
@property(class,nonatomic,assign) NSInteger nestDepth;
@property(class,nonatomic,copy) NSString *nestedBracketsPattern;
@property(class,nonatomic,copy) NSString *nestedParensPattern;

+ (void)applyMarkdownStyle:(id<MarklightStyleApplier>)styleApplier string:(NSString *)string affectedRange:(NSRange)paragraphRange;

@end
