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
#import "FlickrFetcher.h"

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
        PhotoInfo *photoInfo = (PhotoInfo *)self.photoInfos[indexPath.row];
        psvc.photoUrl = photoInfo.url;
        [PhotosTableViewController addToRecentsPhotoInfo:photoInfo];
    }
}

+ (void) addToRecentsPhotoInfo:(PhotoInfo *)photoInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotos = [defaults objectForKey:RECENTS_KEY];
    if (!recentPhotos) {
        recentPhotos = [[NSArray alloc] init];
    }
    [defaults setObject:[recentPhotos arrayByAddingObject:photoInfo.flickrDictionary] forKey:RECENTS_KEY];
    [defaults synchronize];
}

+ (NSArray*) photoInfosFromFlickrPhotoArray:(NSArray *)photos {
    NSMutableArray *newPhotoInfos = [[NSMutableArray alloc] init];
    
    for (NSDictionary * photoDict in photos) {
        PhotoInfo *info = [[PhotoInfo alloc] initWithFlickrDictionary:photoDict];
        if (info) {
            [newPhotoInfos addObject:info];
        }
    }
    return newPhotoInfos;
}

@end