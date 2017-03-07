//
//  FolderViewDataSource.h
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/30.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FolderViewDataSource : NSObject<UITableViewDataSource>
@property(nonatomic, weak)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *allAudio;

@end
