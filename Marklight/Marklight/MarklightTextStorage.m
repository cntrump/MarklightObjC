//
//  MarklightTextStorage.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "MarklightTextStorage.h"
#import "UniversalTypes.h"

@interface MarklightTextStorage ()

/// Delegate from this class cluster to a regular `NSTextStorage` instance
/// because it does some additional performance optimizations
/// over `NSMutableAttributedString`.
@property(nonatomic,strong) NSTextStorage *imp;

// MARK: Syntax highlighting

/// Switch used to prevent `processEditing` callbacks from
/// within `processEditing`.
@property(nonatomic,assign) BOOL isBusyProcessing;

@end

@implementation MarklightTextStorage

- (instancetype)init {
    self = [super init];
    if (self) {
        _marklightTextProcessor = [[MarklightTextProcessor alloc] init];
        _imp = [[NSTextStorage alloc] init];
        _isBusyProcessing = NO;
    }

    return self;
}

/**
 To customise the appearance of the markdown syntax highlights you should
 subclass `MarklightTextProcessor`. Sends out
 `-textStorage:willProcessEditing`, fixes the attributes, sends out
 `-textStorage:didProcessEditing`, and notifies the layout managers of
 change with the
 `-processEditingForTextStorage:edited:range:changeInLength:invalidatedRange:`
 method.  Invoked from `-edited:range:changeInLength:` or `-endEditing`.

 - see:
 [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
 */
- (void)processEditing {
    self.isBusyProcessing = YES;
    MarklightProcessingResult *processingResult = [self.marklightTextProcessor processEditing:self
                                                                                  string:self.string
                                                                             editedRange:self.editedRange];
    [super processEditing];
    [processingResult updateLayoutManagersForTextStorage:self];
    self.isBusyProcessing = NO;
}

- (void)resetMarklightTextAttributesTextSize:(CGFloat)textSize range:(NSRange)range {
    // Use `imp` directly instead of `self` to avoid changing the edited range
    // after attribute fixing, affecting the insertion point on macOS.
    [_imp removeAttribute:NSForegroundColorAttributeName range:range];
    [_imp addAttribute:NSFontAttributeName value:[MarklightFont systemFontOfSize:textSize] range:range];
    [_imp addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle defaultParagraphStyle] range:range];
}

// MARK: Reading Text

/**
 Use this method to extract the text from the `UITextView` as plain text.

 - returns: The `String` containing the text inside the `UITextView`.

 - see:
 [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
 */
- (NSString *)string {
    return _imp.string;
}

/**
 Returns the attributes for the character at a given index.
 The attributes for the character at index.

 - parameter index: The index for which to return attributes. This value must
 lie within the bounds of the receiver.
 - parameter aRange: Upon return, the range over which the attributes and
 values are the same as those at index. This range isn’t necessarily the
 maximum range covered, and its extent is implementation-dependent. If you
 need the maximum range, use
 attributesAtIndex:longestEffectiveRange:inRange:. If you don't need this
 value, pass NULL.
 - returns: The attributes for the character at index.     - see:
 [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
 */

- (NSDictionary<NSAttributedStringKey, id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range {
    return [_imp attributesAtIndex:location effectiveRange:range];
}

// MARK: Text Editing

/**
 Replaces the characters in the given range with the characters of the given
 string. The new characters inherit the attributes of the first replaced
 character from aRange. Where the length of aRange is 0, the new characters
 inherit the attributes of the character preceding aRange if it has any,
 otherwise of the character following aRange. Raises an NSRangeException if
 any part of aRange lies beyond the end of the receiver’s characters.
 - parameter aRange: A range specifying the characters to replace.
 - parameter aString: A string specifying the characters to replace those in
 aRange.
 - see:
 [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
 */
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
}

/**
 Sets the attributes for the characters in the specified range to the
 specified attributes. These new attributes replace any attributes previously
 associated with the characters in aRange. Raises an NSRangeException if any
 part of aRange lies beyond the end of the receiver’s characters. To set
 attributes for a zero-length NSMutableAttributedString displayed in a text
 view, use the NSTextView method setTypingAttributes:.
 - parameter attributes: A dictionary containing the attributes to set.
 Attribute keys can be supplied by another framework or can be custom ones
 you define. For information about where to find the system-supplied
 attribute keys, see the overview section in NSAttributedString Class
 Reference.
 - parameter aRange: The range of characters whose attributes are set.
 - see:
 [`NSMutableAttributedString`](xcdoc://?url=developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSMutableAttributedString_Class/index.html#//apple_ref/swift/cl/c:objc(cs)NSMutableAttributedString
 )
 - see:
 [`NSTextStorage`](xcdoc://?url=developer.apple.com/library/ios/documentation/UIKit/Reference/NSTextStorage_Class_TextKit/index.html#//apple_ref/doc/uid/TP40013282)
 */

- (void)setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    // When we are processing, using the regular callback triggers will
    // result in the caret jumping to the end of the document.
    if (self.isBusyProcessing) {
        [_imp setAttributes:attrs range:range];
        return;
    }

    [self beginEditing];
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)invalidateTextSizeForWholeRange {
    NSRange wholeRange = NSMakeRange(0, self.string.length);
    [self invalidateAttributesInRange:wholeRange];
    
    for (NSLayoutManager *layoutManager in self.layoutManagers) {
        [layoutManager invalidateDisplayForCharacterRange:wholeRange];
    }
}

@end
