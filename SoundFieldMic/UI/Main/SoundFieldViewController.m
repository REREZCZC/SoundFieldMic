#import "View+MASAdditions.h"
#import "SoundFieldViewController.h"
#import "SoundFieldMicRecorder.h"
#import "SoundFieldMicView.h"
#import "SoundFieldMicControlView.h"
#import "SoundFieldMicGraphView.h"
#import "FolderViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#include <string.h>
#import <pthread.h>
#import "HAMLogOutputWindow.h"

#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"

@interface SoundFieldViewController ()<YMAudioRecorderDelegate>
@property(nonatomic, strong)NSString *nameLabel;
@property(nonatomic, strong)AERecorder *recorder;
@property(nonatomic, strong)AEAudioController *audioController;

@end

@implementation SoundFieldViewController{
    NSMutableData *_receiveData;
    SoundFieldMicRecorder *_audioRecorder;
    SoundFieldMicView *_soundFieldMicView;
    BOOL _recorderState;
    dispatch_queue_t _appendDataQueue;
    dispatch_queue_t _saveToFileQueue;
    UISwipeGestureRecognizer *swipeUpRecognizer;
    int i;
    NSURL *_audioFileURL;
    ExtAudioFileRef _outputFile;
    AudioStreamBasicDescription _outputFormat;
}
Float64 sampleRate;
ExtAudioFileRef _outputFile;



- (id)init {
    self = [super init];
    if (self) {
        
        //**************************************************
        _audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];
        
        _recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        _soundFieldMicView = [SoundFieldMicView new];
        [self.view addSubview:_soundFieldMicView];
        
        [_soundFieldMicView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.bottom.equalTo(self.view.mas_bottom);
        }];

        //**************************************************
        
        /*
        _appendDataQueue = dispatch_queue_create("append_data_queue", DISPATCH_QUEUE_SERIAL);
        _saveToFileQueue = dispatch_queue_create("save_to_file_queue", DISPATCH_QUEUE_SERIAL);
        
        _receiveData = nil;
        _receiveData = [NSMutableData dataWithCapacity:[self maxFrames] * [_audioRecorder framesSizeInBytes]];
        
        _audioRecorder = [[SoundFieldMicRecorder alloc] initWithDelegate:self];
        
        _soundFieldMicView = [SoundFieldMicView new];
        [self.view addSubview:_soundFieldMicView];
        
        [_soundFieldMicView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        i = 0;
         */
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_soundFieldMicView.controlView.startButton
     addTarget:self
     action:@selector(startRecord)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_soundFieldMicView.controlView.folderButton addTarget:self
                                                    action:@selector(modalToFolderViewController)
                                          forControlEvents:UIControlEventTouchUpInside];
    
    
    swipeUpRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(modalToFolderViewController)];
    [swipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_soundFieldMicView.controlView addGestureRecognizer:swipeUpRecognizer];
    
    int number = _audioController.numberOfInputChannels;
    NSString *channels = [NSString stringWithFormat:@"%d",number];
    NSString *string = @"NumberOfChannel";
    NSString *numberOfChannels = [NSString stringWithFormat:@"%@_ %@",string,channels];
    NSLog(@"SoundFieldMic_NumberOFChannel_ %@",numberOfChannels);
    [HAMLogOutputWindow printLog:numberOfChannels];
    
    //**************************************************
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = audioSession.currentRoute;
    NSArray<AVAudioSessionPortDescription *> *avaliableInput = audioSession.availableInputs;
    NSLog(@"SoundFieldMic_CurrentRoute_ %@", [self currentNameFromDescription:currentRoute]);
    NSLog(@"SoundFieldMic_AvailableInput_ %@", avaliableInput);
    //**************************************************
}


- (void)startRecord {
    
    if (_recorder) {//if recording, stop recording.
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        [_soundFieldMicView.controlView.startButton setImage:[[UIImage imageNamed:@"startRecord"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else {
        //recorder init
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        //file path
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"AmazingAudioRecording.m4a"];
        NSError *error = nil;
        if (![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error]) {
            NSLog(@"Couldn't start recording : %@",[error localizedDescription]);
            self.recorder = nil;
            return;
        }
        [_soundFieldMicView.controlView.startButton setImage:[[UIImage imageNamed:@"recording"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
        
    }
//    if (_recorderState) {
//        [_soundFieldMicView.controlView.startButton setImage:[[UIImage imageNamed:@"startRecord"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
////        [_audioRecorder stop];
//        _recorderState = NO;
//    }else {
//        [_soundFieldMicView.controlView.startButton setImage:[[UIImage imageNamed:@"recording"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
////        [_audioRecorder start];
//        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
//                                     objectAtIndex:0];
//        NSString *filePath = [documentsFolder stringByAppendingPathComponent:@"Recording.aiff"];
//        // Start the recording process
//        NSError *error = NULL;
//        if ( ![_recorder beginRecordingToFileAtPath:filePath
//                                           fileType:kAudioFileAIFFType
//                                              error:&error] ) {
//            // Report error
//            return;
//        }
//        _recorderState = YES;
//    }
    
}


- (void)modalToFolderViewController {
    FolderViewController *folderViewController = [FolderViewController new];
    [self presentViewController:folderViewController animated:YES completion:nil];
    
}

- (void)audioRecorderDidStart:(SoundFieldMicRecorder *)audioRecorder {
    NSLog(@"Start.");
}

- (void)audioRecorderDidStop:(SoundFieldMicRecorder *)audioRecorder {
    /*
    NSLog(@"Stop");
    
    __weak typeof(self) weakSelf = self;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"音频名称";
    }];
    //保存
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.nameLabel = alert.textFields.firstObject.text;
        
        dispatch_async(_saveToFileQueue, ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:[self receiveFilePath:weakSelf.nameLabel]
                                 contents:_receiveData
                               attributes:nil];
            _receiveData = nil;
        });
        
    }];
    //取消
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:defaultAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:nil];
     */
    
}

- (void)audioRecorder:(SoundFieldMicRecorder *)audioRecorder capturedFrames:(NSUInteger)frameCount data:(NSData *)framwData {
    dispatch_async(_appendDataQueue, ^{
        [_receiveData appendData:framwData];
    });
    
}


- (void)auidoRecorder:(SoundFieldMicRecorder *)audioRecorder didEncounterError:(NSError *)error {
    
}

- (NSUInteger)maxFrames {
    return [_audioRecorder framePerSecond] * 35;
}

- (NSString *)receiveFilePath:(NSString *)fileName {
    return[[[self applicationDocumentDirectory] stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"raw"];
}

- (NSString *)applicationDocumentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)viewWillDisappear:(BOOL)animated {
    _receiveData = nil;
}

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

