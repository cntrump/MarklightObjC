//
//  MarklightTextProcessor.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "MarklightTextProcessor.h"

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "Marklight.h"
#import "NSString+paragraphRangeAt.h"
#import "NSArray+appending.h"
#import "UniversalTypes.h"

@interface MarklightTextProcessor ()

@property(nonatomic,readonly) CGFloat textSize;

@end

@implementation MarklightTextProcessor

- (instancetype)init {
    self = [super init];
    if (self) {
        _syntaxColor = [MarklightColor lightGrayColor];
        _codeFontName = @"Menlo";
        _codeColor = [MarklightColor darkGrayColor];
        _quoteFontName = @"Menlo";
        _quoteColor = [MarklightColor darkGrayColor];
        _quoteIndendation = 20;
        _hideSyntax = NO;
    }

    return self;
}

- (MarklightProcessingResult *)processEditing:(id<MarklightStyleApplier>)styleApplier
                                       string:(NSString *)string
                                  editedRange:(NSRange)editedRange {
    NSRange editedAndAdjacentParagraphRange = [self editedAndAdjacentParagraphRangeInString:string editedRange:editedRange];

    Marklight.syntaxColor = _syntaxColor;
    Marklight.codeFontName = _codeFontName;
    Marklight.codeColor = _codeColor;
    Marklight.quoteFontName = _quoteFontName;
    Marklight.quoteColor = _quoteColor;
    Marklight.quoteIndendation = _quoteIndendation;
    Marklight.textSize = self.textSize;
    Marklight.hideSyntax = _hideSyntax;

    [self resetMarklightAttributes:styleApplier range:editedAndAdjacentParagraphRange];
    [Marklight applyMarkdownStyle:styleApplier string:string affectedRange:editedAndAdjacentParagraphRange];
    
    return [[MarklightProcessingResult alloc] initWithEditedRange:editedRange
                                                    affectedRange:editedAndAdjacentParagraphRange];
}

- (NSRange)editedAndAdjacentParagraphRangeInString:(NSString *)string editedRange:(NSRange)editedRange {
    NSString *nsString = string;
    NSRange editedParagraphRange = [nsString paragraphRangeForRange:editedRange];

    NSRange previousParagraphRange;
    if (editedParagraphRange.location > 0) {
        previousParagraphRange = [nsString paragraphRangeAt:editedParagraphRange.location - 1];
    } else {
        previousParagraphRange = NSMakeRange(editedParagraphRange.location, 0);
    }

    NSRange nextParagraphRange;
    NSInteger locationAfterEditedParagraph = editedParagraphRange.location + editedParagraphRange.length;
    if (locationAfterEditedParagraph < nsString.length) {
        nextParagraphRange = [nsString paragraphRangeAt:locationAfterEditedParagraph];
    } else {
        nextParagraphRange = NSMakeRange(0, 0);
    }

    return NSMakeRange(previousParagraphRange.location, previousParagraphRange.length + editedParagraphRange.length + nextParagraphRange.length);
}

- (void)resetMarklightAttributes:(id<MarklightStyleApplier>)styleApplier range:(NSRange)range {
    [styleApplier resetMarklightTextAttributesTextSize:self.textSize range:range];
}

#if TARGET_OS_IOS

/// Text size measured in points.
- (CGFloat)textSize {
    return [MarklightFontDescriptor preferredFontDescriptorWithTextStyle:[self fontTextStyleValidated]].pointSize;
}

// We are validating the user provided fontTextStyle `String` to match the
// system supported ones.
- (NSString *)fontTextStyleValidated {
    NSMutableArray *baseStyles = [NSMutableArray arrayWithObjects:
                                  UIFontTextStyleHeadline,
                                  UIFontTextStyleSubheadline,
                                  UIFontTextStyleBody,
                                  UIFontTextStyleFootnote,
                                  UIFontTextStyleCaption1,
                                  UIFontTextStyleCaption2,
                                  nil];

    if (@available(iOS 9.0, *)) {
        [baseStyles appendingContentsOf:@[
                                          UIFontTextStyleTitle1,
                                          UIFontTextStyleTitle2,
                                          UIFontTextStyleTitle3,
                                          UIFontTextStyleCallout
                                          ]];
    }

    if (![baseStyles containsObject:self.fontTextStyle]) {
        return UIFontTextStyleBody;
    }

    return self.fontTextStyle;
}

#else

- (CGFloat)textSize {
    return NSFont.systemFontSize;
}

#endif

@end
