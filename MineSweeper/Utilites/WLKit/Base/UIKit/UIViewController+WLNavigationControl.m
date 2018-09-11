//
//  UIViewController+WLNavigationControl.m
//  Welian
//
//  Created by liuwu on 2016/11/21.
//  Copyright © 2016年 chuansongmen. All rights reserved.
//

#import "UIViewController+WLNavigationControl.h"
#import <objc/runtime.h>

static NSString *kFirstNavigationLeftItemShow = @"FirstNavigationLeftItemShow";
static NSString *const kisUnallowedPop     = @"keyForUnallowedPop";

@implementation UIViewController (WLNavigationControl)

- (void)setFirstNavigationLeftItemShow:(BOOL)firstNavigationLeftItemShow{
    objc_setAssociatedObject(self, &kFirstNavigationLeftItemShow, @(firstNavigationLeftItemShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.firstNavigationLeftItemShow) {
        UIImage *backImage = [[WLDicHQFontImage iconWithName:@"back" fontSize:WLNavImagePtSize color:UIColor.wl_Hex333333] wl_alwaysOriginal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewControl:)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (BOOL)firstNavigationLeftItemShow{
    return [objc_getAssociatedObject(self, &kFirstNavigationLeftItemShow) boolValue];
}

- (void)dismissViewControl:(id)sender{
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - seter and getter
- (void)setUnallowedPop:(BOOL)unallowedPop {
    objc_setAssociatedObject(self, &kisUnallowedPop, @(unallowedPop), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isUnallowedPop{
    return [objc_getAssociatedObject(self, &kisUnallowedPop) boolValue];
}

@end
