//
//  WLAudioPlayer.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "WLAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation WLAudioPlayer

+ (void)playSoundWithFileName:(NSString *)aFileName bundleName:(NSString *)aBundleName ofType:(NSString *)ext andAlert:(BOOL)alert
{
    // 文件存储路径
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    
    if (!bundle) {
        DLog(@"play sound cannot find bundle: [%@]", aBundleName);
        return;
    }
    
    // 文件路径bundle
    NSString *path = [bundle pathForResource:aFileName ofType:ext];
    
    if (!path) {
        DLog(@"paly sound cannot find file [%@] in bundle [%@]", aFileName , aBundleName);
        return;
    }
    
    NSURL *urlFile = [NSURL fileURLWithPath:path];
    
    // 声明需要播放的音频文件ID[unsigned long];
    SystemSoundID ID;
    
    // 创建系统声音，同时返回一个ID
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlFile, &ID);
    
    if (err != kAudioServicesNoError) {
        DLog(@"play sound cannot create file url [%@]", urlFile);
        return;
    }
    
    // 根据ID播放自定义系统声音
    if (alert) {
        AudioServicesPlayAlertSound(ID);
    } else {
        AudioServicesPlaySystemSound(ID);
    }
}

@end
