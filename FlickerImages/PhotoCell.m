//
//  PhotoCellCollectionViewCell.m
//  FlickerImages
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}
@end