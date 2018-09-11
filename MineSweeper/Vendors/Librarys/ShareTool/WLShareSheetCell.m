//
//  ZYShareSheetCell.m
//  
//
//  Created by ZZY on 16/3/28.
//
//

#import "WLShareSheetCell.h"

static NSString *zy_share_item_cell_id = @"ZYShareItemCell";

@interface WLShareSheetCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation WLShareSheetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ZYShareSheetCell";
    WLShareSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WLShareSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = nil;
    [self.contentView addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zy_share_item_cell_id forIndexPath:indexPath];
    WLActivity *item = self.itemArray[indexPath.item];
    NSAssert([item isKindOfClass:[WLActivity class]], @"数组`shareArray`或者`functionArray`的元素必须为WLActivity对象");
    cell.item = item;
    return cell;
}

#pragma mark - setter
- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = nil;
        [_collectionView registerClass:[WLShareItemCell class] forCellWithReuseIdentifier:zy_share_item_cell_id];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, ZY_ItemCellPadding / 2, 0, ZY_ItemCellPadding / 2);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(ZY_ItemCellWidth, ZY_ItemCellHeight);
    }
    return _flowLayout;
}

@end

@implementation WLShareItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.bageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topPadding = 20.f;
    CGFloat cellWidth = self.frame.size.width;
    
    // 图标
    CGFloat iconViewX = ZY_ItemCellPadding / 2;
    CGFloat iconViewY = topPadding;
    CGFloat iconViewW = cellWidth - ZY_ItemCellPadding;
    CGFloat iconViewH = cellWidth - ZY_ItemCellPadding;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);

    // 标题
    CGFloat titleViewX = 0;
    CGFloat titleViewY = CGRectGetMaxY(self.iconView.frame) + 5;
    CGFloat titleViewW = cellWidth;
    CGFloat titleViewH = WL_ItemCellTitleHeight;
    self.titleView.frame = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    
    CGFloat bageW = 32.f;
    CGFloat bageH = 20.f;
    self.bageView.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)-bageW*2/3, topPadding*2/3, bageW, bageH);
    [self.bageView wl_setCornerRadius:bageH/2];
}

#pragma mark - Actions
- (void)iconClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:KWL_ZY_HideNotification object:nil];
    if (self.item.selectionHandler) {
        self.item.selectionHandler();
    }
}

#pragma mark - setter
- (void)setItem:(WLActivity *)item {
    _item = item;
    [self.iconView setImage:item.activityImage forState:UIControlStateNormal];
    self.titleView.text = item.activityTitle;
    self.bageView.hidden = !item.showBage;
}

#pragma mark - getter
- (UIButton *)iconView {
    if (!_iconView) {
        _iconView = [[UIButton alloc] init];
        [_iconView addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconView;
}

- (UITextView *)titleView {
    if (!_titleView) {
        _titleView = [[UITextView alloc] init];
        _titleView.textColor = [UIColor darkGrayColor];
        _titleView.font = [UIFont systemFontOfSize:11];
        _titleView.backgroundColor = nil;
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.userInteractionEnabled = NO;
    }
    return _titleView;
}
- (UILabel *)bageView {
    if (!_bageView) {
        _bageView = [[UILabel alloc] init];
        _bageView.textAlignment = NSTextAlignmentCenter;
        _bageView.backgroundColor = UIColor.wl_HexFF9729;
        _bageView.textColor = UIColor.whiteColor;
        _bageView.font = WLFONT(12);
        _bageView.text = @"赚";
    }
    return _bageView;
}

@end
