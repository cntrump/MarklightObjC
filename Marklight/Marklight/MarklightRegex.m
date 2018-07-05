//
//  MarklightRegex.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "MarklightRegex.h"

@implementation MarklightRegex

- (instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSRegularExpression *re = nil;

        @try {
        re = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:&error];
        } @catch (NSException *e) {
            re = nil;
        }

        if (!re) {
            if (error) {
                NSLog(@"Regular expression error: %@", error.userInfo);
            }

            assert(re != nil);
        }

        _regularExpression = re;
    }

    return self;
}

- (void)matches:(NSString *)input range:(NSRange)range completion:(void (^)(NSTextCheckingResult *result))completion {
    [_regularExpression enumerateMatchesInString:input options:0 range:range usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (completion) {
            completion(result);
        }
    }];
}

@end
