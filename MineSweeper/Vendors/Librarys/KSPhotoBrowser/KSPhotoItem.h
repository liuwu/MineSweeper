//
//  KSPhotoItem.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPhotoItem : NSObject

@property (nonatomic, strong, readonly, nullable) UIView *sourceView;
@property (nonatomic, strong, readonly, nullable) UIImage *thumbImage;
@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, strong, readonly, nullable) NSURL *imageUrl;
@property (nonatomic, assign) BOOL finished;

- (instancetype _Nonnull)initWithSourceView:(UIView *_Nullable)view
                                   thumbImage:(UIImage *_Nullable)thumbimage
                                        image:(UIImage *_Nullable)image
                                     imageUrl:(NSURL *_Nullable)url;

+ (instancetype _Nonnull)itemWithSourceView:(UIView *_Nullable)view
                        thumbImage:(UIImage *_Nullable)thumbImage
                             image:(UIImage *_Nullable)image
                          imageUrl:(NSURL *_Nullable)url;

+ (instancetype _Nonnull)itemWithSourceView:(UIView *_Nullable)view
                                  thumbImage:(UIImage *_Nullable)thumbImage
                             image:(UIImage *_Nullable)image
                    imageUrlString:(NSString *_Nullable)urlString;

- (instancetype _Nonnull)initWithImageUrl:(NSURL *_Nullable)url;
- (instancetype _Nonnull)initWithSourceView:(UIImageView *_Nullable)view image:(UIImage *_Nullable)image;

- (instancetype _Nonnull)initWithSourceView:(UIImageView *_Nullable)view imageUrl:(NSURL *_Nullable)url;

- (instancetype _Nonnull)initWithThumbImage:(UIImage *_Nullable)thumbimage imageUrl:(NSURL *_Nullable)url;

+ (instancetype _Nonnull)itemWithImageUrl:(NSURL *_Nullable)url;
+ (instancetype _Nonnull)itemWithImageUrlString:(NSString *_Nullable)urlString;

+ (instancetype _Nonnull)itemWithSourceView:(UIImageView *_Nullable)view imageUrl:(NSURL *_Nullable)url;

+ (instancetype _Nonnull)itemWithSourceView:(UIImageView *_Nullable)view imageUrlString:(NSString *_Nullable)urlString;

+ (instancetype _Nonnull)itemWithThumbImage:(UIImage *_Nullable)thumbimage imageUrlString:(NSString *_Nullable)urlString;

+ (instancetype _Nonnull)itemWithSourceView:(UIImageView *_Nullable)view image:(UIImage *_Nullable)image;

@end
