//
//  DetailViewController.m
//  FlickerImages
//
//  Created by Romit M on 07/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewTransition.h"
#import "UIImageView+Url.h"

@interface DetailViewController () <ViewTransitionDataSource>

@property(nonatomic, weak)IBOutlet UILabel *textLabel;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.imageView setImageFromCache:[self.photo.smallImageURL lastPathComponent]];
    [self.imageView setImageFromURL:self.photo.largetImageURL];
    
    [self.textLabel setText:self.photo.title];
    [self.textLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASFSharedViewTransitionDataSource

- (UIView *)sharedView
{
    return _imageView;
}

@end
