
#import <UIKit/UIKit.h>
#import "SoundFieldMicGraphView.h"
#import "SoundFieldMicControlView.h"
#import "SoundFieldMicChannelSelectionView.h"
@interface SoundFieldMicView : UIView 

@property (nonatomic, strong) SoundFieldMicGraphView *graphView;
@property (nonatomic, strong) SoundFieldMicControlView *controlView;
@property (nonatomic, strong) SoundFieldMicChannelSelectionView *channelSelectionView;
@end
