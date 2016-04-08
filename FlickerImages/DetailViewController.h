//
//  DetailViewController.h
//  FlickerImages
//
//  Created by Romit M on 07/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) UIImage *image;

@property(nonatomic, strong)Photo *photo;

@end
