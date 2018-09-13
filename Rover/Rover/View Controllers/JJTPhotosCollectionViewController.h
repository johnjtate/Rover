//
//  JJTPhotosCollectionViewController.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJTRover;
@class JJTSol;

@interface JJTPhotosCollectionViewController : UICollectionViewController

@property (nonatomic) JJTRover *rover;
@property (nonatomic) JJTSol *sol;

@end
