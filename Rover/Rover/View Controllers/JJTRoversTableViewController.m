//
//  JJTRoversTableViewController.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTRoversTableViewController.h"
// needed to create rover objects
#import "JJTRover.h"
// needed for the API fetch tasks
#import "JJTMarsRoverClient.h"
// needed to prepare for segue
#import "JJTSolsTableViewController.h"

@interface JJTRoversTableViewController ()

// array of rovers--data source for the table view
@property (nonatomic, copy) NSArray *rovers;

@end

@implementation JJTRoversTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // start with an empty array for the rovers to be returned from the fetch
    NSMutableArray *rovers  = [NSMutableArray array];
    // create a dispatch group
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    // enter the dispatch group
    dispatch_group_enter(dispatchGroup);
    JJTMarsRoverClient *roverClient = [[JJTMarsRoverClient alloc] init];
    [roverClient fetchAllMarsRoversWithCompletion:^(NSArray *roverNames, NSError *error) {
        
        if (error) {
            NSLog(@"Error fetching list of rovers: %@", error);
            return;
        }
        
        dispatch_queue_t resultsQueue = dispatch_queue_create("roverResultsQueue", 0);
        
        for (NSString *name in roverNames) {
            dispatch_group_enter(dispatchGroup);
            [roverClient fetchMissionManifestForRoverNamed:name completion:^(JJTRover *rover, NSError *error) {
                
                if (error) {
                    NSLog(@"Error fetching list of rovers: %@", error);
                    dispatch_group_leave(dispatchGroup);
                    return;
                }
                
                // if successful, add rover to array
                dispatch_async(resultsQueue, ^{
                    [rovers addObject:rover];
                    dispatch_group_leave(dispatchGroup);
                });
            }];
        }
        // leave the dispatch group once all of the rover manifests have been fetched
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    // set the class-level data source equal to the array of fetched rovers
    self.rovers = rovers;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rovers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoverCell" forIndexPath:indexPath];
    
    // cell only displays the name of the rover
    cell.textLabel.text = [self.rovers[indexPath.row] name];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSolsView"]) {
        
        JJTSolsTableViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destinationVC.rover = self.rovers[indexPath.row];
    }
}

#pragma mark - Properties

- (void)setRovers:(NSArray *)rovers {
    
    if (rovers != _rovers) {
        _rovers = [rovers copy];
        [self.tableView reloadData];
    }
}

@end
