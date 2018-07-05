//
//  MarklightRegex.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarklightRegex : NSObject

@property(nonatomic,readonly) NSRegularExpression *regularExpression;

- (instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options;
- (void)matches:(NSString *)input range:(NSRange)range completion:(void (^)(NSTextCheckingResult *result))completion;

@end
