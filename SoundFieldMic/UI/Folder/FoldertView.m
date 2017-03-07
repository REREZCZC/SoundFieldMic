//
//  FoldertView.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/29.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "FoldertView.h"
#import "View+MASAdditions.h"
#import "UIView+YMViewGap.h"

@implementation FoldertView{
    UIImageView *_arrowView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake([UIView yinmanFolderTableViewTopOffset], 0, 0, 0);
        _tableView.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self addSubview:_tableView];
        
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}




- (void)updateConstraints {
    
    [_arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_arrowView.mas_height);
    }];
    
    
    [super updateConstraints];
}

@end

