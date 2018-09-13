//
//  JJTSolsTableViewController.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTSolsTableViewController.h"
#import "JJTRover.h"
#import "JJTSol.h"
#import "JJTPhotosCollectionViewController.h"

@interface JJTSolsTableViewController ()

@end

@implementation JJTSolsTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // need to know how many sols per rover; this is passed in through the segue array
    return self.rover.solDescription.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SolCell" forIndexPath:indexPath];
    
    JJTSol *sol = self.rover.solDescription[indexPath.row];
    // each solDescription object has a sol number, number of photos, and list of cameras
    cell.textLabel.text = [NSString stringWithFormat:@"Sol %@", @(sol.solNumber)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Photos", @(sol.solNumberOfPhotos)];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"toPhotosView"]) {
        JJTPhotosCollectionViewController *destinationVC = segue.destinationViewController;
        destinationVC.rover = self.rover;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         // send solDesciption to landing pad in JJTSolsTableViewController
        destinationVC.sol = self.rover.solDescription[indexPath.row];
    }
}

#pragma mark - Properties

- (void)setRovers:(JJTRover *)rover {
    
    if (rover != _rover) {
        _rover = rover;
        [self.tableView reloadData];
    }
}

@end
