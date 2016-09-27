//
//  PhotoInfo.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PhotoInfo.h"
#import "FlickrFetcher.h"

@implementation PhotoInfo

- (instancetype)initWithFlickrDictionary:(NSDictionary *)flickrDict {
    
    self = [super init];
    if (self) {
        _flickrDictionary = flickrDict;
        
        _identifier = [flickrDict valueForKeyPath:FLICKR_PHOTO_ID];
        if ([_identifier length] == 0) {
            return nil;
        }
        
        _title = [flickrDict valueForKeyPath:FLICKR_PHOTO_TITLE];
        if (!_title) {
            _title = @"";
        }
        
        _detail = [flickrDict valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        if (!_detail) {
            _detail = @"";
        }
        
        _url = [FlickrFetcher URLforPhoto:flickrDict format:FlickrPhotoFormatLarge];
    }
    return self;

    
}

@end
