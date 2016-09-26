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

- (instancetype)initWithId:(NSString *)identifier title:(NSString *)title detail:(NSString *)detail url:(NSURL *)url;

@end
