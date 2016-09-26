//
//  Place.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/24/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "Place.h"

#define DELIMINATOR @", "

@implementation Place

-(instancetype)initWithIdentifier:(NSString *)identifier placeString:(NSString *)string {
    self = [super init];
    if (self) {
        _identifier = identifier;
        
        NSArray *placeParts = [string componentsSeparatedByString:DELIMINATOR];
        if (!placeParts || placeParts.count < 2) {
            return nil;
        }

        _name = placeParts.firstObject;
        _country = placeParts.lastObject;
        
        if (placeParts.count > 2) {
            NSRange rest = NSMakeRange(1, placeParts.count - 2);
            _detail = [[placeParts subarrayWithRange:rest] componentsJoinedByString:DELIMINATOR];
        } else {
            _detail = @"";
        }
    }
    return self;
}

-(NSComparisonResult)compare:(Place *)otherPlace {
    return [self.name compare:otherPlace.name];
}

@end
