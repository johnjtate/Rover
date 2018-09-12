//
//  Photo.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTPhoto.h"

@implementation JJTPhoto







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
