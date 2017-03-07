//
//  SoundFieldMicRecorder.h
//  SoundFieldMic
//
//  Created by zhicheng ren on 2016/11/28.
//  Copyright © 2016年 Yinkman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class SoundFieldMicRecorder;

typedef NS_ENUM(NSUInteger, YMAudioRecorderPermissionStatus) {
    YMAuidoRecorderPermissionStatusNotRequest,
    YMAuidoRecorderPermissionStatusDenied,
    YMAuidoRecorderPermissionStatusGranted
};

@protocol YMAudioRecorderDelegate <NSObject>
- (void)auidoRecorder:(SoundFieldMicRecorder *)audioRecorder didEncounterError:(NSError *)error;
- (void)audioRecorderDidStart:(SoundFieldMicRecorder *)audioRecorder;
- (void)audioRecorderDidStop:(SoundFieldMicRecorder *)audioRecorder;
- (void)audioRecorder:(SoundFieldMicRecorder *)audioRecorder capturedFrames:(NSUInteger)frameCount data:(NSData *)framwData;


@end


typedef struct {
    UInt32 firstChannelNumber;
    BOOL  isStereo;
    UInt32  frameCount;
    UInt32  sampleNumber;
} soundStruct, *soundStructPtr;


@interface SoundFieldMicRecorder : NSObject{
    soundStruct soundStructInfo;
//    AudioComponentInstance audioUnit;
    AudioBufferList         *_bufferList;
    AVAudioSession          *_session;
    __weak id<YMAudioRecorderDelegate>_delegate;
}

- (id)initWithDelegate:(id<YMAudioRecorderDelegate>)delegate;
- (void)start;
- (void)stop;

@property (nonatomic, assign, readonly) BOOL hasInputs;
@property (nonatomic, assign, readonly) YMAudioRecorderPermissionStatus permissionStatus;
@property (nonatomic, assign, readonly) NSUInteger bufferLengthInFrames;
@property (nonatomic, assign, readonly) NSUInteger framePerSecond;
@property (nonatomic, assign, readonly) NSUInteger framesSizeInBytes;
@property (readonly) AudioComponentInstance audioUnit;

void writeNewAudio(float *newData, UInt32 thisNumFramws, UInt32 thisNumChannels);
@end
