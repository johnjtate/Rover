//
//  JJTPhotosCollectionViewController.m
//  Rover
//
//  Created by John Tate on 9/12/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTPhotosCollectionViewController.h"
#import "JJTSol.h"
#import "JJTMarsRoverClient.h"
#import "JJTPhoto.h"
#import "JJTPhotoCollectionViewCell.h"
#import "JJTPhotoCache.h"
#import "Rover-Swift.h"

@interface JJTPhotosCollectionViewController ()

@property (nonatomic, readonly) JJTMarsRoverClient *client;
@property (nonatomic, copy) NSArray *photoReferences;

@end

@implementation JJTPhotosCollectionViewController

//static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchPhotoReferences];
}

#pragma mark - Private

- (void)fetchPhotoReferences {
    
    if (!self.rover || !self.sol) {
        return;
    }
    
    JJTMarsRoverClient *client = [[JJTMarsRoverClient alloc] init];
    [client fetchPhotosFromRover:self.rover onSol:self.sol.solNumber completion:^(NSArray *photos, NSError *error) {
        
        if (error) {
            NSLog(@"Error getting photo references for %@ on %@: %@", self.rover, self.sol, error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoReferences = photos;
        });
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photoReferences.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JJTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    JJTPhoto *photo = self.photoReferences[indexPath.row];
    
    JJTPhotoCache *cache = [JJTPhotoCache sharedCache];
    NSData *cachedData = [cache imageDataForIdentifier:photo.photoIdentifier];
    if (cachedData) {
        
        cell.photoImageView.image = [UIImage imageWithData:cachedData];
        return cell;
    } else {
        cell.photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
    }
    
    [self.client fetchImageDataForPhoto:photo completion:^(NSData *imageData, NSError *error) {
        
        if (error || !imageData) {
            NSLog(@"Error fetching image data for %@, %@", photo, error);
            return;
        }
        
        [cache cacheImageData:imageData forIdentifier:photo.photoIdentifier];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![indexPath isEqual:[collectionView indexPathForCell:cell]]) {
                return;
            }
            cell.photoImageView.image = image;
        });
    }];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toPhotoDetailView"]) {
        
        PhotoDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        detailVC.photo = self.photoReferences[indexPath.row];
    }
}

#pragma mark - Properties

@synthesize client = _client;
- (JJTMarsRoverClient *)client {
    
    if (!_client) {
        _client = [[JJTMarsRoverClient alloc] init];
    }
    return _client;
}

- (void)setRover:(JJTRover *)rover {
    
    if (rover != _rover) {
        _rover = rover;
        [self fetchPhotoReferences];
    }
}

- (void)setSol:(JJTSol *)sol {
    
    if (sol != _sol) {
        _sol = sol;
        [self fetchPhotoReferences];
    }
}

- (void)setPhotoReferences:(NSArray *)photoReferences {
    
    if (photoReferences != _photoReferences) {
        _photoReferences = [photoReferences copy];
        [self.collectionView reloadData];
    }
}

@end
