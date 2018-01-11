//
//  VideoCell.m
//  CellVideoDemo
//
//  Created by Chan on 2018/1/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "VideoCell.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoCell(){
    AVPlayer *_player;
    AVPlayerItem *_item;
    AVPlayerLayer *_layer;
    UIView *_colorView;
}

@end
@implementation VideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        /*_colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, [UIScreen mainScreen].bounds.size.width, 10)];
        _colorView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_colorView];*/
    }
    return self;
}

-(void)setCellWithData:(NSString *)model {
    self.videoPath = model;
    _item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model]];
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    _player = [[AVPlayer alloc] initWithPlayerItem:_item];
    _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    _layer.contentsScale = [UIScreen mainScreen].scale;
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.contentView.layer addSublayer:_layer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath rangeOfString:@"status"].length) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
//            [_player play];
            /*if (_complete) {
                _complete();
            }*/
        }
    }
}

- (void)clearConfig {
    [_player pause];
    [_layer removeFromSuperlayer];
    [_item removeObserver:self forKeyPath:@"status"];
    _player = nil;
    _item = nil;
    _layer = nil;
}

@end
