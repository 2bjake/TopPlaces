//
//  Place.h
//  TopPlaces
//
//  Created by Foster, Jake on 9/24/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *detail;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *identifier;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithIdentifier:(NSString *)identifier placeString:(NSString *)string NS_DESIGNATED_INITIALIZER;
-(NSComparisonResult)compare:(Place *)otherPlace;
@end
