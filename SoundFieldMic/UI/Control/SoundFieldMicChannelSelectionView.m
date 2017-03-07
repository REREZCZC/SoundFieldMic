//
//  SoundFieldMicChannelSelectionView.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2017/2/4.
//  Copyright © 2017年 Yinkman. All rights reserved.
//

#import "SoundFieldMicChannelSelectionView.h"
#import "View+MASAdditions.h"

@implementation SoundFieldMicChannelSelectionView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        _cellTitle = [[UILabel alloc] init];
        _cellTitle.text = @"Channels";
        [self addSubview:_cellTitle];
        
        _channelSelector = [[UIScrollView alloc] init];
        _channelSelector.backgroundColor = [UIColor grayColor];
        [self addSubview:_channelSelector];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints {
    [_cellTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.width.equalTo(@80);
    }];
    
    [_channelSelector mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cellTitle.mas_right);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [super updateConstraints];
}

@end
