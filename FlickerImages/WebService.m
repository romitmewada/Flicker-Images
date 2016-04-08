//
//  WebService.m
//
//  Created by Romit Mewada on 09/07/10.
//  Copyright (c) 2014 Romit Mewada. All rights reserved.
//

#import "WebService.h"
#import "Model/Photo.h"

NSString *const FlickrAPIKey = @"10df04b16290e1b3b13eaf3fd5e38933";

@implementation WebService

+(void)requestFlickerPhoto:(void (^)(NSArray *response))getResponse Error:(void (^)(NSError *error))erroResponse
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=50&format=json&nojsoncallback=1", FlickrAPIKey, @"iphone"];

    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError)
        {
            erroResponse(connectionError);
            return;
        }
        
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // Build an array from the dictionary for easy access to each entry
        NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
        
        NSMutableArray *array = [NSMutableArray new];

        [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Photo *photo = [Photo photoInstance:obj];
            [array addObject:photo];
        }];
        
        getResponse(array);
    }];
}

@end