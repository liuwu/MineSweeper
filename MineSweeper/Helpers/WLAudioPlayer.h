//
//  WLAudioPlayer.h
//  MineSweeper
//
//  Created by liuwu on 2018/10/23.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLAudioPlayer : NSObject

/**
 *  播放自定义或者系统声音文件
 *
 *  @param aFileName    要播放的文件名
 *  @param aBundelName  存储路径
 *  @param ext          文件后缀
 *  @param alert        是否播放自定义或者系统文件
 * */
+ (void)playSoundWithFileName:(NSString *)aFileName
                   bundleName:(NSString *)aBundelName
                       ofType:(NSString *)ext
                     andAlert:(BOOL)alert;

@end

NS_ASSUME_NONNULL_END
