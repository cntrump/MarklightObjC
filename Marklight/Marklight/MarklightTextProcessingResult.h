//
//  MarklightTextProcessingResult.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <Foundation/Foundation.h>

@interface MarklightProcessingResult : NSObject

@property(nonatomic,readonly) NSRange editedRange;
@property(nonatomic,readonly) NSRange affectedRange;

- (instancetype)initWithEditedRange:(NSRange)editedRange affectedRange:(NSRange)affectedRange;
- (void)updateLayoutManagersForTextStorage:(NSTextStorage *)textStorage;

@end

@interface NSLayoutManager (processEditing)

- (void)processEditingForTextStorage:(NSTextStorage *)textStorage processingResult:(MarklightProcessingResult *)processingResult;

@end
