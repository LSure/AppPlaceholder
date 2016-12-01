//
//  CustomPlaceholderView.m
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/12/1.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "CustomPlaceholderView.h"

@interface CustomPlaceholderView ()
@property (nonatomic, strong) UIButton *reloadButton;
@end
@implementation CustomPlaceholderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self addSubview:self.reloadButton];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.center;
        _reloadButton.layer.cornerRadius = 75.0;
        _reloadButton.clipsToBounds = YES;
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"placehold"] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}

- (void)reloadClick:(UIButton*)button {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}

@end
