//
//  ChatHistoryTableViewCell.m
//  MineSweeper
//
//  Created by liuwu on 2018/9/29.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "ChatHistoryTableViewCell.h"

#import "QMUILabel.h"

#import "WLRongCloudDataSource.h"
#import "IFriendModel.h"

#define kLogoWidth 36.f

@interface ChatHistoryTableViewCell()

@property (nonatomic, strong) QMUILabel *infoLabel;

@property (nonatomic, strong) UIImageView *imgImageView;

@end

@implementation ChatHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textLabel.font = UIFontMake(15.f);
    self.textLabel.textColor = WLColoerRGB(51.f);
    
    self.detailTextLabel.font = UIFontMake(14.f);
    self.detailTextLabel.textColor = WLColoerRGB(153.f);
    
    QMUILabel *infoLabel = [[QMUILabel alloc] init];
    infoLabel.font = UIFontMake(14);
    infoLabel.textColor = WLColoerRGB(102.f);
    infoLabel.numberOfLines = 0.f;
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UIImageView *imgImageView = [[UIImageView alloc] init];
    imgImageView.hidden = YES;
    [self.contentView addSubview:imgImageView];
    self.imgImageView = imgImageView;
}

- (void)setMessage:(RCMessage *)message {
    _message = message;
    
    if ([_message.content isMemberOfClass:[RCTextMessage class]]) {
        _imgImageView.hidden = YES;
        _infoLabel.hidden = NO;
        RCTextMessage *txtMsg = (RCTextMessage *) _message.content;
        self.textLabel.text = @" ";//message.senderUserInfo.name;
        long time = _message.messageDirection == MessageDirection_RECEIVE  ? _message.receivedTime : _message.sentTime;
        self.detailTextLabel.text = [NSString dateTimeStampFormatTodateStr:time];
        WEAKSELF
//        if (_message.conversationType == ConversationType_GROUP) {
//            [[WLRongCloudDataSource shareInstance] getLocalGroupInfoWithGroupId:_message.targetId completion:<#^(IGameGroupModel *)completion#>: completion:^(IFriendModel *friendModel) {
//                weakSelf.textLabel.text = friendModel.nickname;//message.senderUserInfo.name;
//            }];
//        } else {
//
//        }

        [[WLRongCloudDataSource shareInstance] getLocalUserInfoWithUserId:_message.senderUserId completion:^(IFriendModel *friendModel) {
            weakSelf.textLabel.text = friendModel.nickname;//message.senderUserInfo.name;
        }];
        
        // @"2017.03.04";// [NSString stringWithFormat:@"%ll",time];
        _infoLabel.text = txtMsg.content;
        [self.imageView setImageWithURL:[NSURL URLWithString:txtMsg.senderUserInfo.portraitUri]
                            placeholder:[UIImage imageNamed:@"game_friend_icon"]
                                options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                             completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                 if (image) {
                                     weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                                 }else {
                                     weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                                 }
                             }];
    }
    
    if ([message.content isMemberOfClass:[RCImageMessage class]]) {
        _imgImageView.hidden = NO;
        _infoLabel.hidden = YES;
        RCImageMessage *imgMsg = (RCImageMessage *) _message.content;
        self.textLabel.text = @" ";//message.senderUserInfo.name;
        long time = _message.messageDirection == MessageDirection_RECEIVE  ? _message.receivedTime : _message.sentTime;
        WEAKSELF
        [[WLRongCloudDataSource shareInstance] getLocalUserInfoWithUserId:_message.senderUserId completion:^(IFriendModel *friendModel) {
            weakSelf.textLabel.text = friendModel.nickname;//message.senderUserInfo.name;
        }];
        
        self.detailTextLabel.text = [NSString dateTimeStampFormatTodateStr:time];// @"2017.03.04";// [NSString
        self.imgImageView.image = imgMsg.thumbnailImage;
        [self.imageView setImageWithURL:[NSURL URLWithString:imgMsg.senderUserInfo.portraitUri]
                            placeholder:[UIImage imageNamed:@"game_friend_icon"]
                                options:YYWebImageOptionProgressive | YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage
                             completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                 if (image) {
                                     weakSelf.imageView.image = [image qmui_imageWithClippedCornerRadius:36.f/2];
                                 }else {
                                     weakSelf.imageView.image = [UIImage imageNamed:@"game_friend_icon"];
                                 }
                             }];
    }
}

//- (void)setRecommendModel:(IRecommendInfoModel *)recommendModel {
//    _recommendModel = recommendModel;
//
//    self.textLabel.text = _recommendModel.nickname;
//    self.detailTextLabel.text = _recommendModel.add_time;// @"2018-8-12";

//}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView wl_setCornerRadius:kLogoWidth/2];
    //    [self.imageView wl_setBorderWidth:0.5f color:WLColoerRGB(153.f)];
    self.imageView.size = CGSizeMake(kLogoWidth, kLogoWidth);
    self.imageView.top = 13.f;
    self.imageView.left = 10.f;
    
    self.textLabel.left = self.imageView.right + 10.f;
    self.textLabel.top = self.imageView.top;
    
    self.detailTextLabel.left = self.imageView.right + 10.f;
    self.detailTextLabel.top = self.textLabel.bottom + 3.f;
    
    if ([_message.content isMemberOfClass:[RCTextMessage class]]) {
        [_infoLabel sizeToFit];
        _infoLabel.width = self.contentView.width - _infoLabel.left - 10.f;
        _infoLabel.top = self.detailTextLabel.bottom + 3.f;
        _infoLabel.left = self.detailTextLabel.left;
    }
    
    if ([_message.content isMemberOfClass:[RCImageMessage class]]) {
        _imgImageView.size = CGSizeMake(40, 80.f);
        _imgImageView.top = self.detailTextLabel.bottom + 3.f;
        _imgImageView.left = self.detailTextLabel.left;
    }
}

//返回cell的高度
+ (CGFloat)configureWithMessage:(RCMessage *)message {
    CGFloat height = 94.f;
    CGFloat maxWidth = DEVICE_WIDTH - kLogoWidth - kWL_NormalMarginWidth_10 * 3.f;
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *txtMsg = (RCTextMessage *) message.content;
        
        //计算第一个label的高度
        CGSize size1 = [@"name高度" wl_sizeWithCustomFont:WLFONT(15.f)];
        //计算第二个label的高度
        CGSize size2 = [@"time高度" wl_sizeWithFont:WLFONT(14) constrainedToWidth:maxWidth];
        //计算第三个label的高度
        CGSize size3 = [txtMsg.content wl_sizeWithFont:WLFONT(14) constrainedToWidth:maxWidth];
        
        height = size1.height + size2.height + 6 + size3.height + 13.f + 13.f;
    }
    if ([message.content isMemberOfClass:[RCImageMessage class]]) {
        //计算第一个label的高度
        CGSize size1 = [@"name高度" wl_sizeWithCustomFont:WLFONT(15.f)];
        //计算第二个label的高度
        CGSize size2 = [@"time高度" wl_sizeWithFont:WLFONT(14) constrainedToWidth:maxWidth];
        height = size1.height + size2.height + 6 + 80.f + 13.f + 13.f;
    }
    //    DLog(@"name:%@    msg:%@  height:%f",name,msg,height);
    if (height > 94.f) {
        return height;
    }else{
        return 94.f;
    }
}



@end
