//
//  WLAssetsGroupView.m
//  Welian
//
//  Created by dong on 2017/4/6.
//  Copyright © 2017年 chuansongmen. All rights reserved.
//

#import "WLAssetsGroupView.h"
#import "WLAssetsManager.h"

@implementation WLAssetsGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds = YES;
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
    
    UILabel *photoName = [[UILabel alloc] init];
    photoName.textColor = [UIColor blackColor];
    photoName.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:photoName];
    self.photoName = photoName;
    
    UILabel *photoNum = [[UILabel alloc] init];
    photoNum.textColor = [UIColor darkGrayColor];
    photoNum.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:photoNum];
    self.photoNumbar = photoNum;
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.equalTo(self.contentView).offset(5.f);
        make.bottom.equalTo(self.contentView).offset(-5.f);
        make.width.mas_equalTo(self.photoView.mas_height);
    }];
    [self.photoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.left.equalTo(self.photoView.mas_right).offset(10.f);
    }];
    [self.photoNumbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.left.equalTo(self.photoName.mas_right).offset(10.f);
    }];
}

@end

@interface WLAssetsGroupView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *albumsArray;
@property (nonatomic, strong) UITableView *tableView;

@end


static NSString *assetsGroupCellid = @"assetsGroupCellid";

@implementation WLAssetsGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 相册预览图的大小默认值
        self.albumTableViewCellHeight = 57.f;
        [self addSubview:self.tableView];
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    if (!self.albumsArray) {
        self.albumsArray = [NSMutableArray array];
    }else{
        [self.albumsArray removeAllObjects];
    }
    [[WLAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:WLAlbumContentTypeOnlyPhoto usingBlock:^(WLAssetsGroup *resultAssetsGroup) {
        if (resultAssetsGroup) {
            [self.albumsArray addObject:resultAssetsGroup];
        } else {
            CGFloat tableHeight = self.albumsArray.count * self.albumTableViewCellHeight;
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(tableHeight);
                make.height.mas_lessThanOrEqualTo(SuperSize.height*0.7);
                make.bottom.equalTo(self);
            }];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLAssetsGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:assetsGroupCellid];
    if (cell == nil) {
        cell = [[WLAssetsGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assetsGroupCellid];
    }
    WLAssetsGroup *assetsGroupM = self.albumsArray[indexPath.row];
    cell.photoView.image = [assetsGroupM posterImageWithSize:CGSizeMake(self.albumTableViewCellHeight, self.albumTableViewCellHeight)];
    cell.photoName.text = assetsGroupM.name;
    cell.photoNumbar.text = [NSString stringWithFormat:@"%ld", (long)[assetsGroupM countOfAssetsWithMediaType:PHAssetMediaTypeImage]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(assetsGroupsView:didSelectAssetsGroup:)]) {
        WLAssetsGroup *assetsGroupM = self.albumsArray[indexPath.row];
        [_delegate assetsGroupsView:self didSelectAssetsGroup:assetsGroupM];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = self.albumTableViewCellHeight;
        _tableView.rowHeight = self.albumTableViewCellHeight;
    }
    return _tableView;
}

@end

