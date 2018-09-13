//
//  Rover.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTRover.h"
#import "JJTSol.h"

@implementation JJTRover

-(instancetype)initWithDictionary:(NSDictionary *)roverDictionary {
    
    self = [super init];
    if (self) {
        _name = roverDictionary[@"name"];
        if (!_name) { return nil; }
        NSString *launchDate = roverDictionary[@"launch_date"];
        _launchDate = launchDate;
        NSString *landingDate = roverDictionary[@"landing_date"];
        _landingDate = landingDate;
        NSInteger maxSolDate = [roverDictionary[@"max_sol"] integerValue];
        _maxSolDate = maxSolDate;
        NSString *maxEarthDate = roverDictionary[@"max_date"];
        _maxEarthDate = maxEarthDate;
        _status = [roverDictionary[@"status"] isEqualToString:@"active"] ? JJTMarsRoverStatusActive : JJTMarsRoverStatusComplete;
        NSInteger numberOfPhotos = [roverDictionary[@"total_photos"] integerValue];
        _numberOfPhotos = numberOfPhotos;
        
        NSArray *solDescriptionDictionaries = roverDictionary[@"photos"];
        NSMutableArray *solDescriptions =[NSMutableArray array];
        for (NSDictionary *dict in solDescriptionDictionaries) {
            JJTSol *solDescription = [[JJTSol alloc] initWithDictionary:dict];
            if (!solDescription) { continue; }
            [solDescriptions addObject:solDescription];
        }
        _solDescription = [solDescriptions copy];
    }
    return self;
}







@end
