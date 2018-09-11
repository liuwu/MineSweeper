//
//  WLHubProgressView.h
//  Welian
//
//  Created by weLian on 16/1/24.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^cancelBtnBlcok)(void);
//typedef void(^resumBtnBlcok)(void);

@interface WLHubProgressView : UIView

//@property (nonatomic, copy) cancelBtnBlcok cancelBlock;
//@property (nonatomic, copy) resumBtnBlcok resumBlock;

/**
 *  初始化数据信息
 */
- (void)initUIDataShowWithDetailInfo:(NSString *)detailInfo;

/**
 *  上传完成
 */
- (void)updateSueccess;

/**
 *  更新上传进度信息
 *
 *  @param progress 进度
 */
- (void)updateProgress:(CGFloat)progress;

@end
