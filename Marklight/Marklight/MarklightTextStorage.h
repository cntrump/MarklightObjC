//
//  MarklightTextStorage.h
//  MarklightObjC
//
//  Created by vvveiii on 2018/6/26.
//  Copyright © 2018年 vvveiii. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "MarklightStyleApplier.h"
#import "MarklightTextProcessor.h"

@interface MarklightTextStorage : NSTextStorage <MarklightStyleApplier>

@property(nonatomic,strong) MarklightTextProcessor *marklightTextProcessor;

@end
