//
//  SoundFieldMicGraphView.m
//  SoundFieldMic
//
//  Created by zhicheng ren on 2016/11/28.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "SoundFieldMicGraphView.h"
#import "View+MASAdditions.h"


@implementation SoundFieldMicGraphView{
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
  
    [super updateConstraints];
}

@end
