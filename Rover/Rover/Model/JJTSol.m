//
//  Sol.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTSol.h"

@implementation JJTSol

-(instancetype)initWithDictionary:(NSDictionary *)solDictionary {
    
    self = [super init];
    if (self) {
        _solNumber = [solDictionary[@"sol"] integerValue];
        _solNumberOfPhotos = [solDictionary[@"total_photos"] integerValue];
        _cameras = [solDictionary[@"cameras"] copy];
    }
    return self;
}

@end
