//
//  UIImage+WLAdd.h
//  Welian_Normal_Demo
//
//  Created by weLian on 16/6/8.
//  Copyright © 2016年 杭州传送门网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 NS_ASSUME_NONNULL_BEGIN  NS_ASSUME_NONNULL_END
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull，因此我们只需要去指定那些nullable的指针。
 */
NS_ASSUME_NONNULL_BEGIN

/*
 UIImage的扩展类
 */
@interface UIImage (WLAdd)


/**
 *  @author dong, 16-03-30 12:03:15
 *
 *  @brief 生成二维码图片
 *
 *  @param qrString QR sring
 *  @param squareWidth  正方形边长
 *
 *  @return 返回QR image
 */
+ (UIImage *)wl_createQRImageFormString:(NSString *)qrString sizeSquareWidth:(CGFloat)squareWidth;

// 获取正向的图片
- (UIImage *)fixOrientation;

// 这里是利用了UIImage中的drawInRect方法，它会将图像绘制到画布上，并且已经考虑好了图像的方向
- (UIImage *)normalizedImage;

#pragma mark - 图片拉伸
// 返回能够自由拉伸不变形的图片
+ (UIImage*)wl_resizedImage:(NSString *)name;

+ (UIImage *)wl_resizedImage:(NSString *)name
                   leftScale:(CGFloat)leftScale
                    topScale:(CGFloat)topScale;
// 生成一个磨砂透明图片
+ (UIImage *)wl_blurredSnapshot:(UIView*)view;

- (UIImage *)wl_applyLightEffect;
- (UIImage *)wl_applyExtraLightEffect;
- (UIImage *)wl_applyDarkEffect;
- (UIImage *)wl_applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)wl_applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(nullable UIImage *)maskImage;

// 压缩图片裁剪
- (UIImage *)wl_scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize;


#pragma mark - Create image

///=============================================================================
/// @name 创建图片
///=============================================================================

/**
*  @author dong, 16-09-14 10:09:42
*
*  @brief 以图片名加载图片 并以图片原色为准不会根据系统色改变
*
*  @param name 图片名
*/
+ (nullable UIImage *)wl_imageNameAlwaysOriginal:(NSString *)name;

- (nullable UIImage*)wl_alwaysOriginal;

/**
 通过GIF数据创建一个动画的图片。创建后，你可以访问图像通过属性".images"。
 如果数据不是GIF动画，这个方法和[UIImage imageWithData:data scale:scale]是一样的;

 @讨论   它有一个更好的显示性能，但花费更多的内存(宽度*高度*帧字节)。
 它只适合于显示小的GIF动画表情等。如果你想显示大图片，查看"WLImage"。

 @param data     GIF 数据.
 @param scale    The scale factor
 @return 从GIF中创建一个新的图片, or nil when an error occurs.
*/
+ (nullable UIImage *)wl_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

/**
 数据是否是GIF动画
 */
+ (BOOL)wl_isAnimatedGIFData:(NSData *)data;

/**
 指定路径的文件是否是GIF.
 */
+ (BOOL)wl_isAnimatedGIFFile:(NSString *)path;

/**
 从PDF文件数据或路径创建一个图片
 @讨论 如果PDF多页，只是返回第一页的内容。图像的比列等于当前屏幕的比例，大小和PDF的源尺寸大小相同.
 @param dataOrPath PDF数据`NSData`, 或PDF文件路径`NSString`.
 */
+ (nullable UIImage *)wl_imageWithPDF:(id)dataOrPath;

/**
 从PDF文件数据或路径创建一个图片
 @讨论 如果PDF多页，只是返回第一页的内容。图像的比列等于当前屏幕的比例，大小和PDF的源尺寸大小相同.
 */
+ (nullable UIImage *)wl_imageWithPDF:(id)dataOrPath size:(CGSize)size;

/**
 从苹果的emoji表情创建一个方的图片
 
 @讨论 它从苹果的emoji表情创建一个方形的图片，图像的比例和当前屏幕的比例相同。
     原来的表情图像在`AppleColorEmoji`字体是在160*160像素大小.
 
 @param emoji 单个表情符号, 如 @"😄".
 @param size  图片的大小.
 @return 表情图片, or nil when an error occurs.
 */
+ (nullable UIImage *)wl_imageWithEmoji:(NSString *)emoji size:(CGFloat)size;

/**
 用给定的颜色创建并返回一个1*1大小的图像
 @param color  颜色.
 */
+ (nullable UIImage *)wl_imageWithColor:(UIColor *)color;

/**
 用指定的颜色和大小创建一个纯彩色图像。
 
 @param color  颜色.
 @param size   新图片的大小.
 */
+ (nullable UIImage *)wl_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 用自定义绘制代码创建并返回一个图像。
 
 @param size      图像大小.
 @param drawBlock 绘制块.
 @return 新的图像.
 */
+ (nullable UIImage *)wl_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;


#pragma mark - Image Info
///=============================================================================
/// @name 图片信息
///=============================================================================

/**
 返回该图片是否有透明度通道
 */
- (BOOL)wl_hasAlphaChannel;


#pragma mark - Modify Image
///=============================================================================
/// @name 修改图片
///=============================================================================
/**
 在指定的矩形区域内绘制图像，用contentMode改变内容。
 
 @讨论 该方法在当前的图像上下文中绘制图像，遵守图像的方向设置。
 在默认坐标系中,图像在指定的矩形区域的位置。该方法适用于当前图形的任何变换。
 
 @param rect        绘制图像的区域.
 @param contentMode 绘制模式
 @param clips       一个BOOL值用来确定内容局限在矩形区域。
 */
- (void)wl_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;

/**
 从这个图像的缩放返回一个新的图像。图像根据需要将被拉伸。
 @param size  要缩放的新的尺寸，值必须为正值.
 @return      给定大小的新图像.
 */
- (nullable UIImage *)wl_imageByResizeToSize:(CGSize)size;

/**
 返回一个从这个图像缩放的新的图像。图像内容将通过contentMode改变。
 
 @param size        要缩放的新尺寸，应为正.
 @param contentMode 图像内容模式.
 @return 给定大小的新图像.
 */
- (nullable UIImage *)wl_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 返回一个从这个图像截取的新的图像
 
 @param rect  图像内部区域.
 @return      新的图像, or nil if an error occurs.
 */
- (nullable UIImage *)wl_imageByCropToRect:(CGRect)rect;

/**
 返回一个从图像边缘插图的新图像
 
 @param insets  每一个边缘的插图(正), 值可以是“负”开始.
 @param color   边的填充颜色, nil means clear color.
 @return        新的图像, or nil if an error occurs.
 */
- (nullable UIImage *)wl_imageByInsetEdge:(UIEdgeInsets)insets withColor:(nullable UIColor *)color;

/**
 用给定的圆角大小圈一个新的图片
 @param radius 每个角点的半径.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius;

/**
 用给定的圆角大小圈一个新的图片
 
 @param radius       每个角点的半径.
 @param borderWidth  边框线宽度.
 @param borderColor  边框的笔画颜色. nil指clear color.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;

/**
 用给定的圆角大小圈一个新的图片
 
 @param radius       每个角点的半径.
 @param corners      你想圆角的值的标识。你可以用这个参数来设置圆角的子集。
 @param borderWidth  边框线宽度.
 @param borderColor  边框的笔画颜色. nil指clear color.
 @param borderLineJoin 边界线.
 */
- (nullable UIImage *)wl_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;

/**
 返回一个旋转后的新图像（相对于中心）
 
 @param radians   逆时针旋转的弧度.⟲
 @param fitSize   YES: 新的图像的大小,用来适应所有内容. NO:图像的大小不改变，内容可能被裁剪。
 */
- (nullable UIImage *)wl_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 返回一个逆时针旋转（90°）的新图像. ⤺
 宽度和高度将被交换。
 */
- (nullable UIImage *)wl_imageByRotateLeft90;

/**
 返回一个顺时针旋转1/4转(90°)的新图像. ⤼
 宽度和高度将被交换。
 */
- (nullable UIImage *)wl_imageByRotateRight90;

/**
 返回一个旋转180°的新图像. ↻
 */
- (nullable UIImage *)wl_imageByRotate180;

/**
 返回一个垂直翻转的图像. ⥯
 */
- (nullable UIImage *)wl_imageByFlipVertical;

/**
 返回一个水平翻转的图像. ⇋
 */
- (nullable UIImage *)wl_imageByFlipHorizontal;


#pragma mark - Image Effect
///=============================================================================
/// @name 图像效果
///=============================================================================
/**
 给定颜色渲染图片的alpha通道
 */
- (nullable UIImage *)wl_imageByTintColor:(UIColor *)color;

/**
 返回一个灰色缩放的图像
 */
- (nullable UIImage *)wl_imageByGrayscale;

/**
 给该图像应用模糊效果。适用于模糊任何内容。
 */
- (nullable UIImage *)wl_imageByBlurSoft;

/**
 对这个图像进行模糊效果。适用于模糊任何内容，除了纯白色。（同IOS控制面板）
 */
- (nullable UIImage *)wl_imageByBlurLight;

/**
 对这个图像应用模糊效果。适用于显示黑色文本。（同IOS导航条白色）
 */
- (nullable UIImage *)wl_imageByBlurExtraLight;

/**
 对这个图像应用模糊效果。适用于显示白色文本。（同ios的通知中心）
 */
- (nullable UIImage *)wl_imageByBlurDark;

/**
 对这个图像应用模糊和颜色效果。
 */
- (nullable UIImage *)wl_imageByBlurWithTint:(UIColor *)tintColor;

/**
 对这个图像应用模糊，色彩和饱和度调整颜色，可选的指定区域内通过maskImage.
 
 @param blurRadius     模糊点的半径，0意味着没有模糊效果.
 @param tintColor      一个可选的UIColor对象是混合模糊和饱和操作的结构。
                        这个颜色的aplha通道决定了该颜色的强色彩。nil指没有色彩。
 @param tintBlendMode  一个tintColo混合模式。默认是kCGBlendModeNormal (0).
 @param saturation     一个1的值在产生的图像中没有变化。值小于1会减得到的图像而大于1的值会产生相反的效果。0指灰色规模。
 @param maskImage      如果指定，inputImage是一个定义的可以修改的区域。这必须是一个图像遮盖或必须满足CGContextClipToMask的遮盖
 @return               图像效果, or nil if an error occurs (如. 没有足够的内存).
 */
- (nullable UIImage *)wl_imageByBlurRadius:(CGFloat)blurRadius
                                 tintColor:(nullable UIColor *)tintColor
                                  tintMode:(CGBlendMode)tintBlendMode
                                saturation:(CGFloat)saturation
                                 maskImage:(nullable UIImage *)maskImage;



+ (UIImage *)imageNamedForAdaptation:(NSString *)imageName;

+ (UIImage *)imageWithText:(NSString *)text;

- (NSString *)decodeQRImage;
//水平方向合并图片
+ (UIImage *)wl_horiCombineImages: (NSArray<UIImage *> *)images distance: (CGFloat)distance;
//画圆角图片
- (UIImage *)wl_drawRectWithRoundedCorner: (CGFloat)radius;

@end

NS_ASSUME_NONNULL_END

