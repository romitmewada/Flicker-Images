//
//  Photo.h
//  FlickerImages
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

+(instancetype)photoInstance:(id)property;

@property(nonatomic, strong)NSString *id;

@property(nonatomic, strong)NSURL *smallImageURL;

@property(nonatomic, strong)NSURL *largetImageURL;

@property(nonatomic, strong)NSString *title;

@end
