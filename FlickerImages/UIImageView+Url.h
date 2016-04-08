//
//  UIImageView+Url.h
//  FlickerImages
//
//  Created by Romit M on 07/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Url)

@property (nonatomic, copy) NSURL *imageURL;

- (void)setImageFromURL:(NSURL*)url;

-(void)setImageFromCache:(NSString*)key;

@end
