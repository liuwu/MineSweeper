//
//  WLShareDataSource.h
//  Welian
//
//  Created by dong on 2018/5/14.
//  Copyright © 2018年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WLShareDataSource <NSObject>

@end

@protocol WLShareWLDataSource <NSObject>

@end

@protocol WLShareWXDataSource <NSObject>
/** 标题
 * @note 长度不能超过512字节
 */
- (NSString *)wx_title;
/** 描述内容
 * @note 长度不能超过1K
 */
- (NSString *)wx_description;
/** 缩略图数据
 * @note 大小不能超过32K
 */
- (NSData *)wx_thumbData;
/**
 * @note 长度不能超过64字节
 */
- (NSString *)wx_mediaTagName;
/**
 *
 */
@property (nonatomic, retain) NSString *messageExt;
@property (nonatomic, retain) NSString *messageAction;
/**
 * 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
 */
@property (nonatomic, retain) id        mediaObject;


@end

@protocol WLShareWXImageDataSource <NSObject>

@end

@protocol WLShareWXMiniProgramDataSource <NSObject>

- (NSString *)wx_webpageUrl; //低版本网页链接

- (NSString *)wx_userName;   //小程序username

- (NSString *)wx_path;       //小程序页面的路径

- (NSData *)wx_hdImageData;   // 小程序新版本的预览图 128k

@end
