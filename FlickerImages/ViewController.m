//
//  ViewController.m
//  FlickerImages
//
//  Created by Romit M on 07/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "ViewTransition.h"
#import "WebService.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "UIImageView+Url.h"

@interface ViewController () <ViewTransitionDataSource>

@property(nonatomic, strong)NSArray *photos;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ViewTransition addTransitionWithFromViewControllerClass:[ViewController class] ToViewControllerClass:[DetailViewController class] WithNavigationController:self.navigationController WithDuration:0.2f];

    [self loadPhotos];
}

-(void)loadPhotos{
    
    [WebService requestFlickerPhoto:^(NSArray *response) {
        
        self.photos = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
        
    } Error:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        // Get the selected item index path
        NSIndexPath *selectedIndexPath = [[_collectionView indexPathsForSelectedItems] firstObject];
        
        // Set the thing on the view controller we're about to show
        if (selectedIndexPath != nil) {
            DetailViewController *detailVC = segue.destinationViewController;
            detailVC.photo = self.photos[selectedIndexPath.row];
        }
    }
}

#pragma mark UICollectionViewControllerDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = self.photos[indexPath.row];
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageView setImageFromURL:photo.smallImageURL];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float width = (CGRectGetWidth(collectionView.frame)/2) - 10;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - ViewTransitionDataSource

- (UIView *)sharedView
{
    return [self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
}


@end
