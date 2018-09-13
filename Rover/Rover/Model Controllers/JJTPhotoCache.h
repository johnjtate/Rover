//
//  JJTPhotoCache.h
//  Rover
//
//  Created by John Tate on 9/13/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTPhotoCache : NSObject

@property (nonatomic, readonly, class) JJTPhotoCache *sharedCache;

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier;
- (NSData *)imageDataForIdentifier:(NSInteger)identifier;

@end
