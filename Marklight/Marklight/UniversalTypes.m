//
//  UniversalTypes.m
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#import "UniversalTypes.h"

#if TARGET_OS_IOS

#else
@implementation NSFont (italicSystemFont)

+ (NSFont *)italicSystemFontOfSize:(CGFloat)size {
    return [[[NSFontManager alloc] init] convertFont:[NSFont systemFontOfSize:size] toHaveTrait:NSItalicFontMask];
}

@end
#endif
