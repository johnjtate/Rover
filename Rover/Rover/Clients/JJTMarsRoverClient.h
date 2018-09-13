//
//  JJTMarsRoverClient.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJTRover;
@class JJTPhoto;

@interface JJTMarsRoverClient : NSObject

// fetchAllMarsRoversWithCompletion has a completion block as a parameter that returns an array of rover names, and an error
- (void)fetchAllMarsRoversWithCompletion:(void(^)(NSArray *roverNames, NSError *error))completion;

// fetchMissionManifestForRoverNamed takes in a string and has a completion block that returns an instance of your rover model, and an error
- (void)fetchMissionManifestForRoverNamed:(NSString *)name completion:(void(^)(JJTRover *rover, NSError *error))completion;

// fetchPhotosFromRover that takes in an instance of your rover model, which sol you want photos for, and a completion block that returns an array of photos, and an error
- (void)fetchPhotosFromRover:(JJTRover *)rover onSol:(NSInteger)sol completion:(void(^)(NSArray *photos, NSError *error))completion;

// fetchImageDataForPhoto that takes in an instance of your photo model, and has a completion block that returns imageData ( NSData, not Data )
- (void)fetchImageDataForPhoto:(JJTPhoto *)photo completion:(void(^)(NSData *imageData, NSError *error))completion;

@end
