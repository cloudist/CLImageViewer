//
//  CLImageZoomView.m
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLImageZoomView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Helper.h"

@interface CLImageZoomView () <UIScrollViewDelegate>

@property (nonatomic) BOOL rotating;
@property (nonatomic) CGSize minSize;

@end

@implementation CLImageZoomView


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.bounces = YES;

        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        _containerView = containerView;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [containerView addSubview:imageView];
        _imageView = imageView;
        _imageView.alpha = 0.f;
        
        CGSize imageSize = imageView.contentSize;
        self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
        
        self.contentSize = imageSize;
        self.minSize = imageSize;
        
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.center = _containerView.center;
        _spinner.color = [UIColor colorWithRed:1.0 green:0.50 blue:0.82 alpha:1.0];
        [self addSubview:_spinner];
        [_spinner startAnimating];
        _spinner.alpha = 0.f;
        
        [self setMaxMinZoomScale];
        
        [self centerContent];
        
        [self setupGestureRecognizer];
        [self setupRotationNotification];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = self.containerView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image fitSizeWithViewSize:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) {
            self.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *singleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    singleGestureRecognizer.numberOfTapsRequired = 1;
    [singleGestureRecognizer requireGestureRecognizerToFail:tapGestureRecognizer];
    [_containerView addGestureRecognizer:singleGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.numberOfTapsRequired == 1) {
        if (self.onBackToTable) {
            self.onBackToTable();
        }
    } else if(recognizer.numberOfTapsRequired == 2) {
        if (self.zoomScale > self.minimumZoomScale) {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        } else if (self.zoomScale < self.maximumZoomScale) {
            CGPoint location = [recognizer locationInView:recognizer.view];
            CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
            zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
            [self zoomToRect:zoomToRect animated:YES];
        }
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - Helper

- (void)updateImage:(UIImage*)image {
    _imageView.alpha = 1.f;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    _imageView.image = image;
    [self addSubImageview:_imageView];
}

- (void)updateImageWithUrl:(NSURL*)imagUrl placeholderImage:(UIImage*)image {
    _imageView.alpha = 1.f;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    UIImage* cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imagUrl absoluteString]];
    if (cacheImage == nil) {
        _spinner.alpha = 1.f;
        __weak typeof(self) weakSelf = self;
        [_imageView sd_setImageWithURL:imagUrl
                      placeholderImage:image
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 weakSelf.spinner.alpha = 0.f;
                                 if (weakSelf.zoomScale <= weakSelf.minimumZoomScale) {
                                     [weakSelf addSubImageview:_imageView];
                                 }
                                 
                             }];
    } else {
        _imageView.image = cacheImage;
        [self addSubImageview:_imageView];
    }
}


- (void)addSubImageview:(UIImageView *)imageView {
    [_imageView removeFromSuperview];
    _imageView = nil;
    CGRect containerRect = self.bounds;
    imageView.frame = containerRect;
    [_containerView addSubview:imageView];
    _imageView = imageView;
    
    CGSize imageSize = imageView.contentSize;
    self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    
    self.contentSize = imageSize;
    self.minSize = imageSize;
    
    [self setMaxMinZoomScale];
    
    [self centerContent];
}

- (void)setMaxMinZoomScale
{
    self.maximumZoomScale = 4.f;
    self.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

@end
