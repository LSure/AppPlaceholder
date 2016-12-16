//
//  UICollectionView+Sure_Placeholder.h
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/11/30.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Sure_Placeholder)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, copy) void(^reloadBlock)(void);

@end
