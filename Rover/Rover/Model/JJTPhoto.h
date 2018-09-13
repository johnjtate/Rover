//
//  Photo.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTPhoto : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)photoDictionary;

// photo's identifier
@property (nonatomic, readonly) NSInteger photoIdentifier;
// sol photo was taken
@property (nonatomic, readonly) NSInteger solPhotoWasTaken;
// name of the camera that took the photo
@property (nonatomic, readonly, copy) NSString *cameraName;
// Earth date photo was taken
@property (nonatomic, readonly, copy) NSString *earthDateOfPhoto;
// url to the image
@property (nonatomic, readonly, copy) NSURL *photoURL;

@end
