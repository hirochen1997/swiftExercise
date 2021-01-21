//
//  SEVideoPlayController.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/21.
//

#import <Foundation/Foundation.h>
#import "SEVideoPlayController.h"
#import "SwiftExercise-Swift.h"

@implementation SEVideoPlayController

- (instancetype)init
{
    self = [super init];
    if (self) {
        playLayer = [[AVPlayerLayer alloc] init];
        playLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        
        playBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, UIScreen.mainScreen.bounds.size.height/2+130, 30, 30)];
        [playBtn setImage:[UIImage imageNamed:@"stop.jpg"] forState:normal];
        [playBtn setImage:[UIImage imageNamed:@"play.jpg"] forState:UIControlStateSelected];
        [playBtn addTarget:self action:@selector(changePlayStatus) forControlEvents:UIControlEventTouchDown];
        
        progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(playBtn.frame.origin.x+playBtn.frame.size.width+10, playBtn.frame.origin.y, UIScreen.mainScreen.bounds.size.width-120, playBtn.frame.size.height)];
        progressSlider.maximumValue = 1;
        progressSlider.minimumValue = 0;
        progressSlider.continuous = true;
        [progressSlider addTarget:self action:@selector(dragSlider) forControlEvents:UIControlEventTouchDragInside];
        [progressSlider addTarget:self action:@selector(touchUpSlider) forControlEvents:UIControlEventTouchUpInside];
        [progressSlider addTarget:self action:@selector(touchUpSlider) forControlEvents:UIControlEventTouchUpOutside];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-80, playBtn.frame.origin.y, 70, playBtn.frame.size.height)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = UIColor.whiteColor;
        timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.blackColor;
    
    [self.view.layer addSublayer:playLayer];
    [self.view addSubview:playBtn];
    [self.view addSubview:progressSlider];
    [self.view addSubview:timeLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
    timeLabel.text = CMTimeGetSeconds(playLayer.player.currentItem.duration) >= 3600 ? @"00:00:00" : @"00:00";
    playBtn.selected = false;
    [playLayer.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = true;
    [playLayer.player pause];
}

- (void)playVideoWithURL:(NSString *)url {
    [self removeTimeObserver]; // // 先去掉原来的player的observer
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
    playLayer.player = player;
    [self addTimeObserver];
}

- (void)changePlayStatus {
    if (playBtn.selected) {
        [playLayer.player play];
        playBtn.selected = false;
    } else {
        [playLayer.player pause];
        playBtn.selected = true;
    }
}

- (void)addTimeObserver {
    __weak SEVideoPlayController *weakRef = self;
    timeObserver = [playLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1, NSEC_PER_SEC) queue:nil usingBlock:^(CMTime time) {
        SEVideoPlayController *otherRef = weakRef;
        int playTime = CMTimeGetSeconds(time);
        double totalTime = CMTimeGetSeconds(otherRef->playLayer.player.currentItem.duration);
        float progress = CMTimeGetSeconds(time) / totalTime;
        
        // 修改进度条&时间显示
        [otherRef changeTimeLabel:playTime total:totalTime];
        otherRef->progressSlider.value = progress;
        
        if (progress == 1.0) {
            //播放百分比为1表示已经播放完毕
            [otherRef->playLayer.player pause];
            [otherRef->playLayer.player seekToTime:CMTimeMake(0, 1)];
            otherRef->playBtn.selected = true;
        }
    }];
}

- (void)changeTimeLabel:(int) playTime
                  total:(double) totalTime {
    // 修改进度条&时间显示
    NSString *hour = [(playTime / 3600 < 10 ? @"0" : @"") stringByAppendingString: [NSString stringWithFormat:@"%d",playTime/3600]];
    NSString *minute = [(playTime % 3600 / 60 < 10 ? @"0" : @"") stringByAppendingString:[NSString stringWithFormat:@"%d",playTime%3600/60]];
    NSString *second = [(playTime % 3600 % 60 < 10 ? @"0" : @"") stringByAppendingString:[NSString stringWithFormat:@"%d",playTime%3600%60]];

    if (totalTime >= 3600) {
        // 超过1小时的采用时分秒
        timeLabel.text = [[[[hour stringByAppendingString:@":"] stringByAppendingString:minute]stringByAppendingString:@":"] stringByAppendingString:second];
        
    } else {
        // 1小时以内的采用分秒
        timeLabel.text = [[minute stringByAppendingString:@":"] stringByAppendingString:second];
    }
}

- (void) removeTimeObserver {
    if (timeObserver != nil) {
        [playLayer.player removeTimeObserver:timeObserver];
        timeObserver = nil;
    }
}

- (void) dragSlider {
    [self removeTimeObserver];
}

- (void) touchUpSlider {
    [playLayer.player pause];
    
    __weak SEVideoPlayController *weakRef = self;
    [playLayer.player seekToTime:CMTimeMakeWithSeconds(progressSlider.value*CMTimeGetSeconds(playLayer.player.currentItem.duration), NSEC_PER_SEC) toleranceBefore:CMTimeMakeWithSeconds(0, 1) toleranceAfter:CMTimeMakeWithSeconds(0, 1) completionHandler:^(BOOL finished) {
        if (finished == true) {
            SEVideoPlayController *otherRef = weakRef;
            [otherRef changeTimeLabel:otherRef->progressSlider.value*CMTimeGetSeconds(otherRef->playLayer.player.currentItem.duration)  total:CMTimeGetSeconds(otherRef->playLayer.player.currentItem.duration)];
            [otherRef addTimeObserver];
            if (!otherRef->playBtn.selected) {
                [otherRef->playLayer.player play];
            }
        }
    }];
}


@end
