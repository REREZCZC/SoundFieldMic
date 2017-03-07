//
//  SoundFieldMicControlView.m
//  SoundFieldMic
//
//  Created by zhicheng ren on 2016/11/28.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "SoundFieldMicControlView.h"
#import "View+MASAdditions.h"
#import "UIView+YMViewGap.h"
@implementation SoundFieldMicControlView{
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.translatesAutoresizingMaskIntoConstraints = NO;
        _startButton.tintColor = [UIColor clearColor];
        [_startButton setImage:[[UIImage imageNamed:@"startRecord"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_startButton setImage:[[UIImage imageNamed:@"recording"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self addSubview:_startButton];
        
        _folderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _folderButton.translatesAutoresizingMaskIntoConstraints = NO;
        _folderButton.tintColor = [UIColor clearColor];
        [_folderButton setImage:[[UIImage imageNamed:@"floder"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self addSubview:_folderButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints {
    [_startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@([UIView yinmanStartButtonWidth]));
        make.height.equalTo(_startButton.mas_width);
    }];
    
    [_folderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-[UIView yinmanFolderButtonRightGap]);
        make.width.equalTo(@([UIView yinmanFolderButtonWidth]));
        make.height.equalTo(_folderButton.mas_width);
    }];
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
