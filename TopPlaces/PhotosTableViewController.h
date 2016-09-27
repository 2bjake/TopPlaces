//
//  PhotosTableViewController.h
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECENTS_KEY @"Recents"

@interface PhotosTableViewController : UITableViewController
@property (nonatomic) NSArray *photoInfos;
@property (strong, nonatomic) IBOutlet UIRefreshControl *spinner;

- (void)fetchPhotoData; //abstract
+ (NSArray*) photoInfosFromFlickrPhotoArray:(NSArray *)photos;
@end
