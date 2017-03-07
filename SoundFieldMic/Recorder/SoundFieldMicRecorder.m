//
//  SoundFieldMicRecorder.m
//  SoundFieldMic
//
//  Created by zhicheng ren on 2016/11/28.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import "SoundFieldMicRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "HAMLogOutputWindow.h"

UInt32     channelNumbers;
@interface SoundFieldMicRecorder ()
- (OSStatus)processIncomingWithActionFlags:(AudioUnitRenderActionFlags *)ioActionFlags timestamp:(const AudioTimeStamp *)inTimeStamp busNumber:(UInt32)inBusNumber numberOfFrames:(UInt32)inNumberFrames;
@end

static OSStatus recordingCallback(void *inRefCon,
                                  AudioUnitRenderActionFlags *ioActionFlags,
                                  const AudioTimeStamp *inTimeStamp,
                                  UInt32 inBusNumber,
                                  UInt32 inNumberFrames,
                                  AudioBufferList *ioData){
    
    NSLog(@"<Recording Callback>");
    
    //the data gets rendered here
    AudioBufferList *recordingBufferList;
    //a variable where we check the status
    OSStatus status;
    //this is the reference to the object who owns the callback
    SoundFieldMicRecorder *audioRecorder = (__bridge SoundFieldMicRecorder *) inRefCon;
    /*
     On this point we define the numebr of channels, whick is mono for the iphone. the number of framws is usally 512 or 1024.
     */
    //we put out buffer into a bufferlist array for rendering.
    for (int i = 0; i < channelNumbers; i++) {
        recordingBufferList->mBuffers[0].mDataByteSize = inNumberFrames * 2;
        recordingBufferList->mBuffers[0].mNumberChannels = 1;
        recordingBufferList->mBuffers[0].mData = malloc(inNumberFrames * 2);
    }
    
    //render input and check for error.

   
    
    
    
    return [audioRecorder processIncomingWithActionFlags:ioActionFlags
                                               timestamp:inTimeStamp
                                               busNumber:inBusNumber
                                          numberOfFrames:inNumberFrames];
}

@implementation SoundFieldMicRecorder
//{
//    AVAudioSession          *_session;
//    AudioComponentInstance  _audioUnit;
//    AudioBufferList         *_bufferList;
//    __weak id<YMAudioRecorderDelegate>_delegate;
//}

@synthesize audioUnit;

static NSInteger const kAudioRecorderOutBus    = 0;
static NSInteger const kAudioRecorderInputBus  = 1;
static UInt32 const kAudioRecorderBufferFrames = 1024;
static UInt32 const kAudioRecorderFrameSize    = 2;
static UInt32 const kAudioRecorderSampleRate   = 44100;



- (id)initWithDelegate:(id<YMAudioRecorderDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _session = [AVAudioSession sharedInstance];
        _permissionStatus = YMAuidoRecorderPermissionStatusNotRequest;
        
        
        //--------------------------------------------

        
        
        //--------------------------------------------
        
//        [_session requestRecordPermission:^(BOOL granted) {
//            _permissionStatus = granted ? YMAuidoRecorderPermissionStatusGranted : YMAuidoRecorderPermissionStatusDenied;
//        }];
        
        channelNumbers = 1;
        [self setupAudioSession];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioSessionInterupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        
    }
    return self;
}

- (void)start {
    NSError *error = nil;
    //tell session we're recording right out the gate.
    [_session setActive:YES error:&error];
    if ([self checkIeError:error]) {
        return;
    }
    
    
    //--------------------------------------------
    if (![_session inputDataSource]) {
        NSLog(@"大空");
//        [HAMLogOutputWindow printLog:@"dakong"];
        
    }else {
        for (AVAudioSessionDataSourceDescription *micName  in [_session inputDataSources]) {
            if (!micName) {
                
                NSLog(@"空");
//                [HAMLogOutputWindow printLog:@"kong"];;
            }else {
                NSString *name = micName.dataSourceName;
                NSLog(@"mic name =  %@",micName);
//                [HAMLogOutputWindow printLog:name];
            }
            
        }

    }
    //--------------------------------------------

    
    //Find the best mic.
//    NSInteger(^rateMic)(AVAudioSessionDataSourceDescription *mic) = ^NSInteger(AVAudioSessionDataSourceDescription *mic) {
//        NSInteger score = 0;
//        if (mic.location == AVAudioSessionLocationUpper) {
//            score += 20;
//        }
//        if (mic.orientation == AVAudioSessionOrientationBack) {
//            score += 10;
//        }else if (mic.orientation == AVAudioSessionOrientationTop) {
//            score += 5;
//        }else if (mic.orientation == AVAudioSessionOrientationBottom) {
//            score += 3;
//        }else if (mic.orientation == AVAudioSessionOrientationFront) {
//            score += 1;
//        }
//        return score;
//    };
    
    
    
//    AVAudioSessionDataSourceDescription *preferredMic = nil;//mic name / location / orientation.
//    NSInteger preferredMicScore = -1;
//    
//    for (AVAudioSessionDataSourceDescription *micType in [_session inputDataSources]) {
//        
//        NSInteger micScore = rateMic(micType);
//        if (micScore > preferredMicScore) {
//            preferredMic = micType;
//            preferredMicScore = micScore;
//        }
//    }
//    
//    if (preferredMic != nil) {
//        for (NSString *pattern in [preferredMic supportedPolarPatterns]) {
//            if (pattern == AVAudioSessionPolarPatternOmnidirectional) {
//                [preferredMic setPreferredPolarPattern:pattern error:&error];
//                if ([self checkIeError:error]) {
//                    return;
//                }
//            }
//        }
//        
//        [_session setInputDataSource:preferredMic error:&error];
//        if ([self checkIeError:error]) {
//            return;
//        }
//    }else {
//        NSLog(@"No prefered mic found - using the default");
//    }
    
    AudioOutputUnitStart(audioUnit);
    [_delegate audioRecorderDidStart:self];
}


- (void)stop {
    NSError *error = nil;
    
    AudioOutputUnitStop(audioUnit);
    [_session setActive:NO error:&error];
    if ([self checkIeError:error]) {
        return;
    }
    [_delegate audioRecorderDidStop:self];
}



- (OSStatus)processIncomingWithActionFlags:(AudioUnitRenderActionFlags *)ioActionFlags timestamp:(const AudioTimeStamp *)inTimeStamp busNumber:(UInt32)inBusNumber numberOfFrames:(UInt32)inNumberFrames {
    NSLog(@"SECOND - ");
    OSStatus status;
    status = AudioUnitRender(audioUnit,
                             ioActionFlags,
                             inTimeStamp,
                             inBusNumber,
                             inNumberFrames,
                             _bufferList);
    NSError *error = nil;
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitRender failed"
                           error:&error]) {
        return noErr;
    }
    
    //    SInt16 *p = (SInt16 *) _bufferList->mBuffers->mData;
    //
    //    float level = 0.0f;
    //
    //    for (int i = 0; i < inNumberFrames; i += 1) {
    //        float sample = (float) p[i] / 32768.0f;
    //
    //        if (sample > level) {
    //            level = sample;
    //        }
    //    }
    
    NSLog(@"captyre ---- capture ");

    @autoreleasepool {
        [_delegate audioRecorder:self
                  capturedFrames:inNumberFrames
                            data:[NSData dataWithBytes:_bufferList->mBuffers->mData
                                                length:_bufferList->mBuffers->mDataByteSize]];

  
    
    }
    return noErr;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:nil];
}
//hardware
- (bool)hasInputs {
    return [_session isInputAvailable];
}




- (void)setupAudioSession {
    NSError *error = nil;
    
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if ([self checkIeError:error]) {
        return;
    }
    
    [_session setMode:AVAudioSessionModeMeasurement error:&error];
    if ([self checkIeError:error]) {
        return;
    }
    
    if (_session.inputGainSettable) {
        [_session setInputGain:0.5 error:&error];
        if ([self checkIeError:error]) {
            return;
        }
    }
    
    OSStatus status;
    
    //Describe audio component. to create a audioComponent.
    AudioComponentDescription desc;
    desc.componentType         = kAudioUnitType_Output;//we want to output
    desc.componentSubType      = kAudioUnitSubType_RemoteIO;//we want in and out
    desc.componentFlags        = 0;//must be set to zero unless a known specific value is requested
    desc.componentFlagsMask    = 0;//must be set to zero unless a known specific value is requested
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;//select provider
    
    //Get component (find the AU component by description)
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
    
    //Get audio units (create audio unit by component)
    status = AudioComponentInstanceNew(inputComponent, &audioUnit);
    if ([self checkIsErrorStatus:status
                       operation:@"AudioComponentInstacneNew failed"
                           error:&error]) {
        return;
    }
    
    //Enable IO for recording. (Define that we want record io on the input bus.)
    UInt32 flag = 1;
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  kAudioRecorderInputBus,
                                  &flag,
                                  sizeof(flag));
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitSetProperty failed to enable recording"
                           error:&error]) {
        return;
    }
    

    //------------------------------------------
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  kAudioRecorderOutBus,
                                  &flag,
                                  sizeof(flag));
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitSetproperty failed to enable Output"
                           error:&error]) {
        return;
    }
    //------------------------------------------
    
    UInt32 CHANNELNUMBER = channelNumbers;
    //we need to specifie out format on which want to work, we use linear PCM cause its uncompressed and we work on raw data. for more information check.
    // we want 16 bits, 2 bytes per packet/framws at 44khz
    //Describe format.
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate       = kAudioRecorderSampleRate;
    audioFormat.mFormatID         = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags      = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mFramesPerPacket  = 1;
    audioFormat.mChannelsPerFrame = CHANNELNUMBER;
    audioFormat.mBitsPerChannel   = kAudioRecorderFrameSize *8;
    audioFormat.mBytesPerPacket   = kAudioRecorderFrameSize;
    audioFormat.mBytesPerFrame    = kAudioRecorderFrameSize;
    
    //Apply format. (set the format on the out stream)
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  kAudioRecorderInputBus,
                                  &audioFormat,
                                  sizeof(audioFormat));
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitSetProperty failed to set input format"
                           error:&error]) {
        return;
    }
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  kAudioRecorderOutBus,
                                  &audioFormat,
                                  sizeof(audioFormat));
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitSetProperty failed to set output format"
                           error:&error]) {
        return;
    }

    
    //we need to define a callback structure whick holds a pointer to recordingcall and a reference to the audio processor object(write to file).
    
    //Set input callback.
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = recordingCallback;
    callbackStruct.inputProcRefCon = (__bridge void *) self;
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Global,
                                  kAudioRecorderInputBus,
                                  &callbackStruct,
                                  sizeof(callbackStruct));
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitSetProperty failed to set input callback"
                           error:&error]) {
        return;
    }
   
//        AUChannelInfo inputAndOutputChannelNumber = {-1,-1};
//        status = AudioUnitSetProperty(_audioUnit,
//                                      kAudioUnitProperty_SupportedNumChannels,
//                                      kAudioUnitScope_Global,
//                                      0,
//                                      &inputAndOutputChannelNumber,
//                                      sizeof(inputAndOutputChannelNumber)
//                                      );
//    
//        if ([self checkIsErrorStatus:status
//                           operation:@"set multi channel failed"
//                               error:&error]) {
//            return;
//        }

    
    //------------------------------------------
    flag = 0;
    //we need to tell the aduio unit to allocate the render buffer, that we can directly write it.
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_ShouldAllocateBuffer,
                                  kAudioUnitScope_Output,
                                  kAudioRecorderInputBus,
                                  &flag,
                                  sizeof(flag));
    //------------------------------------------
    
    
    //------------------------------------------
    //first alloc buffer
    //we set the number of channels to mono and allocate out block size to 1024 bytes.
    
    status = [self allocateAudioBufferList];
    //------------------------------------------
    
    status = AudioUnitInitialize(audioUnit);
    if ([self checkIsErrorStatus:status
                       operation:@"AudioUnitInitialize failed"
                           error:&error]) {
        return;
    }
    
//    status = [self allocateAudioBufferList];
//    if ([self checkIsErrorStatus:status operation:@"Allocationg AudioBufferList failed" error:&error]) {
//        return;
//    }
    NSLog(@"set up completed");
}


- (OSStatus)allocateAudioBufferList{
    NSInteger const numChannels = channelNumbers;
    UInt32 const bufferSize = kAudioRecorderBufferFrames * sizeof(SInt16);
    
    _bufferList = (AudioBufferList *) calloc(1, sizeof(AudioBufferList) + numChannels * sizeof(AudioBuffer));
    
    if (_bufferList == NULL) {
        return -1;
    }
    _bufferList->mNumberBuffers = channelNumbers;
    for (UInt32 i = 0; i < numChannels; ++i) {
//        _bufferList->mBuffers[i].mNumberChannels = 1;
//        _bufferList->mBuffers[i].mDataByteSize = bufferSize;
//        _bufferList->mBuffers[i].mData = malloc(bufferSize);

        _bufferList->mBuffers[i].mNumberChannels = 1;
        _bufferList->mBuffers[i].mDataByteSize = 512 * 2;
        _bufferList->mBuffers[i].mData = malloc(512 * 2);
        if (_bufferList->mBuffers[i].mData == NULL) {
            [self destroyAudioBufferList];
            return -1;
        }
    }

//    _bufferList = (AudioBufferList *) malloc(sizeof(AudioBufferList) + sizeof(AudioBuffer) * (numChannels - 1));
//    _bufferList->mNumberBuffers = (UInt32)numChannels;
//    
//    AudioBuffer emptyBuffer = {0};
//    size_t arrayIndex;
//    for (arrayIndex = 0; arrayIndex < numChannels; arrayIndex++) {
//        _bufferList->mBuffers[arrayIndex] = emptyBuffer;
//    }
//    _bufferList->mBuffers[0].mNumberChannels = 1;
//    _bufferList->mBuffers[0].mDataByteSize = bufferSize;
//    _bufferList->mBuffers[0].mData = malloc(bufferSize);
//    
//    _bufferList->mBuffers[1].mNumberChannels = 1;
//    _bufferList->mBuffers[1].mDataByteSize = bufferSize;
//    _bufferList->mBuffers[1].mData = malloc(bufferSize);
//    
//    _bufferList->mBuffers[2].mNumberChannels = 1;
//    _bufferList->mBuffers[2].mDataByteSize = bufferSize;
//    _bufferList->mBuffers[2].mData = malloc(bufferSize);
//    
//    _bufferList->mBuffers[3].mNumberChannels = 1;
//    _bufferList->mBuffers[3].mDataByteSize = bufferSize;
//    _bufferList->mBuffers[3].mData = malloc(bufferSize);
//    
//    free(_bufferList);
    
    
    return noErr;
}

- (void)destroyAudioBufferList {
    if (_bufferList) {
        for (int i = 0; _bufferList->mNumberBuffers; i++) {
            if (_bufferList->mBuffers[i].mData) {
                free(_bufferList->mBuffers[i].mData);
            }
        }
        free(_bufferList);
    }
}

- (void)audioSessionInterupted:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *type = userInfo[AVAudioSessionInterruptionTypeKey];
    if (type != nil && [type unsignedIntegerValue] == AVAudioSessionInterruptionTypeBegan) {
        [_delegate auidoRecorder:self didEncounterError:nil];
    }
}


- (BOOL)checkIeError:(NSError *)error{
    if (error == nil) {
        return NO;
    }
    [_delegate auidoRecorder:self didEncounterError:error];
    return YES;
}

- (BOOL)checkIsErrorStatus:(OSStatus)status operation:(NSString *)operation error:(NSError **)error {
    if (status == noErr) {
        return NO;
    }
    if (error != nil) {
        *error = [NSError errorWithDomain:AVFoundationErrorDomain
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : operation}];
        [_delegate auidoRecorder:self didEncounterError:*error];
    }
    return YES;
}


- (NSUInteger)bufferLenghtInFrames {
    return kAudioRecorderBufferFrames;
}

- (NSUInteger)framesPerSecond {
    return kAudioRecorderSampleRate;
}

- (NSUInteger)framesSizeInBytes {
    return kAudioRecorderFrameSize;
}

@end
