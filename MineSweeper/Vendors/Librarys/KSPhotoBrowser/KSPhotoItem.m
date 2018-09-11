//
//  KSPhotoItem.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoItem.h"

@interface KSPhotoItem ()

@property (nonatomic, strong, readwrite) UIView *sourceView;
@property (nonatomic, strong, readwrite) UIImage *thumbImage;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSURL *imageUrl;

@end

@implementation KSPhotoItem

- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)thumbimage
                             image:(UIImage *)image
                          imageUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = thumbimage;
        _image = image;
        _imageUrl = url;
        if (image) {
            _finished = YES;
        }
    }
    return self;
}

+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)thumbImage
                             image:(UIImage *)image
                          imageUrl:(NSURL *)url
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                        thumbImage:thumbImage
                                             image:image
                                          imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)thumbImage
                             image:(UIImage *)image
                          imageUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:[urlString wl_imageUrlManageScene:WLDownloadImageSceneBig condenseSize:CGSizeZero]];
    return [self itemWithSourceView:view thumbImage:thumbImage image:image imageUrl:url];
}

- (instancetype)initWithImageUrl:(NSURL *)url {
    return [self initWithSourceView:nil thumbImage:nil image:nil imageUrl:url];
}

- (instancetype)initWithSourceView:(UIImageView *)view image:(UIImage *)image {
    return [self initWithSourceView:view thumbImage:nil image:image imageUrl:nil];
}

- (instancetype)initWithSourceView:(UIImageView *)view imageUrl:(NSURL *)url {
    return [self initWithSourceView:view thumbImage:view.image image:nil imageUrl:url];
}

- (instancetype)initWithThumbImage:(UIImage *)thumbimage imageUrl:(NSURL *)url {
    return [self initWithSourceView:nil thumbImage:thumbimage image:nil imageUrl:url];
}

+ (instancetype)itemWithImageUrl:(NSURL *)url {
    return [self itemWithSourceView:nil imageUrl:url];
}

+ (instancetype)itemWithImageUrlString:(NSString *)urlString {
    return [self itemWithSourceView:nil thumbImage:nil image:nil imageUrlString:urlString];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view imageUrl:(NSURL *)url {
    return [self itemWithSourceView:view thumbImage:nil image:nil imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view imageUrlString:(NSString *)urlString {
    return [self itemWithSourceView:view thumbImage:nil image:nil imageUrlString:urlString];
}

+ (instancetype)itemWithThumbImage:(UIImage *)thumbimage imageUrlString:(NSString *)urlString {
    return [self itemWithSourceView:nil thumbImage:thumbimage image:nil imageUrlString:urlString];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view image:(UIImage *)image {
    return [self itemWithSourceView:view thumbImage:nil image:image imageUrlString:nil];
}

@end
