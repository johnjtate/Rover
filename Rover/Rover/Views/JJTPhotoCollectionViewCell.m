//
//  JJTPhotoCollectionViewCell.m
//  Rover
//
//  Created by John Tate on 9/13/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

#import "JJTPhotoCollectionViewCell.h"

@implementation JJTPhotoCollectionViewCell

- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
}

@end
