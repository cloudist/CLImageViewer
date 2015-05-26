//
//  CLImageInfo.m
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLImageInfo.h"

@implementation CLImageInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _needSrollToOrigin = NO;
        _imageURLs = nil;
    }
    return self;
}

- (CGRect)startReferenceRect {
    if (_needSrollToOrigin) {
        return [_referenceRects[0] CGRectValue];
    }
    if (_startImageIndex >= _referenceRects.count) {
        return CGRectNull;
    }
    return [_referenceRects[_startImageIndex] CGRectValue];
}

- (NSURL*)startImageURL {
    if (_startImageIndex >= _imageURLs.count) {
        return nil;
    }
    return _imageURLs[_startImageIndex];
}

- (UIImage*)startPlaceholderImage {
    if (_startImageIndex >= _placeholderImages.count) {
        return nil;
    }
    return _placeholderImages[_startImageIndex];
}

- (CGRect)referenceRectWithIndex:(NSUInteger)index {
    if (index >= _referenceRects.count) {
        return CGRectNull;
    }
    return [_referenceRects[index] CGRectValue];
}

- (NSURL*)imageURLWithIndex:(NSUInteger)index {
    if (index >= _imageURLs.count) {
        return nil;
    }
    return _imageURLs[index];
}

- (UIImage*)placeholderImageWithIndex:(NSUInteger)index {
    if (index >= _placeholderImages.count) {
        return nil;
    }
    return _placeholderImages[index];
}

- (NSUInteger)imageCount {
    NSUInteger count = _placeholderImages.count;
    if (!_needSrollToOrigin && _referenceRects.count != count) {
        @throw [NSException exceptionWithName:@"count" reason:@"image count is contradictory" userInfo:nil];
        return 0;
    }
    if (_imageURLs && _imageURLs.count != count) {
        @throw [NSException exceptionWithName:@"count" reason:@"image count is contradictory" userInfo:nil];
        return 0;
    }
    return count;
}

@end
