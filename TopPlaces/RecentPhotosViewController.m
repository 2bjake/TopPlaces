//
//  RecentPhotosViewController.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/27/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "RecentPhotosViewController.h"

@interface RecentPhotosViewController ()

@end

@implementation RecentPhotosViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchPhotoData];
}

- (void)fetchPhotoData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotos = [defaults objectForKey:RECENTS_KEY];
    if (!recentPhotos) {
        recentPhotos = [[NSArray alloc] init];
    }
    self.photoInfos = [PhotosTableViewController photoInfosFromFlickrPhotoArray:recentPhotos];
}

@end
