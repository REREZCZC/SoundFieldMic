//
//  FolderViewDataSource.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/30.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "FolderViewDataSource.h"
#import "FolderViewCell.h"

NSString *const kFolderViewCellIdentifier = @"folderViewCell";

@implementation FolderViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getAudioFileList];
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [_tableView registerClass:[FolderViewCell class] forCellReuseIdentifier:kFolderViewCellIdentifier];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allAudio.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FolderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFolderViewCellIdentifier];
    cell.nameLabel.text = _allAudio[indexPath.row];
    [self setCellSeparators:cell withIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    return cell;
    
}

- (void)setCellSeparators:(FolderViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    cell.bootomSeparator.hidden = indexPath.row < _allAudio.count - 1;
//    cell.topSeparator.hidden = indexPath.row == 0;
    
}

- (void)getAudioFileList {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    _allAudio = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        [_allAudio addObject:file];
    }
}


@end
