//
//  UniversalTypes.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>

typedef UIColor MarklightColor;
typedef UIFont MarklightFont;
typedef UIFontDescriptor MarklightFontDescriptor;

#else
#import <AppKit/AppKit.h>

typedef NSColor MarklightColor;
typedef NSFont MarklightFont;
typedef NSFontDescriptor MarklightFontDescriptor;

@interface NSFont (italicSystemFont)

+ (NSFont *)italicSystemFontOfSize:(CGFloat)size;

@end

#endif
