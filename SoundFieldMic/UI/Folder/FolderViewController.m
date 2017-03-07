//
//  FolderViewController.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/11/29.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "FolderViewController.h"
#import "View+MASAdditions.h"
#import "FoldertView.h"
#import "FolderViewDataSource.h"

static const CGFloat kTableViewSwipLimitation = -150;

@interface FolderViewController (){
    
}

@end

@implementation FolderViewController {
    FoldertView *_folderView;
    FolderViewDataSource *_dataSource;
}

- (FoldertView *)folderView{
    return (FoldertView *)self.view;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSource = [FolderViewDataSource new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _folderView = [[FoldertView alloc] initWithFrame:CGRectZero];
    self.view = _folderView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDismissGesture:)];
    
    _dataSource.tableView = _folderView.tableView;
    _folderView.tableView.dataSource = _dataSource;
    _folderView.tableView.delegate = self;
    
    
    _folderView.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _folderView.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down"]];
    [_folderView.tableView.tableHeaderView addSubview:arrow];
    [arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_folderView.tableView.tableHeaderView.mas_centerX);
        make.centerY.equalTo(_folderView.tableView.tableHeaderView.mas_centerY);
        make.height.equalTo(_folderView.tableView.tableHeaderView.mas_height);
    }];
    
    CGFloat footerVeiwHeight = ([UIScreen mainScreen].bounds.size.height)-_folderView.tableView.contentSize.height;
    if (footerVeiwHeight < 0) {
        footerVeiwHeight = 0;
    }
    _folderView.tableView.tableFooterView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,footerVeiwHeight)];
    _folderView.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    _folderView.tableView.showsVerticalScrollIndicator = NO;
    
    [_folderView.tableView.tableHeaderView addGestureRecognizer:tapGesture];
    
    [self setTableViewCorner];
    
    UISwipeGestureRecognizer *swipRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDismissGesture:)];
    [_folderView.tableView addGestureRecognizer:swipRecognizer];
    
    
    
}

- (void)setTableViewCorner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_folderView.tableView.tableHeaderView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(17, 17)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _folderView.tableView.tableHeaderView.bounds;
    maskLayer.path = maskPath.CGPath;
    _folderView.tableView.tableHeaderView.layer.mask = maskLayer;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_folderView.tableView.contentOffset.y < kTableViewSwipLimitation) {
        [self handleTapDismissGesture:nil];
    }

    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoOffset;
    
    
    if (distanceFromBottom < height) {
        _folderView.tableView.bounces = NO;
    }
    
    if (contentYoOffset < 40){
        _folderView.tableView.bounces = YES;
    }
    
    if (scrollView.contentSize.height == [UIScreen mainScreen].bounds.size.height && contentYoOffset >= 0) {
        _folderView.tableView.bounces = NO;
    }
    
}
- (void)handleTapDismissGesture:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

@end

