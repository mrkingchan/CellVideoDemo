//
//  VideoCell.h
//  CellVideoDemo
//
//  Created by Chan on 2018/1/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoCell : UITableViewCell

@property(nonatomic,copy)void (^complete)();

@property(nonatomic,strong) AVPlayer *player;

@property(nonatomic,strong) NSString *videoPath;

- (void)setCellWithData:(id)model;

-(void)clearConfig;

@end
