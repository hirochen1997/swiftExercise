//
//  SEVideoPlayController.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/21.
//

#ifndef SEVideoPlayController_h
#define SEVideoPlayController_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SEVideoPlayController : UIViewController {
    AVPlayerLayer *playLayer;
    UIButton *playBtn;
    UILabel *timeLabel;
    UISlider *progressSlider;
    id timeObserver;
}

- (void)playVideoWithURL: (NSString* _Nonnull)url;
- (void)addTimeObserver;
- (void)changeTimeLabel:(int) playTime
                  total:(double) totalTime;
- (void) removeTimeObserver;

@end

#endif /* SEVideoPlayController_h */
