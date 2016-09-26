//
//  PhotoInfo.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

- (instancetype)initWithId:(NSString *)identifier title:(NSString *)title detail:(NSString *)detail url:(NSURL *)url {
    if ([identifier length] == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _identifier = identifier;
        _title = (title != nil) ? title : @"";
        _detail = (detail != nil) ? detail : @"";
        _url = url;
    }
    return self;
}

@end
