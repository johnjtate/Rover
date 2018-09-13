//
//  Rover.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JJTMarsRoverStatus) {
    JJTMarsRoverStatusActive,
    JJTMarsRoverStatusComplete,
};

@interface JJTRover : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)roverDictionary;

// name of the rover
@property (nonatomic, readonly, copy) NSString *name;
// launch date
@property (nonatomic, readonly, copy) NSString *launchDate;
// landing date
@property (nonatomic, readonly, copy) NSString *landingDate;
// max sol that represents the most recent sol for which photos exist from the rover
@property (nonatomic, readonly) NSInteger maxSolDate;
// max date (on Earth) for which photos exist from the rover
@property (nonatomic, readonly, copy) NSString *maxEarthDate;
// status of the rover
@property (nonatomic, readonly) JJTMarsRoverStatus status;
// number of photos taken by the rover
@property (nonatomic, readonly) NSInteger numberOfPhotos;
// array of sol descriptions
@property (nonatomic, readonly) NSArray *solDescription;

@end
