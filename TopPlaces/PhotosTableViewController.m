//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoInfo.h"
#import "PhotoScrollViewController.h"

NSString * const UNKNOWN = @"Unknown";

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController
@synthesize photoInfos = _photoInfos;

- (IBAction)refreshData:(UIRefreshControl *)sender {
    [self fetchPhotoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotoData];
}

- (NSArray *)photoInfos {
    if (!_photoInfos) _photoInfos = [[NSArray alloc] init];
    return _photoInfos;
}

- (void)setPhotoInfos:(NSArray *)photoInfos {
    _photoInfos = photoInfos;
    [self.tableView reloadData];
    [self.spinner endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell" forIndexPath:indexPath];
    PhotoInfo *photoInfo = self.photoInfos[indexPath.row];
    
    if ([photoInfo.detail length] == 0) {
        cell.detailTextLabel.text = @"";
    } else {
        cell.detailTextLabel.text = photoInfo.detail;
    }
    
    if([photoInfo.title length] == 0) {
        if ([cell.detailTextLabel.text length] == 0) {
            cell.textLabel.text = UNKNOWN;
        } else {
            cell.textLabel.text = cell.detailTextLabel.text;
            cell.detailTextLabel.text = @"";
        }
    } else {
        cell.textLabel.text = photoInfo.title;
    }
    return cell;
}

- (void)fetchPhotoData {
    // abstract
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath && [segue.identifier isEqualToString:@"showPhoto"] && [segue.destinationViewController isKindOfClass:[PhotoScrollViewController class]]) {
        PhotoScrollViewController *psvc = segue.destinationViewController;
        psvc.title = ((UITableViewCell *)sender).textLabel.text;
        psvc.photoUrl = ((PhotoInfo *)self.photoInfos[indexPath.row]).url;
    }
}

@end
