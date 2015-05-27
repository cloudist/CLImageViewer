//
//  CLImageViewer.m
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLImageViewer.h"
#import "CLImageZoomView.h"
#import "SDWebImageManager.h"
#import "UIImageView+Helper.h"
#import "CLPageControl.h"

@interface CLImageViewer() <UIScrollViewDelegate>
@property (strong, nonatomic)UIImageView* popView;
@property (strong, nonatomic)UIView* blackBackdrop;
@property (strong, nonatomic)UIView* blurredSnapshotView;
@property (strong, nonatomic)NSMutableArray* imageViews;
@property (strong, nonatomic)UIScrollView* scrollView;
@property (strong, nonatomic)CLPageControl* pageControl;
@property (strong, nonatomic)NSMutableDictionary* startRects;
@end

@implementation CLImageViewer

#pragma mark - Lifecycle
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _popView = [UIImageView new];
        _startRects = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showImageViewFromOriginPosition {
    _blurredSnapshotView = [self blurredSnapshotFromParentmostViewController:_fromController];
    [self.view addSubview:_blurredSnapshotView];
    
    _blackBackdrop = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -512, -512)];
    _blackBackdrop.backgroundColor = [UIColor blackColor];
    _blackBackdrop.alpha = 0.f;
    [self.view addSubview:_blackBackdrop];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    CGFloat scrollViewHeight = _scrollView.frame.size.height;
    
    _scrollView.contentSize = CGSizeMake([_imageInfo imageCount] * scrollViewWidth, scrollViewHeight);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    _pageControl = [[CLPageControl alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.center = CGPointMake(_scrollView.frame.size.width * 0.5,
                                      _scrollView.frame.size.height - 50);
    [_pageControl setNumberOfPages:[_imageInfo imageCount]];
    _pageControl.currentPage = _imageInfo.startImageIndex;
    [self.view addSubview:_pageControl];
    
    _imageViews = [NSMutableArray new];
    
    if (_imageInfo.needSrollToOrigin) {
        CGRect originRect = [_imageInfo startReferenceRect];
        UIView* originView = _imageInfo.referenceView;
        CGRect referenceFrameInWindow = [originView convertRect:originRect toView:nil];
        CGRect frameInView = [self.view convertRect:referenceFrameInWindow fromView:nil];
        _startRects[[NSString stringWithFormat:@"%lu", (unsigned long)_imageInfo.startImageIndex]] = [NSValue valueWithCGRect:frameInView];
    }
    
    CGFloat offsetX = 0.f;
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < [_imageInfo imageCount]; i++) {
        if (_imageInfo.needSrollToOrigin == NO) {
            CGRect originRect = [_imageInfo referenceRectWithIndex:i];
            UIView* originView = _imageInfo.referenceView;
            CGRect referenceFrameInWindow = [originView convertRect:originRect toView:nil];
            CGRect frameInView = [weakSelf.view convertRect:referenceFrameInWindow fromView:nil];
            _startRects[[NSString stringWithFormat:@"%d", i]] = [NSValue valueWithCGRect:frameInView];
        }
        CLImageZoomView* photoView = [[CLImageZoomView alloc] initWithFrame:CGRectMake(offsetX, 0, scrollViewWidth, scrollViewHeight) andImage:[_imageInfo placeholderImageWithIndex:i]];
        photoView.autoresizingMask = (1 << 6) - 1;
        photoView.onBackToTable = ^ {
            if (weakSelf.imageInfo.needSrollToOrigin) {
                [UIView animateWithDuration:0.5f animations:^{
                    [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.imageInfo.startImageIndex * weakSelf.scrollView.frame.size.width, 0) animated:NO];
                } completion:^(BOOL finished) {
                    weakSelf.pageControl.currentPage = weakSelf.imageInfo.startImageIndex;
                    [weakSelf animationImageToOrigin];
                }];
            } else {
                [weakSelf animationImageToOrigin];
            }
        };
        [_scrollView addSubview:photoView];
        [_imageViews addObject:photoView];
        offsetX += scrollViewWidth;
    }
    
    _popView.image = [_imageInfo startPlaceholderImage];
    [self.view addSubview:_popView];

    CGRect originRect = [_imageInfo startReferenceRect];
    UIView* originView = _imageInfo.referenceView;
    CGRect referenceFrameInWindow = [originView convertRect:originRect toView:nil];
    [_fromController presentViewController:self animated:NO completion:^{
        CGRect frameInView = [weakSelf.view convertRect:referenceFrameInWindow fromView:nil];
        weakSelf.popView.frame = frameInView;
        weakSelf.blackBackdrop.alpha = 0.f;
        [UIView animateWithDuration:0.5f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState |
                                    UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             weakSelf.blackBackdrop.alpha = 0.86f;
                             CGSize fitSize = [weakSelf.popView contentSizeWithParentViewSize:weakSelf.view.bounds.size];
                             weakSelf.popView.frame = CGRectMake(0, (scrollViewHeight - fitSize.height) / 2, fitSize.width, fitSize.height);
                         }
                         completion:^(BOOL finished) {
                             [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.imageInfo.startImageIndex * weakSelf.scrollView.frame.size.width, 0)];
                            
                             NSUInteger page = weakSelf.imageInfo.startImageIndex;
                             [weakSelf.imageViews[page] addSubImageview:weakSelf.popView];
                             [weakSelf loadScrollViewWithPage:page];
                         }];
    }];
}

- (void)animationImageToOrigin {
    CLImageZoomView* zoomView = _imageViews[_pageControl.currentPage];
    CGRect frameInView = [self.view convertRect:zoomView.imageView.frame fromView:zoomView.containerView];
    [zoomView.imageView removeFromSuperview];
    zoomView.imageView.frame = frameInView;
    zoomView.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:zoomView.imageView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        NSValue* rectValue = weakSelf.startRects[[NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.pageControl.currentPage]];
        zoomView.imageView.frame = [rectValue CGRectValue];
        weakSelf.blackBackdrop.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    [self loadScrollViewWithPage:page];
}

- (CGFloat)backgroundBlurRadius {
    return 2.0;
}

- (UIView *)blurredSnapshotFromParentmostViewController:(UIViewController *)viewController {
    
    UIViewController *presentingViewController = viewController.view.window.rootViewController;
    while (presentingViewController.presentedViewController) presentingViewController = presentingViewController.presentedViewController;
    
    // We'll draw the presentingViewController's view into a context
    // that is scaled down by a factor of 4, which will dramatically improve
    // the performance of JTS_applyBlurWithRadius:tintColor:saturationDeltaFactor:maskImage:
    
    CGFloat outerBleed = 20.0f;
    CGFloat performanceDownScalingFactor = 0.25f;
    CGFloat scaledOuterBleed = outerBleed * performanceDownScalingFactor;
    CGRect contextBounds = CGRectInset(presentingViewController.view.bounds, -outerBleed, -outerBleed);
    CGRect scaledBounds = contextBounds;
    scaledBounds.size.width *= performanceDownScalingFactor;
    scaledBounds.size.height *= performanceDownScalingFactor;
    CGRect scaledDrawingArea = presentingViewController.view.bounds;
    scaledDrawingArea.size.width *= performanceDownScalingFactor;
    scaledDrawingArea.size.height *= performanceDownScalingFactor;
    
    UIGraphicsBeginImageContextWithOptions(scaledBounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(scaledOuterBleed, scaledOuterBleed));
    [presentingViewController.view drawViewHierarchyInRect:scaledDrawingArea afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGFloat blurRadius = self.backgroundBlurRadius * performanceDownScalingFactor;
    UIImage *blurredImage = [image applyBlurWithRadius:blurRadius tintColor:nil saturationDeltaFactor:1.0f maskImage:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contextBounds];
    imageView.image = blurredImage;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.backgroundColor = [UIColor blackColor];
    
    return imageView;
}

#pragma mark - Internal Helpers
-(UIImageView*)currentImageView {
    if (_imageInfo.startImageIndex >= _imageViews.count) {
        return nil;
    }
    return _imageViews[_imageInfo.startImageIndex];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= _imageViews.count)
        return;
    if (_imageInfo.imageURLs == nil) {
        [_imageViews[page] updateImage:[_imageInfo placeholderImageWithIndex:page]];
        if (page > 0) {
            [_imageViews[page - 1] updateImage:[_imageInfo placeholderImageWithIndex:page - 1]];
        }
        if (page + 1 < _imageInfo.placeholderImages.count) {
            [_imageViews[page + 1] updateImage:[_imageInfo placeholderImageWithIndex:page + 1]];
        }
        return;
    }
    [_imageViews[page] updateImageWithUrl:[_imageInfo imageURLWithIndex:page] placeholderImage:[_imageInfo placeholderImageWithIndex:page]];
    if (page > 0) {
        [_imageViews[page - 1] updateImageWithUrl:[_imageInfo imageURLWithIndex:page - 1] placeholderImage:[_imageInfo placeholderImageWithIndex:page - 1]];
    }
    if (page + 1 < _imageInfo.imageURLs.count) {
        [_imageViews[page + 1] updateImageWithUrl:[_imageInfo imageURLWithIndex:page + 1] placeholderImage:[_imageInfo placeholderImageWithIndex:page + 1]];
    }
}

@end
