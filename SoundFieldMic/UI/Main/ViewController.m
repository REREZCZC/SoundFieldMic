//
//  ViewController.m
//  SoundFieldMic
//
//  Created by ren zhicheng on 2017/2/4.
//  Copyright © 2017年 Yinkman. All rights reserved.
//

#import "ViewController.h"
#import "SoundFieldMicView.h"
#import "View+MASAdditions.h"
#import "FolderViewController.h"
#import "TheAmazingAudioEngine.h"
#import "TPOscilloscopeLayer.h"
#import "AERecorder.h"
#import "HAMLogOutputWindow.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundFieldMicChannelSelectionView.h"
@interface ViewController (){
    AEChannelGroupRef _group;
}
@property (nonatomic, strong) AEAudioFilePlayer *loop1;
@property (nonatomic, strong) TPOscilloscopeLayer *outputOscilloscope;
@property (nonatomic, strong) TPOscilloscopeLayer *inputOscilloscope;
@property (nonatomic, strong) AERecorder *recorder;
@end



@implementation ViewController {
    SoundFieldMicView *_soundFieldMicView;
    UISwipeGestureRecognizer *_swipeUpRecognizer;
}
- (id)initWithAudioController:(AEAudioController *)audioController {
    self = [super init];
    if (self) {
        self.audioController = audioController;
    }
    return self;
}

- (void)setAudioController:(AEAudioController *)audioController {
    if (_audioController) {
        //remove
        NSMutableArray *channelsToRemove = [NSMutableArray arrayWithObjects:_loop1, nil];
        self.loop1 = nil;
        [_audioController removeChannels:channelsToRemove];
        
    }
    _audioController = audioController;
    
    if (_audioController) {
        self.loop1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Southern Rock Drums" withExtension:@"m4a"] error:NULL];
        _loop1.volume = 1.0;
        _loop1.channelIsMuted = YES;
        _loop1.loop = YES;
        
        [_audioController addChannels:@[_loop1]];
    }

}
-(void)dealloc {
    self.audioController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _soundFieldMicView = [SoundFieldMicView new];
    [self.view addSubview:_soundFieldMicView];
    
    [_soundFieldMicView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
    [_soundFieldMicView.controlView.startButton
     addTarget:self
     action:@selector(startRecord)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_soundFieldMicView.controlView.folderButton addTarget:self
                                                    action:@selector(modalToFolderViewController)
                                          forControlEvents:UIControlEventTouchUpInside];
    
    
    _swipeUpRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(modalToFolderViewController)];
    [_swipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_soundFieldMicView.controlView addGestureRecognizer:_swipeUpRecognizer];
    
    
    //采集到的声音波形
    self.outputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioDescription:_audioController.audioDescription];
    
    _outputOscilloscope.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [_soundFieldMicView.graphView.layer addSublayer:_outputOscilloscope];
    [_audioController addOutputReceiver:_outputOscilloscope];
    [_outputOscilloscope start];
    
    //播放的声音波形
    self.inputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioDescription:_audioController.audioDescription];
    _inputOscilloscope.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    _inputOscilloscope.lineColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [_soundFieldMicView.graphView.layer addSublayer:_inputOscilloscope];
    [_audioController addInputReceiver:_inputOscilloscope];
    [_inputOscilloscope start];
    
    //**************************************************
    int number = _audioController.numberOfInputChannels;
    NSString *channels = [NSString stringWithFormat:@"%d",number];
    NSString *string = @"NumberOfChannel";
    NSString *numberOfChannels = [NSString stringWithFormat:@"%@_ %@",string,channels];
    [HAMLogOutputWindow printLog:numberOfChannels];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = audioSession.currentRoute;
    NSString *currentRouteName = [NSString stringWithFormat:@"CurrentRoute_ %@",[self currentNameFromDescription:currentRoute]];
    [HAMLogOutputWindow printLog:currentRouteName];

    NSArray<AVAudioSessionPortDescription *> *avaliableInput = audioSession.availableInputs;
    for (AVAudioSessionPortDescription *abailableInputName in avaliableInput) {
        NSString *name = abailableInputName.portName;
        NSString *name1 = [NSString stringWithFormat:@"%@ }",name];
        [HAMLogOutputWindow printLog:name1];
        
        NSArray<AVAudioSessionChannelDescription *> *channelsDes = abailableInputName.channels;
        for (AVAudioSessionChannelDescription *channels in channelsDes) {
            NSString *channelName = channels.channelName;
            NSInteger channelNum = channels.channelNumber;
            
            NSString *ThisChannel = [NSString stringWithFormat:@"ThisChannel_%@ %ld }}",channelName, (long)channelNum];
            [HAMLogOutputWindow printLog:ThisChannel];
        }
    }
    //**************************************************
    int channelCount = _audioController.numberOfInputChannels;
    CGSize buttonSize = CGSizeMake(30, 30);
  
    for ( int i=0; i<channelCount; i++ ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i*(buttonSize.width+5), 8, buttonSize.width, buttonSize.height);
        [button setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        button.highlighted = [_audioController.inputChannelSelection containsObject:@(i)];
        button.tag = i;
        [button addTarget:self action:@selector(channelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_soundFieldMicView.channelSelectionView.channelSelector addSubview:button];
    }
    
    _soundFieldMicView.channelSelectionView.channelSelector.contentSize = CGSizeMake(channelCount * (buttonSize.width+5) + 5, _soundFieldMicView.channelSelectionView.channelSelector.bounds.size.height);

}

- (void)channelButtonPressed:(UIButton*)sender {
    BOOL selected = [_audioController.inputChannelSelection containsObject:@(sender.tag)];
    selected = !selected;
    if ( selected ) {
        _audioController.inputChannelSelection = [[_audioController.inputChannelSelection arrayByAddingObject:@(sender.tag)] sortedArrayUsingSelector:@selector(compare:)];
        [self performSelector:@selector(highlightButtonDelayed:) withObject:sender afterDelay:0.01];
    } else {
        NSMutableArray *channels = [_audioController.inputChannelSelection mutableCopy];
        [channels removeObject:@(sender.tag)];
        _audioController.inputChannelSelection = channels;
        sender.highlighted = NO;
    }
}
- (void)highlightButtonDelayed:(UIButton*)button {
    button.highlighted = YES;
}


-(void)viewDidLayoutSubviews {
    _outputOscilloscope.frame = CGRectMake(0, 100, self.view.frame.size.width, 80);
    _inputOscilloscope.frame = CGRectMake(0, 100, self.view.frame.size.width, 80);
}

- (void)startRecord {
    if (_recorder) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        _soundFieldMicView.controlView.startButton.selected = NO;
    }else {
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        //filepath
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"SoundFieldMic.m4a"];
        NSError *error = nil;
        
        if (![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error]) {
            NSLog(@"Couldn't start recording %@",[error localizedDescription]);
            self.recorder = nil;
            return;
        }
        
        _soundFieldMicView.controlView.startButton.selected = YES;
        [_audioController addOutputReceiver:_recorder];//Play
        [_audioController addInputReceiver:_recorder]; //Mic
    }
    
}

- (void)modalToFolderViewController {
    FolderViewController *folderViewController = [FolderViewController new];
    [self presentViewController:folderViewController animated:YES completion:nil];
}

//get current port name;
- (NSString*)currentNameFromDescription:(AVAudioSessionRouteDescription*)routeDescription {
    
    NSMutableString *inputsString = [NSMutableString string];
    for ( AVAudioSessionPortDescription *port in routeDescription.inputs ) {
        [inputsString appendFormat:@"%@%@", inputsString.length > 0 ? @", " : @"", port.portName];
    }
    NSMutableString *outputsString = [NSMutableString string];
    for ( AVAudioSessionPortDescription *port in routeDescription.outputs ) {
        [outputsString appendFormat:@"%@%@", outputsString.length > 0 ? @", " : @"", port.portName];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", inputsString, inputsString.length > 0 && outputsString.length > 0 ? @" and " : @"", outputsString];
}



@end
