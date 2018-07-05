//
//  Marklight.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "Marklight.h"

static NSString *repeatString(NSString *text, NSUInteger count) {
    NSString *result = @"";
    for (NSUInteger i = 0; i < count; i++) {
        result = [result stringByAppendingString:text];
    }

    return result;
}

@implementation Marklight

static MarklightColor *_syntaxColor;
static NSString *_codeFontName;
static MarklightColor *_codeColor;
static NSString *_quoteFontName;
static MarklightColor *_quoteColor;
static CGFloat _quoteIndendation = 20;
static BOOL _hideSyntax = NO;
static CGFloat _textSize;
static NSInteger _tabWidth = 4;

static NSString *_headerSetextPattern;
static MarklightRegex *_headersSetextRegex;

static NSString *_setextUnderlinePattern;
static MarklightRegex *_headersSetextUnderlineRegex;

static NSString *_headerAtxPattern;
static MarklightRegex *_headersAtxRegex;

static NSString *_headersAtxOpeningPattern;
static MarklightRegex *_headersAtxOpeningRegex;

static NSString *_headersAtxClosingPattern;
static MarklightRegex *_headersAtxClosingRegex;

static NSString *_referenceLinkPattern;
static MarklightRegex *_referenceLinkRegex;

static NSString *_markerUL;
static NSString *_markerOL;
static NSString *_listMarker;
static NSString *_wholeList;
static NSString *_listPattern;
static MarklightRegex *_listRegex;
static MarklightRegex *_listOpeningRegex;

static NSString *_anchorPattern;
static MarklightRegex *_anchorRegex;

static NSString *_opneningSquarePattern;
static MarklightRegex *_openingSquareRegex;

static NSString *_closingSquarePattern;
static MarklightRegex *_closingSquareRegex;

static NSString *_coupleSquarePattern;
static MarklightRegex *_coupleSquareRegex;

static NSString *_coupleRoundPattern;
static MarklightRegex *_coupleRoundRegex;

static NSString *_parenPattern;
static MarklightRegex *_parenRegex;

static NSString *_anchorInlinePattern;
static MarklightRegex *_anchorInlineRegex;

static NSString *_imagePattern;
static MarklightRegex *_imageRegex;

static NSString *_imageOpeningSquarePattern;
static MarklightRegex *_imageOpeningSquareRegex;

static NSString *_imageClosingSquarePattern;
static MarklightRegex *_imageClosingSquareRegex;

static NSString *_imageInlinePattern;
static MarklightRegex *_imageInlineRegex;

static NSString *_codeBlockPattern;
static MarklightRegex *_codeBlockRegex;

static NSString *_codeSpanPattern;
static MarklightRegex *_codeSpanRegex;

static NSString *_codeSpanOpeningPattern;
static MarklightRegex *_codeSpanOpeningRegex;

static NSString *_codeSpanClosingPattern;
static MarklightRegex *_codeSpanClosingRegex;

static NSString *_blockQuotePattern;
static MarklightRegex *_blockQuoteRegex;

static NSString *_blockQuoteOpeningPattern;
static MarklightRegex *_blockQuoteOpeningRegex;

static NSString *_strictBoldPattern;
static MarklightRegex *_strictBoldRegex;

static NSString *_boldPattern;
static MarklightRegex *_boldRegex;

static NSString *_strictItalicPattern;
static MarklightRegex *_strictItalicRegex;

static NSString *_italicPattern;
static MarklightRegex *_italicRegex;

static NSString *_autolinkPattern;
static MarklightRegex *_autolinkRegex;

static NSString *_autolinkPrefixPattern;
static MarklightRegex *_autolinkPrefixRegex;

static NSString *_autolinkEmailPattern;
static MarklightRegex *_autolinkEmailRegex;

static NSString *_mailtoPattern;
static MarklightRegex *_mailtoRegex;

static NSInteger _nestDepth = 6;
static NSString *_nestedBracketsPattern;
static NSString *_nestedParensPattern;

/**
 Color used to highlight markdown syntax. Default value is light grey.
 */
+ (MarklightColor *)syntaxColor {
    if (!_syntaxColor) {
        _syntaxColor = [MarklightColor lightGrayColor];
    }

    return _syntaxColor;
}

+ (void)setSyntaxColor:(MarklightColor *)syntaxColor {
    _syntaxColor = syntaxColor;
}

/**
 Font used for blocks and inline code. Default value is *Menlo*.
 */
+ (NSString *)codeFontName {
    if (!_codeFontName) {
        _codeFontName = @"Menlo";
    }

    return _codeFontName;
}

+ (void)setCodeFontName:(NSString *)codeFontName {
    _codeFontName = codeFontName;
}

/**
 Color used for blocks and inline code. Default value is dark grey.
 */
+ (MarklightColor *)codeColor {
    if (!_codeColor) {
        _codeColor = [MarklightColor darkGrayColor];
    }

    return _codeColor;
}

+ (void)setCodeColor:(MarklightColor *)codeColor {
    _codeColor = codeColor;
}

/**
 Font used for quote blocks. Default value is *Menlo*.
 */
+ (NSString *)quoteFontName {
    if (!_quoteFontName) {
        _quoteFontName = @"Menlo";
    }

    return _quoteFontName;
}

+ (void)setQuoteFontName:(NSString *)quoteFontName {
    _quoteFontName = quoteFontName;
}

/**
 Color used for quote blocks. Default value is dark grey.
 */
+ (MarklightColor *)quoteColor {
    if (!_quoteColor) {
        _quoteColor = [MarklightColor darkGrayColor];
    }

    return _quoteColor;
}

+ (void)setQuoteColor:(MarklightColor *)quoteColor {
    _quoteColor = quoteColor;
}

/**
 Quote indentation in points. Default 20.
 */
+ (CGFloat)quoteIndendation {
    return _quoteIndendation;
}

+ (void)setQuoteIndendation:(CGFloat)quoteIndendation {
    _quoteIndendation = quoteIndendation;
}

/**
 If the markdown syntax should be hidden or visible
 */
+ (BOOL)hideSyntax {
    return _hideSyntax;
}

+ (void)setHideSyntax:(BOOL)hideSyntax {
    _hideSyntax = hideSyntax;
}

/**
 Text size measured in points.
 */
+ (CGFloat)textSize {
    if (_textSize == 0) {
        _textSize = [MarklightFont systemFontSize];
    }

    return _textSize;
}

+ (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
}

// We transform the user provided `codeFontName` `String` to a `NSFont`
+ (MarklightFont *)codeFont:(CGFloat)size {
    MarklightFont *font = [MarklightFont fontWithName:Marklight.codeFontName size:size];
    if (!font) {
        font = [MarklightFont systemFontOfSize:size];
    }

    return font;
}

// We transform the user provided `quoteFontName` `String` to a `NSFont`
+ (MarklightFont *)quoteFont:(CGFloat)size {
    MarklightFont *font = [MarklightFont fontWithName:Marklight.quoteFontName size:size];
    if (!font) {
        font = [MarklightFont systemFontOfSize:size];
    }

    return font;
}

// Transform the quote indentation in the `NSParagraphStyle` required to set
//  the attribute on the `NSAttributedString`.
+ (NSParagraphStyle *)quoteIndendationStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = Marklight.quoteIndendation;

    return paragraphStyle;
}

// MARK: Processing

/**
 This function should be called by the `-processEditing` method in your
 `NSTextStorage` subclass and this is the function that is being called
 for every change in the text view's text.

 - parameter styleApplier: `MarklightStyleApplier`, for example
 your `NSTextStorage` subclass.
 - parameter string: The text that should be scanned for styling.
 - parameter affectedRange: The range to apply styling to.
 */
+ (void)applyMarkdownStyle:(id<MarklightStyleApplier>)styleApplier string:(NSString *)string affectedRange:(NSRange)paragraphRange {
    NSString *textStorageNSString = string;
    NSRange wholeRange = NSMakeRange(0, textStorageNSString.length);

    MarklightFont *codeFont = [Marklight codeFont:_textSize];
    MarklightFont *quoteFont = [Marklight quoteFont:_textSize];
    MarklightFont *boldFont = [MarklightFont boldSystemFontOfSize:_textSize];
    MarklightFont *italicFont = [MarklightFont italicSystemFontOfSize:_textSize];

    MarklightFont *hiddenFont = [MarklightFont systemFontOfSize:0.1];
    MarklightColor *hiddenColor = [MarklightColor clearColor];
    NSDictionary<NSAttributedStringKey,id> *hiddenAttributes = @{
                                                                 NSFontAttributeName: hiddenFont,
                                                                 NSForegroundColorAttributeName: hiddenColor
                                                                 };
    void (^hideSyntaxIfNecessary)(NSRange range) = ^(NSRange range) {
        if (!Marklight.hideSyntax) {
            return;
        }

        [styleApplier addAttributes:hiddenAttributes range:range];
    };

    // We detect and process underlined headers
    [Marklight.headersSetextRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:boldFont range:range];
        [Marklight.headersSetextUnderlineRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(NSMakeRange(innerRange.location, innerRange.length));
        }];
    }];

    // We detect and process dashed headers
    [Marklight.headersAtxRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }
        
        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:boldFont range:range];
        [Marklight.headersAtxOpeningRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            NSRange syntaxRange = NSMakeRange(innerRange.location, innerRange.length + 1);
            hideSyntaxIfNecessary(syntaxRange);
        }];
        [Marklight.headersAtxClosingRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];
    }];

    // We detect and process reference links
    [Marklight.referenceLinkRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:range];
    }];

    // We detect and process lists
    [Marklight.listRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [Marklight.listOpeningRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
        }];
    }];

    // We detect and process anchors (links)
    [Marklight.anchorRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];
        [Marklight.openingSquareRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
        }];

        [Marklight.closingSquareRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
        }];

        [Marklight.parenRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            NSRange initialSyntaxRange = NSMakeRange(innerRange.location, 1);
            NSRange finalSyntaxRange = NSMakeRange(innerRange.location + innerRange.length - 1, 1);
            hideSyntaxIfNecessary(initialSyntaxRange);
            hideSyntaxIfNecessary(finalSyntaxRange);
        }];
    }];

    // We detect and process inline anchors (links)
    [Marklight.anchorInlineRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];

        __block NSString *destinationLink = nil;
        [Marklight.coupleRoundRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            NSRange _range = innerRange;
            _range.location = range.location + 1;
            _range.length = range.length - 2;

            NSString *substring = [textStorageNSString substringWithRange:_range];
            if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
                return;
            }

            destinationLink = substring;
            [styleApplier addAttribute:NSLinkAttributeName value:substring range:_range];

            hideSyntaxIfNecessary(innerRange);
        }];

        [Marklight.openingSquareRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];

        [Marklight.closingSquareRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];

        NSString *destinationLinkString = destinationLink;
        if (!destinationLinkString) {
            return;
        }

        [Marklight.coupleSquareRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            NSRange _range = innerRange;
            _range.location = _range.location + 1;
            _range.length = _range.length - 2;

            NSString *substring = [textStorageNSString substringWithRange:_range];
            if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
                return;
            }

            [styleApplier addAttribute:NSLinkAttributeName value:destinationLinkString range:_range];
        }];
    }];

    [Marklight.imageRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];

        // TODO: add image attachment
        if (Marklight.hideSyntax) {
            [styleApplier addAttribute:NSFontAttributeName value:hiddenFont range:range];
        }

        [Marklight.imageOpeningSquareRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
        }];

        [Marklight.imageClosingSquareRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
        }];
    }];

    // We detect and process inline images
    [Marklight.imageInlineRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];

        // TODO: add image attachment

        hideSyntaxIfNecessary(range);

        [Marklight.imageOpeningSquareRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            // FIXME: remove syntax and add image
        }];

        [Marklight.imageClosingSquareRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            // FIXME: remove syntax and add image
        }];

        [Marklight.parenRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            // FIXME: remove syntax and add image
        }];
    }];

    // We detect and process inline code
    [Marklight.codeSpanRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.codeColor range:range];

        [Marklight.codeSpanOpeningRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];

        [Marklight.codeSpanClosingRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];
    }];

    // We detect and process code blocks
    [Marklight.codeBlockRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:codeFont range:range];
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.codeColor range:range];
    }];

    // We detect and process quotes
    [Marklight.blockQuoteRegex matches:string range:wholeRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:quoteFont range:range];
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.quoteColor range:range];
        [styleApplier addAttribute:NSParagraphStyleAttributeName value:Marklight.quoteIndendationStyle range:range];
        [Marklight.blockQuoteOpeningRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
            if (!result) {
                return;
            }

            NSRange innerRange = result.range;
            [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:innerRange];
            hideSyntaxIfNecessary(innerRange);
        }];
    }];

    // We detect and process strict italics
    [Marklight.strictItalicRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:italicFont range:range];
        NSString *substring = [textStorageNSString substringWithRange:NSMakeRange(range.location, 1)];
        NSInteger start = 0;
        if ([substring isEqualToString:@" "]) {
            start = 1;
        }

        NSRange preRange = NSMakeRange(range.location + start, 1);
        hideSyntaxIfNecessary(preRange);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:preRange];

        NSRange postRange = NSMakeRange(range.location + range.length - 1, 1);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:postRange];
        hideSyntaxIfNecessary(postRange);
    }];

    // We detect and process strict bolds
    [Marklight.strictBoldRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:boldFont range:range];
        NSString *substring = [textStorageNSString substringWithRange:NSMakeRange(range.location, 1)];
        NSInteger start = 0;
        if ([substring isEqualToString:@" "]) {
            start = 1;
        }

        NSRange preRange = NSMakeRange(range.location + start, 2);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:preRange];
        hideSyntaxIfNecessary(preRange);

        NSRange postRange = NSMakeRange(range.location + range.length - 2, 2);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:postRange];
        hideSyntaxIfNecessary(postRange);
    }];

    // We detect and process italics
    [Marklight.italicRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:italicFont range:range];

        NSRange preRange = NSMakeRange(range.location, 1);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:preRange];
        hideSyntaxIfNecessary(preRange);

        NSRange postRange = NSMakeRange(range.location + range.length - 1, 1);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:postRange];
        hideSyntaxIfNecessary(postRange);
    }];

    // We detect and process bolds
    [Marklight.boldRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        [styleApplier addAttribute:NSFontAttributeName value:boldFont range:range];

        NSRange preRange = NSMakeRange(range.location, 2);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:preRange];
        hideSyntaxIfNecessary(preRange);

        NSRange postRange = NSMakeRange(range.location + range.length - 2, 2);
        [styleApplier addAttribute:NSForegroundColorAttributeName value:Marklight.syntaxColor range:postRange];
        hideSyntaxIfNecessary(postRange);
    }];

    // We detect and process inline links not formatted
    [Marklight.autolinkRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        NSString *substring = [textStorageNSString substringWithRange:range];
        if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
            return;
        }

        [styleApplier addAttribute:NSLinkAttributeName value:substring range:range];

        if (Marklight.hideSyntax) {
            [Marklight.autolinkPrefixRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
                if (!result) {
                    return;
                }

                NSRange innerRange = result.range;
                [styleApplier addAttribute:NSFontAttributeName value:hiddenFont range:innerRange];
                [styleApplier addAttribute:NSForegroundColorAttributeName value:hiddenColor range:innerRange];
            }];
        }
    }];

    // We detect and process inline mailto links not formatted
    [Marklight.autolinkEmailRegex matches:string range:paragraphRange completion:^(NSTextCheckingResult *result) {
        if (!result) {
            return;
        }

        NSRange range = result.range;
        NSString *substring = [textStorageNSString substringWithRange:range];
        if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
            return;
        }

        [styleApplier addAttribute:NSLinkAttributeName value:substring range:range];

        if (Marklight.hideSyntax) {
            [Marklight.mailtoRegex matches:string range:range completion:^(NSTextCheckingResult *result) {
                if (!result) {
                    return;
                }

                NSRange innerRange = result.range;
                [styleApplier addAttribute:NSFontAttributeName value:hiddenFont range:innerRange];
                [styleApplier addAttribute:NSForegroundColorAttributeName value:hiddenColor range:innerRange];
            }];
        }
    }];
}

+ (void)setTabWidth:(NSInteger)tabWidth {
    _tabWidth = tabWidth;
}

+ (NSInteger)tabWidth {
    return _tabWidth;
}

+ (NSString *)headerSetextPattern {
    if (!_headerSetextPattern) {
        _headerSetextPattern = [@[
                                 @"^(.+?)",
                                 @"\\p{Z}*",
                                 @"\\n",
                                 @"(=+|-+)",  // $1 = string of ='s or -'s
                                 @"\\p{Z}*",
                                 @"\\n+"
                                 ] componentsJoinedByString:@"\n"];
    }

    return _headerSetextPattern;
}

+ (void)setHeaderSetextPattern:(NSString *)headerSetextPattern {
    _headerSetextPattern = headerSetextPattern;
}

+ (MarklightRegex *)headersSetextRegex {
    if (!_headersSetextRegex) {
        _headersSetextRegex = [[MarklightRegex alloc] initWithPattern:Marklight.headerSetextPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _headersSetextRegex;
}

+ (void)setHeadersSetextRegex:(MarklightRegex *)headersSetextRegex {
    _headersSetextRegex = headersSetextRegex;
}

+ (NSString *)setextUnderlinePattern {
    if (!_setextUnderlinePattern) {
        _setextUnderlinePattern = [@[
                                     @"(==+|--+)     # $1 = string of ='s or -'s",
                                     @"\\p{Z}*$"
                                  ] componentsJoinedByString:@"\n"];
    }

    return _setextUnderlinePattern;
}

+ (void)setSetextUnderlinePattern:(NSString *)setextUnderlinePattern {
    _setextUnderlinePattern = setextUnderlinePattern;
}

+ (MarklightRegex *)headersSetextUnderlineRegex {
    if (!_headersSetextUnderlineRegex) {
        _headersSetextUnderlineRegex = [[MarklightRegex alloc] initWithPattern:Marklight.setextUnderlinePattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _headersSetextUnderlineRegex;
}

+ (void)setHeadersSetextUnderlineRegex:(MarklightRegex *)headersSetextUnderlineRegex {
    _headersSetextUnderlineRegex = headersSetextUnderlineRegex;
}

+ (NSString *)headerAtxPattern {
    if (!_headerAtxPattern) {
        _headerAtxPattern = [@[
                              @"^(\\#{1,6})  # $1 = string of #'s",
                              @"\\p{Z}*",
                              @"(.+?)        # $2 = Header text",
                              @"\\p{Z}*",
                              @"\\#*         # optional closing #'s (not counted)",
                              @"\\n+"
                              ] componentsJoinedByString:@"\n"];
    }

    return _headerAtxPattern;
}

+ (void)setHeaderAtxPattern:(NSString *)headerAtxPattern {
    _headerSetextPattern = headerAtxPattern;
}

+ (MarklightRegex *)headersAtxRegex {
    if (!_headersAtxRegex) {
        _headersAtxRegex = [[MarklightRegex alloc] initWithPattern:Marklight.headerAtxPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _headersAtxRegex;
}

+ (void)setHeadersAtxRegex:(MarklightRegex *)headersAtxRegex {
    _headersAtxRegex = headersAtxRegex;
}

+ (NSString *)headersAtxOpeningPattern {
    if (!_headersAtxOpeningPattern) {
        _headersAtxOpeningPattern = [@[
                                       @"^(\\#{1,6})"
                                       ] componentsJoinedByString:@"\n"];
    }

    return _headersAtxOpeningPattern;
}

+ (void)setHeadersAtxOpeningPattern:(NSString *)headersAtxOpeningPattern {
    _headersAtxOpeningPattern = headersAtxOpeningPattern;
}

+ (MarklightRegex *)headersAtxOpeningRegex {
    if (!_headersAtxOpeningRegex) {
        _headersAtxOpeningRegex = [[MarklightRegex alloc] initWithPattern:Marklight.headersAtxOpeningPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _headersAtxOpeningRegex;
}

+ (void)setHeadersAtxOpeningRegex:(MarklightRegex *)headersAtxOpeningRegex {
    _headersAtxOpeningRegex = headersAtxOpeningRegex;
}

+ (NSString *)headersAtxClosingPattern {
    if (!_headersAtxClosingPattern) {
        _headersAtxClosingPattern = [@[
                                       @"\\#{1,6}\\n+"
                                       ] componentsJoinedByString:@"\n"];
    }

    return _headersAtxClosingPattern;
}

+ (void)setHeadersAtxClosingPattern:(NSString *)headersAtxClosingPattern {
    _headersAtxClosingPattern = headersAtxClosingPattern;
}

+ (MarklightRegex *)headersAtxClosingRegex {
    if (!_headersAtxClosingRegex) {
        _headersAtxClosingRegex = [[MarklightRegex alloc] initWithPattern:Marklight.headersAtxClosingPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _headersAtxClosingRegex;
}

+ (void)setHeadersAtxClosingRegex:(MarklightRegex *)headersAtxClosingRegex {
    _headersAtxClosingRegex = headersAtxClosingRegex;
}

+ (NSString *)referenceLinkPattern {
    if (!_referenceLinkPattern) {
        _referenceLinkPattern = [@[
                                   [NSString stringWithFormat:@"^\\p{Z}{0,%ld}\\[([^\\[\\]]+)\\]:  # id = $1", Marklight.tabWidth - 1],
                                   @"  \\p{Z}*",
                                   @"  \\n?                   # maybe *one* newline",
                                   @"  \\p{Z}*",
                                   @"<?(\\S+?)>?              # url = $2",
                                   @"  \\p{Z}*",
                                   @"  \\n?                   # maybe one newline",
                                   @"  \\p{Z}*",
                                   @"(?:",
                                   @"    (?<=\\s)             # lookbehind for whitespace",
                                   @"    [\"(]",
                                   @"    (.+?)                # title = $3",
                                   @"    [\")]",
                                   @"    \\p{Z}*",
                                   @")?                       # title is optional",
                                   @"(?:\\n+|\\Z)"
                                    ] componentsJoinedByString:@""];
    }

    return _referenceLinkPattern;
}

+ (void)setReferenceLinkPattern:(NSString *)referenceLinkPattern {
    _referenceLinkPattern = referenceLinkPattern;
}

+ (MarklightRegex *)referenceLinkRegex {
    if (!_referenceLinkRegex) {
        _referenceLinkRegex = [[MarklightRegex alloc] initWithPattern:Marklight.referenceLinkPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _referenceLinkRegex;
}

+ (void)setReferenceLinkRegex:(MarklightRegex *)referenceLinkRegex {
    _referenceLinkRegex = referenceLinkRegex;
}

+ (NSString *)markerUL {
    if (!_markerUL) {
        _markerUL = @"[*+-]";
    }

    return _markerUL;
}

+ (void)setMarkerUL:(NSString *)markerUL {
    _markerUL = markerUL;
}

+ (NSString *)markerOL {
    if (!_markerOL) {
        _markerOL = @"\\d+[.]";
    }

    return _markerOL;
}

+ (void)setMarkerOL:(NSString *)markerOL {
    _markerOL = markerOL;
}

+ (NSString *)listMarker {
    if (!_listMarker) {
        _listMarker = [NSString stringWithFormat:@"(?:%@|%@)", Marklight.markerUL, Marklight.markerOL];
    }

    return _listMarker;
}

+ (void)setListMarker:(NSString *)listMarker {
    _listMarker = listMarker;
}

+ (NSString *)wholeList {
    if (!_wholeList) {
        _wholeList = [@[
                        @"(                               # $1 = whole list",
                        @"  (                             # $2",
                        [NSString stringWithFormat:@"    \\p{Z}{0,%ld}", Marklight.tabWidth - 1],
                        [NSString stringWithFormat:@"    (%@)            # $3 = first list item marker", Marklight.listMarker],
                        @"    \\p{Z}+",
                        @"  )",
                        @"  (?s:.+?)",
                        @"  (                             # $4",
                        @"      \\z",
                        @"    |",
                        @"      \\n{2,}",
                        @"      (?=\\S)",
                        @"      (?!                       # Negative lookahead for another list item marker",
                        @"        \\p{Z}*",
                        [NSString stringWithFormat:@"        %@\\p{Z}+", Marklight.listMarker],
                        @"      )",
                        @"  )",
                        @")"
                        ] componentsJoinedByString:@"\n"];
    }

    return _wholeList;
}

+ (void)setWholeList:(NSString *)wholeList {
    _wholeList = wholeList;
}

+ (NSString *)listPattern {
    if (!_listPattern) {
        _listPattern = [@"(?:(?<=\\n\\n)|\\A\\n?)" stringByAppendingString:Marklight.wholeList];
    }

    return _listPattern;
}

+ (void)setListPattern:(NSString *)listPattern {
    _listPattern = listPattern;
}

+ (MarklightRegex *)listRegex {
    if (!_listRegex) {
        _listRegex = [[MarklightRegex alloc] initWithPattern:Marklight.listPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _listRegex;
}

+ (void)setListRegex:(MarklightRegex *)listRegex {
    _listRegex = listRegex;
}

+ (MarklightRegex *)listOpeningRegex {
    if (!_listOpeningRegex) {
        _listOpeningRegex = [[MarklightRegex alloc] initWithPattern:Marklight.listMarker options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _listOpeningRegex;
}

+ (void)setListOpeningRegex:(MarklightRegex *)listOpeningRegex {
    _listOpeningRegex = listOpeningRegex;
}

+ (NSString *)anchorPattern {
    if (!_anchorPattern) {
        _anchorPattern = [@[
                            @"(                                  # wrap whole match in $1",
                            @"    \\[",
                            [NSString stringWithFormat:@"        (%@)  # link text = $2", Marklight.nestedBracketsPattern],
                            @"    \\]",
                            @"",
                            @"    \\p{Z}?                        # one optional space",
                            @"    (?:\\n\\p{Z}*)?                # one optional newline followed by spaces",
                            @"",
                            @"    \\[",
                            @"        (.*?)                      # id = $3",
                            @"    \\]",
                            @")"
                            ] componentsJoinedByString:@"\n"];
    }

    return _anchorPattern;
}

+ (void)setAnchorPattern:(NSString *)anchorPattern {
    _anchorPattern = anchorPattern;
}

+ (MarklightRegex *)anchorRegex {
    if (!_anchorRegex) {
        _anchorRegex = [[MarklightRegex alloc] initWithPattern:Marklight.anchorPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _anchorRegex;
}

+ (void)setAnchorRegex:(MarklightRegex *)anchorRegex {
    _anchorRegex = anchorRegex;
}

+ (NSString *)opneningSquarePattern {
    if (!_opneningSquarePattern) {
        _opneningSquarePattern = [@[
                            @"(\\[)"
                            ] componentsJoinedByString:@"\n"];
    }

    return _opneningSquarePattern;
}

+ (void)setOpneningSquarePattern:(NSString *)opneningSquarePattern {
    _opneningSquarePattern = opneningSquarePattern;
}

+ (MarklightRegex *)openingSquareRegex {
    if (!_openingSquareRegex) {
        _openingSquareRegex = [[MarklightRegex alloc] initWithPattern:Marklight.opneningSquarePattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _openingSquareRegex;
}

+ (void)setOpeningSquareRegex:(MarklightRegex *)openingSquareRegex {
    _openingSquareRegex = openingSquareRegex;
}

+ (NSString *)closingSquarePattern {
    if (!_closingSquarePattern) {
        _closingSquarePattern = [@[
                                    @"\\]"
                                    ] componentsJoinedByString:@"\n"];
    }

    return _closingSquarePattern;
}

+ (void)setClosingSquarePattern:(NSString *)closingSquarePattern {
    _closingSquarePattern = closingSquarePattern;
}

+ (MarklightRegex *)closingSquareRegex {
    if (!_closingSquareRegex) {
        _closingSquareRegex = [[MarklightRegex alloc] initWithPattern:Marklight.closingSquarePattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _openingSquareRegex;
}

+ (void)setClosingSquareRegex:(MarklightRegex *)closingSquareRegex {
    _closingSquareRegex = closingSquareRegex;
}

+ (NSString *)coupleSquarePattern {
    if (!_coupleSquarePattern) {
        _coupleSquarePattern = [@[
                                   @"\\[(.*?)\\]"
                                   ] componentsJoinedByString:@"\n"];
    }

    return _coupleSquarePattern;
}

+ (void)setCoupleSquarePattern:(NSString *)coupleSquarePattern {
    _coupleSquarePattern = coupleSquarePattern;
}

+ (MarklightRegex *)coupleSquareRegex {
    if (!_coupleSquareRegex) {
        _coupleSquareRegex = [[MarklightRegex alloc] initWithPattern:Marklight.coupleSquarePattern options:0];
    }

    return _coupleSquareRegex;
}

+ (void)setCoupleSquareRegex:(MarklightRegex *)coupleSquareRegex {
    _coupleSquareRegex = coupleSquareRegex;
}

+ (NSString *)coupleRoundPattern {
    if (!_coupleRoundPattern) {
        _coupleRoundPattern = [@[
                                  @"\\((.*?)\\)"
                                  ] componentsJoinedByString:@"\n"];
    }

    return _coupleRoundPattern;
}

+ (void)setCoupleRoundPattern:(NSString *)coupleRoundPattern {
    _coupleRoundPattern = coupleRoundPattern;
}

+ (MarklightRegex *)coupleRoundRegex {
    if (!_coupleRoundRegex) {
        _coupleRoundRegex = [[MarklightRegex alloc] initWithPattern:Marklight.coupleRoundPattern options:0];
    }

    return _coupleRoundRegex;
}

+ (void)setCoupleRoundRegex:(MarklightRegex *)coupleRoundRegex {
    _coupleRoundRegex = coupleRoundRegex;
}

+ (NSString *)parenPattern {
    if (!_parenPattern) {
        _parenPattern = [@[
                           @"(",
                           @"\\(                 # literal paren",
                           @"      \\p{Z}*",
                           [NSString stringWithFormat:@"      (%@)    # href = $3", Marklight.nestedParensPattern],
                           @"      \\p{Z}*",
                           @"      (               # $4",
                           @"      (['\"])         # quote char = $5",
                           @"      (.*?)           # title = $6",
                           @"      \\5             # matching quote",
                           @"      \\p{Z}*",
                           @"      )?              # title is optional",
                           @"  \\)",
                           @")"
                            ] componentsJoinedByString:@"\n"];
    }

    return _parenPattern;
}

+ (void)setParenPattern:(NSString *)parenPattern {
    _parenPattern = parenPattern;
}

+ (MarklightRegex *)parenRegex {
    if (!_parenRegex) {
        _parenRegex = [[MarklightRegex alloc] initWithPattern:Marklight.coupleRoundPattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _parenRegex;
}

+ (void)setParenRegex:(MarklightRegex *)parenRegex {
    _parenRegex = parenRegex;
}

+ (NSString *)anchorInlinePattern {
    if (!_anchorInlinePattern) {
        _anchorInlinePattern = [@[
                                  @"(                           # wrap whole match in $1",
                                  @"    \\[",
                                  [NSString stringWithFormat:@"        (%@)   # link text = $2", Marklight.nestedBracketsPattern],
                                  @"    \\]",
                                  @"    \\(                     # literal paren",
                                  @"        \\p{Z}*",
                                  [NSString stringWithFormat:@"        (%@)   # href = $3", Marklight.nestedParensPattern],
                                  @"        \\p{Z}*",
                                  @"        (                   # $4",
                                  @"        (['\"])           # quote char = $5",
                                  @"        (.*?)               # title = $6",
                                  @"        \\5                 # matching quote",
                                  @"        \\p{Z}*                # ignore any spaces between closing quote and )",
                                  @"        )?                  # title is optional",
                                  @"    \\)",
                                  @")"
                           ] componentsJoinedByString:@"\n"];
    }

    return _anchorInlinePattern;
}

+ (void)setAnchorInlinePattern:(NSString *)anchorInlinePattern {
    _anchorInlinePattern = anchorInlinePattern;
}

+ (MarklightRegex *)anchorInlineRegex {
    if (!_anchorInlineRegex) {
        _anchorInlineRegex = [[MarklightRegex alloc] initWithPattern:Marklight.anchorInlinePattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _anchorInlineRegex;
}

+ (void)setAnchorInlineRegex:(MarklightRegex *)anchorInlineRegex {
    _anchorInlineRegex = anchorInlineRegex;
}

+ (NSString *)imagePattern {
    if (!_imagePattern) {
        _imagePattern = [@[
                           @"(               # wrap whole match in $1",
                           @"!\\[",
                           @"    (.*?)       # alt text = $2",
                           @"\\]",
                           @"",
                           @"\\p{Z}?            # one optional space",
                           @"(?:\\n\\p{Z}*)?    # one optional newline followed by spaces",
                           @"",
                           @"\\[",
                           @"    (.*?)       # id = $3",
                           @"\\]",
                           @"",
                           @")"
                            ] componentsJoinedByString:@"\n"];
    }

    return _imagePattern;
}

+ (void)setImagePattern:(NSString *)imagePattern {
    _imagePattern = imagePattern;
}

+ (MarklightRegex *)imageRegex {
    if (!_imageRegex) {
        _imageRegex = [[MarklightRegex alloc] initWithPattern:Marklight.imagePattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _imageRegex;
}

+ (void)setImageRegex:(MarklightRegex *)imageRegex {
    _imageRegex = imageRegex;
}

+ (NSString *)imageOpeningSquarePattern {
    if (!_imageOpeningSquarePattern) {
        _imageOpeningSquarePattern = [@[
                           @"(!\\[)"
                           ] componentsJoinedByString:@"\n"];
    }

    return _imageOpeningSquarePattern;
}

+ (void)setImageOpeningSquarePattern:(NSString *)imageOpeningSquarePattern {
    _imageOpeningSquarePattern = imageOpeningSquarePattern;
}

+ (MarklightRegex *)imageOpeningSquareRegex {
    if (!_imageOpeningSquareRegex) {
        _imageOpeningSquareRegex = [[MarklightRegex alloc] initWithPattern:Marklight.imageOpeningSquarePattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _imageOpeningSquareRegex;
}

+ (void)setImageOpeningSquareRegex:(MarklightRegex *)imageOpeningSquareRegex {
    _imageOpeningSquareRegex = imageOpeningSquareRegex;
}

+ (NSString *)imageClosingSquarePattern {
    if (!_imageClosingSquarePattern) {
        _imageClosingSquarePattern = [@[
                                        @"(\\])"
                                        ] componentsJoinedByString:@"\n"];
    }

    return _imageClosingSquarePattern;
}

+ (void)setImageClosingSquarePattern:(NSString *)imageClosingSquarePattern {
    _imageClosingSquarePattern = imageClosingSquarePattern;
}

+ (MarklightRegex *)imageClosingSquareRegex {
    if (!_imageClosingSquareRegex) {
        _imageClosingSquareRegex = [[MarklightRegex alloc] initWithPattern:Marklight.imageClosingSquarePattern options:NSRegularExpressionAllowCommentsAndWhitespace];
    }

    return _imageClosingSquareRegex;
}

+ (void)setImageClosingSquareRegex:(MarklightRegex *)imageClosingSquareRegex {
    _imageClosingSquareRegex = imageClosingSquareRegex;
}

+ (NSString *)imageInlinePattern {
    if (!_imageInlinePattern) {
        _imageInlinePattern = [@[
                                 @"(                     # wrap whole match in $1",
                                 @"  !\\[",
                                 @"      (.*?)           # alt text = $2",
                                 @"  \\]",
                                 @"  \\s?                # one optional whitespace character",
                                 @"  \\(                 # literal paren",
                                 @"      \\p{Z}*",
                                 [NSString stringWithFormat:@"      (%@)    # href = $3", Marklight.nestedParensPattern],
                                 @"      \\p{Z}*",
                                 @"      (               # $4",
                                 @"      (['\"])       # quote char = $5",
                                 @"      (.*?)           # title = $6",
                                 @"      \\5             # matching quote",
                                 @"      \\p{Z}*",
                                 @"      )?              # title is optional",
                                 @"  \\)",
                                 @")"
                                ] componentsJoinedByString:@"\n"];
    }

    return _imageInlinePattern;
}

+ (void)setImageInlinePattern:(NSString *)imageInlinePattern {
    _imageInlinePattern = imageInlinePattern;
}

+ (MarklightRegex *)imageInlineRegex {
    if (!_imageInlineRegex) {
        _imageInlineRegex = [[MarklightRegex alloc] initWithPattern:Marklight.imageInlinePattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _imageInlineRegex;
}

+ (void)setImageInlineRegex:(MarklightRegex *)imageInlineRegex {
    _imageInlineRegex = imageInlineRegex;
}

+ (NSString *)codeBlockPattern {
    if (!_codeBlockPattern) {
        _codeBlockPattern = [@[
                               @"(?:\\n\\n|\\A\\n?)",
                               @"(                        # $1 = the code block -- one or more lines, starting with a space",
                               @"(?:",
                               [NSString stringWithFormat:@"    (?:\\p{Z}{%ld})       # Lines must start with a tab-width of spaces", Marklight.tabWidth],
                               @"    .*\\n+",
                               @")+",
                               @")",
                               [NSString stringWithFormat:@"((?=^\\p{Z}{0,%ld}[^ \\t\\n])|\\Z) # Lookahead for non-space at line-start, or end of doc", Marklight.tabWidth]
                                 ] componentsJoinedByString:@"\n"];
    }

    return _codeBlockPattern;
}

+ (void)setCodeBlockPattern:(NSString *)codeBlockPattern {
    _codeBlockPattern = codeBlockPattern;
}

+ (MarklightRegex *)codeBlockRegex {
    if (!_codeBlockRegex) {
        _codeBlockRegex = [[MarklightRegex alloc] initWithPattern:Marklight.codeBlockPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _codeBlockRegex;
}

+ (void)setCodeBlockRegex:(MarklightRegex *)codeBlockRegex {
    _codeBlockRegex = codeBlockRegex;
}

+ (NSString *)codeSpanPattern {
    if (!_codeSpanPattern) {
        _codeSpanPattern = [@[
                              @"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
                              @"(`+)           # $1 = Opening run of `",
                              @"(?!`)          # and no more backticks -- match the full run",
                              @"(.+?)          # $2 = The code block",
                              @"(?<!`)",
                              @"\\1",
                              @"(?!`)"
                               ] componentsJoinedByString:@"\n"];
    }

    return _codeSpanPattern;
}

+ (void)setCodeSpanPattern:(NSString *)codeSpanPattern {
    _codeSpanPattern = codeSpanPattern;
}

+ (MarklightRegex *)codeSpanRegex {
    if (!_codeSpanRegex) {
        _codeSpanRegex = [[MarklightRegex alloc] initWithPattern:Marklight.codeSpanPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _codeSpanRegex;
}

+ (void)setCodeSpanRegex:(MarklightRegex *)codeSpanRegex {
    _codeSpanRegex = codeSpanRegex;
}

+ (NSString *)codeSpanOpeningPattern {
    if (!_codeSpanOpeningPattern) {
        _codeSpanOpeningPattern = [@[
                                     @"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
                                     @"(`+)           # $1 = Opening run of `"
                                     ] componentsJoinedByString:@"\n"];
    }

    return _codeSpanOpeningPattern;
}

+ (void)setCodeSpanOpeningPattern:(NSString *)codeSpanOpeningPattern {
    _codeSpanOpeningPattern = codeSpanOpeningPattern;
}

+ (MarklightRegex *)codeSpanOpeningRegex {
    if (!_codeSpanOpeningRegex) {
        _codeSpanOpeningRegex = [[MarklightRegex alloc] initWithPattern:Marklight.codeSpanOpeningPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _codeSpanOpeningRegex;
}

+ (void)setCodeSpanOpeningRegex:(MarklightRegex *)codeSpanOpeningRegex {
    _codeSpanOpeningRegex = codeSpanOpeningRegex;
}

+ (NSString *)codeSpanClosingPattern {
    if (!_codeSpanClosingPattern) {
        _codeSpanClosingPattern = [@[
                                     @"(?<![\\\\`])   # Character before opening ` can't be a backslash or backtick",
                                     @"(`+)           # $1 = Opening run of `"
                                     ] componentsJoinedByString:@"\n"];
    }

    return _codeSpanClosingPattern;
}

+ (void)setCodeSpanClosingPattern:(NSString *)codeSpanClosingPattern {
    _codeSpanClosingPattern = codeSpanClosingPattern;
}

+ (MarklightRegex *)codeSpanClosingRegex {
    if (!_codeSpanClosingRegex) {
        _codeSpanClosingRegex = [[MarklightRegex alloc] initWithPattern:Marklight.codeSpanClosingPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _codeSpanClosingRegex;
}

+ (void)setCodeSpanClosingRegex:(MarklightRegex *)codeSpanClosingRegex {
    _codeSpanClosingRegex = codeSpanClosingRegex;
}

+ (NSString *)blockQuotePattern {
    if (!_blockQuotePattern) {
        _blockQuotePattern = [@[
                                @"(                           # Wrap whole match in $1",
                                @"    (",
                                @"    ^\\p{Z}*>\\p{Z}?              # '>' at the start of a line",
                                @"        .+\\n               # rest of the first line",
                                @"    (.+\\n)*                # subsequent consecutive lines",
                                @"    \\n*                    # blanks",
                                @"    )+",
                                @")"
                                ] componentsJoinedByString:@"\n"];
    }

    return _blockQuotePattern;
}

+ (void)setBlockQuotePattern:(NSString *)blockQuotePattern {
    _blockQuotePattern = blockQuotePattern;
}

+ (MarklightRegex *)blockQuoteRegex {
    if (!_blockQuoteRegex) {
        _blockQuoteRegex = [[MarklightRegex alloc] initWithPattern:Marklight.blockQuotePattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _blockQuoteRegex;
}

+ (void)setBlockQuoteRegex:(MarklightRegex *)blockQuoteRegex {
    _blockQuoteRegex = blockQuoteRegex;
}

+ (NSString *)blockQuoteOpeningPattern {
    if (!_blockQuoteOpeningPattern) {
        _blockQuoteOpeningPattern = [@[
                                @"(^\\p{Z}*>\\p{Z})"
                                ] componentsJoinedByString:@"\n"];
    }

    return _blockQuoteOpeningPattern;
}

+ (void)setBlockQuoteOpeningPattern:(NSString *)blockQuoteOpeningPattern {
    _blockQuoteOpeningPattern = blockQuoteOpeningPattern;
}

+ (MarklightRegex *)blockQuoteOpeningRegex {
    if (!_blockQuoteOpeningRegex) {
        _blockQuoteOpeningRegex = [[MarklightRegex alloc] initWithPattern:Marklight.blockQuoteOpeningPattern options:NSRegularExpressionAnchorsMatchLines];
    }

    return _blockQuoteOpeningRegex;
}

+ (void)setBlockQuoteOpeningRegex:(MarklightRegex *)blockQuoteOpeningRegex {
    _blockQuoteOpeningRegex = blockQuoteOpeningRegex;
}

+ (NSString *)strictBoldPattern {
    if (!_strictBoldPattern) {
        _strictBoldPattern = @"(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)\\2(?=\\S)(.*?\\S)\\2\\2(?!\\2)(?=[\\W_]|$)";
    }

    return _strictBoldPattern;
}

+ (void)setStrictBoldPattern:(NSString *)strictBoldPattern {
    _strictBoldPattern = strictBoldPattern;
}

+ (MarklightRegex *)strictBoldRegex {
    if (!_strictBoldRegex) {
        _strictBoldRegex = [[MarklightRegex alloc] initWithPattern:Marklight.strictBoldPattern options:NSRegularExpressionAnchorsMatchLines];
    }

    return _strictBoldRegex;
}

+ (void)setStrictBoldRegex:(MarklightRegex *)strictBoldRegex {
    _strictBoldRegex = strictBoldRegex;
}

+ (NSString *)boldPattern {
    if (!_boldPattern) {
        _boldPattern = @"(\\*\\*|__) (?=\\S) (.+?[*_]*) (?<=\\S) \\1";
    }

    return _boldPattern;
}

+ (void)setBoldPattern:(NSString *)boldPattern {
    _boldPattern = boldPattern;
}

+ (MarklightRegex *)boldRegex {
    if (!_boldRegex) {
        _boldRegex = [[MarklightRegex alloc] initWithPattern:Marklight.boldPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _boldRegex;
}

+ (void)setBoldRegex:(MarklightRegex *)boldRegex {
    _boldRegex = boldRegex;
}

+ (NSString *)strictItalicPattern {
    if (!_strictItalicPattern) {
        _strictItalicPattern = @"(^|[\\W_])(?:(?!\\1)|(?=^))(\\*|_)(?=\\S)((?:(?!\\2).)*?\\S)\\2(?!\\2)(?=[\\W_]|$)";
    }

    return _strictItalicPattern;
}

+ (void)setStrictItalicPattern:(NSString *)strictItalicPattern {
    _strictItalicPattern = strictItalicPattern;
}

+ (MarklightRegex *)strictItalicRegex {
    if (!_strictItalicRegex) {
        _strictItalicRegex = [[MarklightRegex alloc] initWithPattern:Marklight.strictItalicPattern options:NSRegularExpressionAnchorsMatchLines];
    }

    return _strictItalicRegex;
}

+ (void)setStrictItalicRegex:(MarklightRegex *)strictItalicRegex {
    _strictItalicRegex = strictItalicRegex;
}

+ (NSString *)italicPattern {
    if (!_italicPattern) {
        _italicPattern = @"(\\*|_) (?=\\S) (.+?) (?<=\\S) \\1";
    }

    return _italicPattern;
}

+ (void)setItalicPattern:(NSString *)italicPattern {
    _italicPattern = italicPattern;
}

+ (MarklightRegex *)italicRegex {
    if (!_italicRegex) {
        _italicRegex = [[MarklightRegex alloc] initWithPattern:Marklight.italicPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionAnchorsMatchLines];
    }

    return _italicRegex;
}

+ (void)setItalicRegex:(MarklightRegex *)italicRegex {
    _italicRegex = italicRegex;
}

+ (NSString *)autolinkPattern {
    if (!_autolinkPattern) {
        _autolinkPattern = @"((https?|ftp):[^'\">\\s]+)";
    }

    return _autolinkPattern;
}

+ (void)setAutolinkPattern:(NSString *)autolinkPattern {
    _autolinkPattern = autolinkPattern;
}

+ (MarklightRegex *)autolinkRegex {
    if (!_autolinkRegex) {
        _autolinkRegex = [[MarklightRegex alloc] initWithPattern:Marklight.autolinkPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _autolinkRegex;
}

+ (void)setAutolinkRegex:(MarklightRegex *)autolinkRegex {
    _autolinkRegex = autolinkRegex;
}

+ (NSString *)autolinkPrefixPattern {
    if (!_autolinkPrefixPattern) {
        _autolinkPrefixPattern = @"((https?|ftp)://)";
    }

    return _autolinkPrefixPattern;
}

+ (void)setAutolinkPrefixPattern:(NSString *)autolinkPrefixPattern {
    _autolinkPrefixPattern = autolinkPrefixPattern;
}

+ (MarklightRegex *)autolinkPrefixRegex {
    if (!_autolinkPrefixRegex) {
        _autolinkPrefixRegex = [[MarklightRegex alloc] initWithPattern:Marklight.autolinkPrefixPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _autolinkPrefixRegex;
}

+ (void)setAutolinkPrefixRegex:(MarklightRegex *)autolinkPrefixRegex {
    _autolinkPrefixRegex = autolinkPrefixRegex;
}

+ (NSString *)autolinkEmailPattern {
    if (!_autolinkEmailPattern) {
        _autolinkEmailPattern = [@[
                                   @"(?:mailto:)?",
                                   @"(",
                                   @"  [-.\\w]+",
                                   @"  \\@",
                                   @"  [-a-z0-9]+(\\.[-a-z0-9]+)*\\.[a-z]+",
                                   @")"
                                   ] componentsJoinedByString:@"\n"];
    }

    return _autolinkEmailPattern;
}

+ (void)setAutolinkEmailPattern:(NSString *)autolinkEmailPattern {
    _autolinkEmailPattern = autolinkEmailPattern;
}

+ (MarklightRegex *)autolinkEmailRegex {
    if (!_autolinkEmailRegex) {
        _autolinkEmailRegex = [[MarklightRegex alloc] initWithPattern:Marklight.autolinkEmailPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _autolinkEmailRegex;
}

+ (void)setAutolinkEmailRegex:(MarklightRegex *)autolinkEmailRegex {
    _autolinkEmailRegex = autolinkEmailRegex;
}

+ (NSString *)mailtoPattern {
    if (!_mailtoPattern) {
        _mailtoPattern = @"mailto:";
    }

    return _mailtoPattern;
}

+ (void)setMailtoPattern:(NSString *)mailtoPattern {
    _mailtoPattern = mailtoPattern;
}

+ (MarklightRegex *)mailtoRegex {
    if (!_mailtoRegex) {
        _mailtoRegex = [[MarklightRegex alloc] initWithPattern:Marklight.mailtoPattern options:NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators];
    }

    return _mailtoRegex;
}

+ (void)setMailtoRegex:(MarklightRegex *)mailtoRegex {
    _mailtoRegex = mailtoRegex;
}

+ (void)setNestDepth:(NSInteger)nestDepth {
    _nestDepth = nestDepth;
}

+ (NSInteger)nestDepth {
    return _nestDepth;
}

+ (NSString *)nestedBracketsPattern {
    if (!_nestedBracketsPattern) {
        _nestedBracketsPattern = [repeatString([@[
                                    @"(?>             # Atomic matching",
                                    @"[^\\[\\]]+      # Anything other than brackets",
                                    @"|",
                                    @"\\["
                                    ] componentsJoinedByString:@"\n"], Marklight.nestDepth) stringByAppendingString:repeatString(@" \\])*", Marklight.nestDepth)];
    }

    return _nestedBracketsPattern;
}

+ (void)setNestedBracketsPattern:(NSString *)nestedBracketsPattern {
    _nestedBracketsPattern = nestedBracketsPattern;
}

+ (NSString *)nestedParensPattern {
    if (!_nestedParensPattern) {
        _nestedParensPattern = [repeatString([@[
                                                @"(?>            # Atomic matching",
                                                @"[^()\\s]+      # Anything other than parens or whitespace",
                                                @"|",
                                                @"\\("
                                                  ] componentsJoinedByString:@"\n"], Marklight.nestDepth) stringByAppendingString:repeatString(@" \\))*", Marklight.nestDepth)];
    }

    return _nestedParensPattern;
}

+ (void)setNestedParensPattern:(NSString *)nestedParensPattern {
    _nestedParensPattern = nestedParensPattern;
}

@end
