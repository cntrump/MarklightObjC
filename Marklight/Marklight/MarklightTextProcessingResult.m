//
//  MarklightTextProcessingResult.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "MarklightTextProcessingResult.h"

@implementation MarklightProcessingResult

- (instancetype)initWithEditedRange:(NSRange)editedRange affectedRange:(NSRange)affectedRange {
    self = [super init];
    if (self) {
        _editedRange = editedRange;
        _affectedRange = affectedRange;
    }

    return self;
}

- (void)updateLayoutManagersForTextStorage:(NSTextStorage *)textStorage {
    [textStorage.layoutManagers enumerateObjectsUsingBlock:^(NSLayoutManager * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj processEditingForTextStorage:textStorage processingResult:self];
    }];
}

@end


@implementation NSLayoutManager (processEditing)

- (void)processEditingForTextStorage:(NSTextStorage *)textStorage processingResult:(MarklightProcessingResult *)processingResult {
    [self processEditingForTextStorage:textStorage edited:NSTextStorageEditedAttributes range:processingResult.editedRange changeInLength:0 invalidatedRange:processingResult.affectedRange];
}

@end
