//
//  UIImageView+Url.m
//  FlickerImages
//
//  Created by Romit M on 07/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "UIImageView+Url.h"
#import <objc/runtime.h>

static NSTimeInterval cacheTime =  (double)604800;

static char URL_KEY;

@implementation UIImageView (Url)

- (void) setImageURL:(NSURL *)newImageURL {
    objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
    return objc_getAssociatedObject(self, &URL_KEY);
}

- (void)setImageFromURL:(NSURL*)url {

    self.imageURL = url;

    NSData *cachedData = [UIImageView objectForKey:[url.absoluteString lastPathComponent]];
    if (cachedData) {
        
        self.imageURL   = nil;
        self.image = [UIImage imageWithData:cachedData];
        return;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *imageFromData = [UIImage imageWithData:data];
        
        [UIImageView setObject:data forKey:[url.absoluteString lastPathComponent]];

        if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = imageFromData;
            });
        } else {
            //				NSLog(@"urls are not the same, bailing out!");
        }
    });
}

-(void)setImageFromCache:(NSString*)key
{
    NSData *cachedData = [UIImageView objectForKey:key];
    if (cachedData) {
        
        self.image = [UIImage imageWithData:cachedData];
    }
}

//SET & GET CACHES IMAGES

+ (NSData*) objectForKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }
}

 + (NSString*) cacheDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"FlckerImages"];
    return cacheDirectory;
}

@end
