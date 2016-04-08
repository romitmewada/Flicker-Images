//
//  WebService.h
//
//  Created by Romit Mewada on 09/07/10.
//  Copyright (c) 2014 Romit Mewada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+(void)requestFlickerPhoto:(void (^)(NSArray *response))getResponse Error:(void (^)(NSError *error))erroResponse;

@end