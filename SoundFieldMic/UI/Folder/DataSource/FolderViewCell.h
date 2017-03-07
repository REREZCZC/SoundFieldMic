//
//  FolderViewCell.h
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/30.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderViewCell : UITableViewCell
@property(nonatomic, strong, readonly)UIView *topSeparator;
@property(nonatomic, strong, readonly)UIView *bootomSeparator;
@property(nonatomic, strong, readonly)UILabel *nameLabel;
@end
