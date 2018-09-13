//
//  Photo.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTPhoto.h"

@implementation JJTPhoto

-(instancetype)initWithDictionary:(NSDictionary *)photoDictionary {
    
    self = [super init];
    if (self) {
        // check if is a dictionary of IDs
        if (!photoDictionary[@"id"]) { return nil; }
        _photoIdentifier = [photoDictionary[@"id"] integerValue];
        _solPhotoWasTaken = [photoDictionary[@"sol"] integerValue];
        _cameraName = photoDictionary[@"camera"][@"name"];
        _earthDateOfPhoto = photoDictionary[@"earth_date"];
        // convert the URL string into a URL
        _photoURL = [NSURL URLWithString:photoDictionary[@"img_src"]];
        // return nil is there is no image
        if (!_photoURL) { return nil; }
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    // verify object exists and is of class JJTPhoto
    if (!object || ![object isKindOfClass:[JJTPhoto class]]) { return NO; }
    JJTPhoto *photo = object;
    if (photo.photoIdentifier != self.photoIdentifier) { return NO; }
    if (photo.solPhotoWasTaken != self.solPhotoWasTaken) {return NO; }
    if (photo.cameraName != self.cameraName) { return NO; }
    if (photo.earthDateOfPhoto != self.earthDateOfPhoto) { return NO; }
    return YES;
}

@end
