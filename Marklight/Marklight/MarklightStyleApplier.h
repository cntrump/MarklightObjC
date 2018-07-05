//
//  MarklightStyleApplier.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MarklightStyleApplier <NSObject>

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;
- (void)addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range;
- (void)removeAttribute:(NSAttributedStringKey)name range:(NSRange)range;
- (void)resetMarklightTextAttributesTextSize:(CGFloat)textSize range:(NSRange)range;

@end
