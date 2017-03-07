//
//  UIView+YMViewGap.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2016/12/1.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "UIView+YMViewGap.h"

@implementation UIView (YMViewGap)
+ (CGFloat)yinmanLeftRowGap {
    return 18;
}

+ (CGFloat)yinmanRightRowGap {
    return 18;
}

+ (CGFloat)yinmanFolderButtonRightGap {
    return [UIScreen mainScreen].bounds.size.width/6;
}

+ (CGFloat)yinmanFolderButtonWidth {
    return 40;
}

+ (CGFloat)yinmanStartButtonWidth {
    return 45;
}

+ (CGFloat)yinmanFolderTableViewTopOffset {
    return 18;
}


@end


