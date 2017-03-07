//
//  FolderViewCell.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/30.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "FolderViewCell.h"
#import "View+MASAdditions.h"
#import "UIView+YMViewGap.h"
#import "UIColor+YMViewColor.h"
#import "UIFont+YMTextSize.h"
@implementation FolderViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        _topSeparator.backgroundColor = [UIColor yinmanLightGrayColor];
        _topSeparator.alpha = 0.5f;
        [self addSubview:_topSeparator];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont yinmanFolderListFont];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_nameLabel];
        
        _bootomSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        _bootomSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        _bootomSeparator.backgroundColor = [UIColor yinmanLightGrayColor];
        _bootomSeparator.alpha = 0.5f;
        [self addSubview:_bootomSeparator];
        
    }
    return self;
}


- (void)updateConstraints {
    
    [_topSeparator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([UIView yinmanLeftRowGap]);
        make.right.equalTo(self.mas_right).offset(-[UIView yinmanRightRowGap]);
        make.top.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([UIView yinmanLeftRowGap]);
        make.top.equalTo(_topSeparator.mas_bottom).offset(5);
        make.bottom.equalTo(_bootomSeparator.mas_top).offset(-5);
        make.right.equalTo(self.mas_right).offset(-[UIView yinmanRightRowGap]);
    }];
    
    [_bootomSeparator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset([UIView yinmanLeftRowGap]);
        make.right.equalTo(self.mas_right).offset(-[UIView yinmanRightRowGap]);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [super updateConstraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
