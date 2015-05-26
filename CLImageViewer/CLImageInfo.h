//
//  CLImageInfo.h
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLImageInfo : NSObject

@property (strong, nonatomic) NSMutableArray*  placeholderImages;
@property (strong, nonatomic) NSMutableArray*  imageURLs;
@property (strong, nonatomic) NSMutableArray* referenceRects;
@property (strong, nonatomic) UIView *referenceView;
@property (assign, nonatomic) NSUInteger startImageIndex;
@property (assign, nonatomic) BOOL needSrollToOrigin;

- (CGRect)startReferenceRect;
- (NSURL*)startImageURL;
- (UIImage*)startPlaceholderImage;

- (CGRect)referenceRectWithIndex:(NSUInteger)index;
- (NSURL*)imageURLWithIndex:(NSUInteger)index;
- (UIImage*)placeholderImageWithIndex:(NSUInteger)index;

- (NSUInteger)imageCount;

@end
