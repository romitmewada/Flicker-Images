//
//  Photo.m
//  FlickerImages
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+(instancetype)photoInstance:(id)property
{
    Photo *photo = [Photo new];
    photo.id = property[@"id"];
    photo.title = property[@"title"];
    photo.smallImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_m.jpg", property[@"farm"], property[@"server"], property[@"id"], property[@"secret"]]];
    photo.largetImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@.jpg", property[@"farm"], property[@"server"], property[@"id"], property[@"secret"]]];

    return photo;
}
@end