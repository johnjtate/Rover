//
//  JJTSolsTableViewController.h
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import <UIKit/UIKit.h>
// needs to have rover class for landing pad variable
@class JJTRover;

@interface JJTSolsTableViewController : UITableViewController

// landing pad variable for the segue
@property (nonatomic) JJTRover *rover;

@end
