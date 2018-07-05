//
//  NSArray+appending.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "NSArray+appending.h"

@implementation NSMutableArray (appending)

- (NSMutableArray *)appendingContentsOf:(NSArray *)other {
    NSMutableArray *result = self;
    [result addObjectsFromArray:other];

    return result;
}

@end
