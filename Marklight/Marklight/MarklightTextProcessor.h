//
//  MarklightTextProcessor.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversalTypes.h"
#import "MarklightStyleApplier.h"
#import "MarklightTextProcessingResult.h"

@interface MarklightTextProcessor : NSObject

// MARK: Syntax highlight customisation

/**
 Color used to highlight markdown syntax. Default value is light grey.
 */
@property(nonatomic,strong) MarklightColor *syntaxColor;

/**
 Font used for blocks and inline code. Default value is *Menlo*.
 */
@property(nonatomic,copy) NSString *codeFontName;

/**
 `MarklightColor` used for blocks and inline code. Default value is dark grey.
 */
@property(nonatomic,strong) MarklightColor *codeColor;

/**
 Font used for quote blocks. Default value is *Menlo*.
 */
@property(nonatomic,copy) NSString *quoteFontName;

/**
 `MarklightColor` used for quote blocks. Default value is dark grey.
 */
@property(nonatomic,strong) MarklightColor *quoteColor;

/**
 Quote indentation in points. Default 20.
 */
@property(nonatomic,assign) CGFloat quoteIndendation;

/**
 If the markdown syntax should be hidden or visible
 */
@property(nonatomic,assign) BOOL hideSyntax;

#if TARGET_OS_IPHONE

// MARK: Font Style Settings

/**
 Dynamic type font text style, default `UIFontTextStyleBody`.

 - see: [Text Styles](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/UIFontDescriptor_Class/index.html#//apple_ref/doc/constant_group/Text_Styles)
 */
@property(nonatomic,assign) UIFontTextStyle fontTextStyle;

#endif

// MARK: Syntax highlighting

- (MarklightProcessingResult *)processEditing:(id<MarklightStyleApplier>)styleApplier
                                       string:(NSString *)string
                                  editedRange:(NSRange)editedRange;
@end
