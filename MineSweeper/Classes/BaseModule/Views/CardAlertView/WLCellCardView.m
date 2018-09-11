//
//  WLCellCardView.m
//  Welian
//
//  Created by dong on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLCellCardView.h"

@implementation WLCellCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addUIView];
    }
    return self;
}

- (void)addUIView
{
    self.backgroundColor = [UIColor clearColor];
    self.isHidLine = YES;
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    _iconImage.backgroundColor = kWLNormalLightGrayColor;
    [self addSubview:_iconImage];
    
    _titLabel = [[UILabel alloc] init];
    _titLabel.font = WLFONT(14);
    _titLabel.textColor = WLRGB(51, 51, 51);
    [self addSubview:_titLabel];
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = WLFONT(13);
    _detailLabel.textColor = WLRGB(173, 173, 173);
    [self addSubview:_detailLabel];
    
    _tapBut = [[UIButton alloc] init];
    _tapBut.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _tapBut.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_tapBut];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.cardM) {
        [self setCardM:_cardM];
    }
}

- (void)setIsHidLine:(BOOL)isHidLine
{
    _isHidLine = isHidLine;
    if (!_isHidLine) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 0.6;
        self.layer.borderColor = [WLRGB(220, 220, 220) CGColor];
    }else{
        self.layer.borderWidth = 0.f;
    }
}

- (void)setCardM:(CardStatuModel *)cardM
{
    [_iconImage wl_setBorderWidth:0.5f color:[UIColor wl_HexE5E5E5]];
    [_iconImage wl_setCornerRadius:5];
    //3 活动，10项目，11 网页  13 投递项目卡片 14 用户名片卡片 15 投资人索要项目卡片  20 项目集 21投资人详情
    _cardM = cardM;
    
    if (cardM.type.integerValue==11) {
        [_titLabel setNumberOfLines:2];
        _titLabel.frame = CGRectMake(55, 8, self.frame.size.width-55-8, 42);
        [_detailLabel setHidden:YES];
    }else{
        [_titLabel setNumberOfLines:1];
        [_detailLabel setHidden:NO];
        _titLabel.frame = CGRectMake(55, 8, self.frame.size.width-55-8, 21);
        _detailLabel.frame = CGRectMake(55, CGRectGetMaxY(_titLabel.frame), self.frame.size.width-55-8, 21);
    }
    
    NSInteger typeint = cardM.type.integerValue;
    NSString *imageName = @"";
    BOOL cidBool = cardM.cid.boolValue;
    switch (typeint) {
        case 3:
        case 5:
        {
            //活动
            imageName = cidBool? @"home_repost_huodong":@"home_repost_huodong_no";
        }
            break;
        case 4:
        case 6:
        {
            // 个人信息
            imageName = @"home_repost_beijing";
        }
            break;
        case 10:
        case 12:
        case 13:
        {
            //项目
            imageName = cidBool? @"home_repost_xiangmu":@"home_repost_xiangmu_no";
        }
            break;
        case 11:
        {
            // 网页
            imageName = @"home_repost_link";
            NSRange range = [cardM.url rangeOfString:@"toutiao"];
            if (range.length > 0 ) {
                imageName = @"home_repost_toutiao";
            }

        }
            break;
        case 14:
        case 15:
        case 21://投资人详情
        {
            //名片  需要下载
            [_iconImage sd_setImageWithURL:[NSURL URLWithString:[_cardM.url wl_imageUrlDownloadImageSceneAvatar]]
                          placeholderImage:[UIImage imageNamed:@"user_small"]
                                   options:SDWebImageRetryFailed|SDWebImageLowPriority
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         _iconImage.image = image;
                                     }else{
                                         _iconImage.image = [UIImage imageNamed:@"user_small"];
                                     }
                                 }];
        }
            break;
          case 16:
        {
            imageName = @"topic_icon_placeholder";
        }
            break;
        default:
            break;
    }
    if (cardM.logo.length) {
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:[cardM.logo wl_imageUrlDownloadImageSceneAvatar]] placeholderImage:[UIImage imageNamed:imageName]];
    }else{
        if(imageName.length > 0){
            [_iconImage setImage:[UIImage imageNamed:imageName]];
        }
    }
    _titLabel.text = cardM.title;
    _detailLabel.text = cardM.intro;
}

@end
