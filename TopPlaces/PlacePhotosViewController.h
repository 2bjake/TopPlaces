//
//  PlacePhotosViewController.h
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "Place.h"

@interface PlacePhotosViewController : PhotosTableViewController
@property (nonatomic) Place *place;
@end
