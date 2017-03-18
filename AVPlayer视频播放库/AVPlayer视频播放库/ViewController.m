//
//  ViewController.m
//  AVPlayer视频播放库
//
//  Created by 孙承秀 on 2017/2/28.
//  Copyright © 2017年 孙承秀. All rights reserved.
//

#import "ViewController.h"
#import "SCXPlayer.h"
#import <Masonry.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kCellID @"cellID"
@interface ViewController (){

    SCXPlayer *scxPlayer;
    CGRect     playerFrame;

}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加蒙版效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = self.view.frame;
    effectView.alpha = 0.9;
    [self.view insertSubview:effectView aboveSubview:self.view];
    SCXPlayer *player = [[SCXPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.75)];
    playerFrame = player.frame;
    scxPlayer = player;
    player.urlString = @"http://admin.weixin.ihk.cn/ihkwx_upload/test.mp4";
    player.delegate = self;
    [player.titleNameLabel setText:@"视频播放"];
    player.closeBtn.hidden = NO;
    player.isAllowVideoPlayBackground = YES;
    [self.view addSubview:player];
    [player play];
    
    
    
}
-(void)scxplayer:(SCXPlayer *)player didFullScreen:(UIButton *)btn{

    if (btn.isSelected) {//全屏显示
        scxPlayer.isFullScreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}
- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [scxPlayer removeFromSuperview];
    scxPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        scxPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        scxPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    scxPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    scxPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);
 
    [scxPlayer.bottomToolBar
     mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [scxPlayer.topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(scxPlayer).with.offset(0);
        make.width.mas_equalTo(kScreenHeight);
    }];
    [scxPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(scxPlayer.topToolBar).with.offset(5);
        make.height.mas_equalTo(30);
        make.top.equalTo(scxPlayer.topToolBar).with.offset(5);
        make.width.mas_equalTo(30);
    }];
    [scxPlayer.titleNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scxPlayer.topToolBar).with.offset(45);
        make.right.equalTo(scxPlayer.topToolBar).with.offset(-45);
        make.center.equalTo(scxPlayer.topToolBar);
        make.top.equalTo(scxPlayer.topToolBar).with.offset(0);
        
    }];
    [scxPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [scxPlayer.loadingActivityIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:scxPlayer];
    scxPlayer.fullScreenButton.selected = YES;

    [scxPlayer bringSubviewToFront:scxPlayer.topToolBar];
    [scxPlayer bringSubviewToFront:scxPlayer.bottomToolBar
];
    
}
-(void)toNormal{
    [scxPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        scxPlayer.transform = CGAffineTransformIdentity;
        scxPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        scxPlayer.playerLayer.frame =  scxPlayer.bounds;
        [self.view addSubview:scxPlayer];
        [scxPlayer.bottomToolBar
         mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scxPlayer).with.offset(0);
            make.right.equalTo(scxPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(scxPlayer).with.offset(0);
        }];
        
        
        [scxPlayer.topToolBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scxPlayer).with.offset(0);
            make.right.equalTo(scxPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(scxPlayer).with.offset(0);
        }];
        
        
        [scxPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scxPlayer.topToolBar).with.offset(5);
            make.height.mas_equalTo(30);
            make.top.equalTo(scxPlayer.topToolBar).with.offset(5);
            make.width.mas_equalTo(30);
        }];
        
        
        [scxPlayer.titleNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scxPlayer.topToolBar).with.offset(45);
            make.right.equalTo(scxPlayer.topToolBar).with.offset(-45);
            make.center.equalTo(scxPlayer.topToolBar);
            make.top.equalTo(scxPlayer.topToolBar).with.offset(0);
        }];
        
        [scxPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(scxPlayer);
            make.width.equalTo(scxPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        scxPlayer.isFullScreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        scxPlayer.fullScreenButton.selected = NO;
        
    }];
}


@end
