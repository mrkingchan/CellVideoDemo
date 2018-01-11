//
//  ViewController.m
//  CellVideoDemo
//
//  Created by Chan on 2018/1/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ViewController.h"
#import "VideoCell.h"
#import <AVFoundation/AVFoundation.h>
static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    AVPlayer *_player;
    UISlider *_slider;
    UILabel *_currentTime;
    UILabel *_totalTime;
    UIView *_hudView;
}

@end

@implementation ViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
    //播放状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    //缓冲总时间
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    // 缓冲区空了，需要等待数据
    [item addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    // 缓冲区有足够数据可以播放了
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];

    _player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame = self.view.bounds;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:layer];

    _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 20, 120, 20)];
    _currentTime.textAlignment = 1;
    _currentTime.textColor = [UIColor whiteColor];
    _currentTime.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_currentTime];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(120, [UIScreen mainScreen].bounds.size.height - 20, [UIScreen mainScreen].bounds.size.width - 240, 5.0)];
    [self.view addSubview:_slider];

    
    _totalTime = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width  - 120, _slider.frame.origin.y, 120, 20)];
    _totalTime.textAlignment = 1;
    _totalTime.textColor = [UIColor whiteColor];
    _totalTime.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_totalTime];
    
    _totalTime.text = [self toTimeStrWithSeconds:CMTimeGetSeconds(_player.currentItem.duration)];

    [_slider addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
    
    [_player  addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                           queue:dispatch_get_main_queue()
                                      usingBlock:^(CMTime time) {
                                          float currentValue = CMTimeGetSeconds(time);
                                          float totalValue = CMTimeGetSeconds(item.duration);
                                          _totalTime.text = [self toTimeStrWithSeconds:totalValue];
                                          _currentTime.text = [self toTimeStrWithSeconds:currentValue];
                                          [_slider setValue: currentValue / totalValue];
                                      }];
    
    //播放进度相关
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playtoEndAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jumpedTimeAction:) name:AVPlayerItemTimeJumpedNotification object:_player];
    
    //播放后台相关
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:_player];*/

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:0];
    _dataArray = [NSMutableArray new];
    NSString *path = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    for (int i = 0; i < 6; i ++) {
        [_dataArray addObject:path];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
     [self.view addSubview:_tableView];
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 300)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;
    _hudView.layer.borderColor = [UIColor orangeColor].CGColor;
    _hudView.layer.borderWidth = 2.0;
    [self.view addSubview:_hudView];
}

- (void)slideAction:(UISlider *)slider {
    float percent = slider.value;
    float value = CMTimeGetSeconds(_player.currentItem.duration) * percent;
    [_player seekToTime:CMTimeMake(value, 1.0) completionHandler:^(BOOL finished) {
        NSLog(@"---------");
    }];
}

- (NSString *)toTimeStrWithSeconds:(NSInteger)seconds {
    NSInteger hour = seconds / 3600;
    NSInteger minute = seconds / 60;
    NSInteger second = ((NSInteger) seconds) %60;
    NSString *secondstr= [NSString stringWithFormat:@"%@%zd" ,second< 10 ? @"0":@"" ,second];
    NSString *minuteStr= [NSString stringWithFormat:@"%@%zd" ,minute< 10 ? @"0":@"" ,minute];
    NSString *hourStr= [NSString stringWithFormat:@"%@%zd" ,hour< 10 ? @"0":@"" ,hour];
     return  [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondstr];
}

- (void)applicationDidBackground:(NSNotification *)noti {
    [_player pause];
}

- (void)playtoEndAction:(NSNotification *)noti {
    [_player  seekToTime:kCMTimeZero
       completionHandler:^(BOOL finished) {
           //复原之后一般使进度条跳到值为0的开头
           [_slider setValue:0.0];
       }];
}

- (void)jumpedTimeAction:(NSNotification *)noti {
    puts(__func__);
}

#pragma mark --UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kcellID = @"kcellID";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithData:_dataArray[indexPath.row]];
    /*CGRect rec1 = [tableView rectForRowAtIndexPath:indexPath];
    VideoCell *videoCell = (VideoCell *)cell;
    __weak typeof(videoCell)weakCell = videoCell;
    if (CGRectContainsRect(CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 250), rec1)) {
        videoCell.complete = ^{
            [weakCell.player play];
        };
    } else {
        [videoCell.player pause];
    }*/
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    puts(__func__);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *videoCell = (VideoCell *)cell;
    [videoCell clearConfig];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   /* VideoCell *videoCell = (VideoCell *)cell;
    __weak typeof(videoCell)weakCell = videoCell;
    videoCell.complete = ^{
        [weakCell.player play];
    };*/
    /*// cell相对于frame的相对坐标
    CGRect rec1 = [tableView rectForRowAtIndexPath:indexPath];
    if (CGRectContainsRect(CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 250), rec1)) {
        videoCell.complete = ^{
            [weakCell.player play];
        };
    } else {
        [videoCell.player pause];
    }*/
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *item =(AVPlayerItem *)object;
        if ([keyPath rangeOfString:@"status"].length) {
            //播放状态
            if (item.status == AVPlayerStatusReadyToPlay) {
                [_player play];
            } else if (item.status == AVPlayerStatusFailed) {
                NSLog(@"失败!");
            } else if (item.status == AVPlayerStatusUnknown) {
                NSLog(@"未知!");
            }
        } else if ([keyPath rangeOfString:@"loadedTimeRanges"].length) {
            //缓冲
            NSArray *caches = item.loadedTimeRanges;
            CMTimeRange range = [caches.firstObject CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(range.start);
            float durationSeconds  = CMTimeGetSeconds(range.duration);
            float cachesSeconds =  startSeconds + durationSeconds;
            NSString *subStr = @"%";
            float totalDuration = CMTimeGetSeconds(item.duration);
            NSLog(@"共缓冲了%@%.2f",subStr,cachesSeconds / totalDuration * 100.0);
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        NSArray *cells = [_tableView visibleCells];
        for (int i = 0; i < cells.count; i ++) {
            VideoCell *cell = (VideoCell *) cells[i];
//             __weak typeof(cell)weakCell = cell;
            /*cell.complete = ^{
             if (weakCell.player.currentItem.status == 1) {
             [weakCell.player play];
             }
             };*/
            //cell在tableView中的frame
            CGRect rec = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CGFloat hudbottom = _hudView.frame.origin.y + _hudView.frame.size.height;
            CGFloat cellBottom = rec.origin.y + rec.size.height;
            CGFloat hudtop = _hudView.frame.origin.y;
            CGFloat celltop = _hudView.frame.origin.y;
            if (!CGRectContainsRect(_hudView.frame, rec)) {
                [cell.player pause];
                continue;
            }
            if (!(hudbottom >=cellBottom && celltop >=hudtop)) {
                [cell.player pause];
                continue;
            }
                if ((hudbottom >=cellBottom && celltop >=hudtop)) {
                    NSLog(@"hud = %@ -- cell = %@",NSStringFromCGRect(_hudView.frame),NSStringFromCGRect(rec));
                    NSLog(@"index = %zd",i);
                    NSLog(@"stataus == %zd", cell.player.currentItem.status);
                    [cell.player play];
                    break;
                }
            }
    }
}

+ (CGRect)relativeFrameForScreenWithView:(UIView *)v {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}
@end
