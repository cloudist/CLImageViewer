//
//  CLExample2TableViewController.m
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLExample2TableViewController.h"
#import "CLExample2Cell.h"
#import "CLImageViewer.h"
@interface CLExample2TableViewController ()
@property (nonatomic, strong)NSMutableArray* imageDataSource;
@property (nonatomic, strong)NSArray* imageViews;
@end

@implementation CLExample2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _imageDataSource = [NSMutableArray new];
    for (NSUInteger i = 0; i < 10; ++i) {
        NSArray* array = @[[UIImage imageNamed:[NSString stringWithFormat:@"%u", 1]],
                           [UIImage imageNamed:[NSString stringWithFormat:@"%u", 2]],
                           [UIImage imageNamed:[NSString stringWithFormat:@"%u", 3]],
                           [UIImage imageNamed:[NSString stringWithFormat:@"%u", 4]],
                           [UIImage imageNamed:[NSString stringWithFormat:@"%u", 5]],
                           [UIImage imageNamed:[NSString stringWithFormat:@"%u", 6]]];
        [_imageDataSource addObject:array];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _imageDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLExample2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"example2Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    for (NSUInteger i = 0; i < cell.imageViews.count; ++i) {
        NSArray* imageArray = _imageDataSource[[indexPath row]];
        UIImageView* view = cell.imageViews[i];
        view.image = imageArray[i];
    }
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    cell.onClickImage = ^(NSUInteger index) {
        NSMutableArray* placeHoldeImages = [NSMutableArray new];
        NSMutableArray* referenceRects = [NSMutableArray new];
        
        for (NSUInteger i = 0; i < 6; ++i) {
            NSArray* imageArray = _imageDataSource[[indexPath row]];
            UIImage* image = imageArray[i];
            [placeHoldeImages addObject:image];
            UIImageView* view = weakCell.imageViews[i];
            [referenceRects addObject:[NSValue valueWithCGRect:view.frame]];
        }
        CLImageViewer* imagesViewer = [CLImageViewer new];
        CLImageInfo* imagesInfo = [CLImageInfo new];
        imagesInfo.placeholderImages = placeHoldeImages;
        imagesInfo.referenceView = weakCell;
        imagesInfo.referenceRects = referenceRects;
        imagesInfo.startImageIndex = index;
        imagesViewer.imageInfo = imagesInfo;
        imagesViewer.fromController = weakSelf;
        [imagesViewer showImageViewFromOriginPosition];
    };
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
