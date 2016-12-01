//
//  NSObject+Swizzling.h
//  ProjectRefactoring
//
//  Created by 刘硕 on 2016/11/10.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;

@end
