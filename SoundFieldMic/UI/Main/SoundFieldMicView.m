//
//  SoundFieldMicView.m
//  SoundFieldMic
//
//  Created by zhicheng ren on 2016/11/28.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "SoundFieldMicView.h"
#import "SoundFieldMicGraphView.h"
#import "View+MASAdditions.h"
#import "SoundFieldMicControlView.h"
#import "SoundFieldMicChannelSelectionView.h"


@implementation SoundFieldMicView {

}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _graphView = [[SoundFieldMicGraphView alloc] init];
        [self addSubview:_graphView];
        
        _channelSelectionView = [[SoundFieldMicChannelSelectionView alloc] init];
        [self addSubview:_channelSelectionView];
        
        _controlView = [[SoundFieldMicControlView alloc] init];
        [self addSubview:_controlView];
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints {
    [_controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@200);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [_channelSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(_controlView.mas_top);
        make.height.equalTo(@50);
    }];
    
    [_graphView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(_channelSelectionView.mas_top);
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
