//
//  CLImageZoomView.h
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CLImageZoomView : UIScrollView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;

@property (nonatomic, copy) void (^onBackToTable)(void);

- (void)updateImage:(UIImage*)image;
- (void)updateImageWithUrl:(NSURL*)imagUrl placeholderImage:(UIImage*)image;
- (void)addSubImageview:(UIImageView *)imageView;
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
