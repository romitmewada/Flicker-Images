//
//  ViewTransition.h
//  FlickerImages
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ViewTransitionDataSource <NSObject>

- (UIView *)sharedView;

@end

@interface ViewTransition : NSObject<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@property (nonatomic, weak) Class fromViewControllerClass;
@property (nonatomic, weak) Class toViewControllerClass;

+ (void)addTransitionWithFromViewControllerClass:(Class<ViewTransitionDataSource>)fromViewControllerClass ToViewControllerClass:(Class<ViewTransitionDataSource>)toViewControllerClass WithNavigationController:(UINavigationController *)navigationController WithDuration:(NSTimeInterval)duration;

@end
