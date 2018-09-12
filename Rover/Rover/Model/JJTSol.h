//
//  Sol.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTSol: NSObject

// which sol it is
@property (nonatomic, readonly) NSInteger solNumber;
// number of photos taken during the sol
@property (nonatomic, readonly) NSInteger solNumberOfPhotos;
// array of cameras as strings
@property (nonatomic, readonly, copy) NSArray<NSString *> *cameras;

@end
