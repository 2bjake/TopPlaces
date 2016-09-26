//
//  PlacePhotosViewController.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PlacePhotosViewController.h"
#import "FlickrFetcher.h"
#import "PhotoInfo.h"

#define MAX_RESULTS 50

@interface PlacePhotosViewController ()
@end

@implementation PlacePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.place.name;
}

- (void)fetchPhotoData {
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.place.identifier maxResults:MAX_RESULTS];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task =
    [session downloadTaskWithRequest:request
                   completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       if (!error) {
                           NSArray *newPhotoInfos = [PlacePhotosViewController photoInfosFromFlickrData:[NSData dataWithContentsOfURL:localFile]];

                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self setPhotoInfos:newPhotoInfos];
                           });
                       }
                   }];
    [task resume];
}

+ (NSArray*) photoInfosFromFlickrData:(NSData *)data {
    NSMutableArray *newPhotoInfos = [[NSMutableArray alloc] init];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error: NULL];
    NSArray *photos = [dict valueForKeyPath:FLICKR_RESULTS_PHOTOS];

    for (NSDictionary * photoDict in photos) {
        NSString *identifier = [photoDict valueForKeyPath:FLICKR_PHOTO_ID];
        NSString *title = [photoDict valueForKeyPath:FLICKR_PHOTO_TITLE];
        NSString *detail = [photoDict valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        NSURL *url = [FlickrFetcher URLforPhoto:photoDict format:FlickrPhotoFormatLarge];
        PhotoInfo *info = [[PhotoInfo alloc] initWithId:identifier title:title detail:detail url:url];
        if (info) {
            [newPhotoInfos addObject:info];
        }
    }
    return newPhotoInfos;
}

@end
