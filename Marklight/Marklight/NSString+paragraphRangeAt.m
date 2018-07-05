//
//  NSString+paragraphRangeAt.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "NSString+paragraphRangeAt.h"

@implementation NSString (paragraphRangeAt)

- (NSRange)paragraphRangeAt:(NSInteger)location {
    return [self paragraphRangeForRange:NSMakeRange(location, 0)];
}

@end
