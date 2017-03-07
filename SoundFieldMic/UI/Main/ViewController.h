//
//  ViewController.h
//  SoundFieldMic
//
//  Created by ren zhicheng on 2017/2/4.
//  Copyright © 2017年 Yinkman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEAudioController;
@interface ViewController : UIViewController

- (id)initWithAudioController:(AEAudioController*)audioController;

@property (nonatomic, strong) AEAudioController *audioController;

@end
