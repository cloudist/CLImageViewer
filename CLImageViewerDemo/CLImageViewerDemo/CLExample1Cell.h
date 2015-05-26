//
//  CLExample1Cell.h
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLExample1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView0;

@property (nonatomic, copy)void (^onClickImage)(void);

@end
