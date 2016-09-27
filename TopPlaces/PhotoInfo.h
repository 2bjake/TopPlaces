//
//  PhotoInfo.h
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *detail;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSDictionary *flickrDictionary; // to save in NSUserDefaults (should actually make PhotoInfo serializable...)

- (instancetype)initWithFlickrDictionary:(NSDictionary *)dictionary;

@end
