#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoSomeDelegate <NSObject>

@required

- (void)flushCurrentTime:(NSString *)timeString sliderValue:(float)sliderValue;

//- (void)flushVideoLength:(float)videoLength;

@end

@interface VideoView : UIView

@property (nonatomic ,strong) NSString *playerUrl;

@property (nonatomic ,readonly) AVPlayerItem *item;

@property (nonatomic ,readonly) AVPlayerLayer *playerLayer;

@property (nonatomic ,readonly) AVPlayer *player;

@property (nonatomic ,weak) id <VideoSomeDelegate> someDelegate;

- (id)initWithUrl:(NSString *)path delegate:(id<VideoSomeDelegate>)delegate;

- (void)setPlayerUrl:(NSString *)playerUrl;

@end

@interface VideoView  (Guester)

- (void)addSwipeView;

@end

