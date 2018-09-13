//
//  JJTPhotoCache.m
//  Rover
//
//  Created by John Tate on 9/13/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTPhotoCache.h"

@interface JJTPhotoCache()

@property (nonatomic) NSCache *cache;

@end

@implementation JJTPhotoCache

// shared instance of the photo cache
+ (instancetype)sharedCache {
    
    static JJTPhotoCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.name = @"DevMountain.MarsRover.PhotoCache";
    }
    return self;
}

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier {
    
    [self.cache setObject:data forKey:@(identifier) cost:[data length]];
}

- (NSData *)imageDataForIdentifier:(NSInteger)identifier {
    
    return [self.cache objectForKey:@(identifier)];
}

@end
