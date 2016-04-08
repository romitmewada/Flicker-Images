//
//  ViewTransition.m
//  FlickerImages
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import "ViewTransition.h"
#import <objc/runtime.h>

@interface ParamsHolder : NSObject

@property (nonatomic, weak) UINavigationController *navigation;
@property (nonatomic, weak) Class fromViewControllerClass;
@property (nonatomic, weak) Class toViewControllerClass;

@property (nonatomic, assign) NSTimeInterval duration;


@end

@implementation ParamsHolder

@end

@interface ViewTransition ()

@property (nonatomic, retain) NSMutableArray *arrParamHolders;

@end

@implementation ViewTransition

#pragma mark - Setup & Initializers

+ (instancetype)shared
{
    static ViewTransition *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ViewTransition alloc] init];
    });
    return instance;
}

- (NSMutableArray *)arrParamHolders
{
    if (!_arrParamHolders) {
        _arrParamHolders = [[NSMutableArray alloc] init];
    }
    
    return _arrParamHolders;
}

#pragma mark - Private Methods

- (ParamsHolder *)paramHolderForFromVC:(UIViewController *)fromVC ToVC:(UIViewController *)toVC reversed:(BOOL *)reversed {
    ParamsHolder *pHolder = nil;
    for (ParamsHolder *holder in [[ViewTransition shared] arrParamHolders]) {
        if (holder.fromViewControllerClass == [fromVC class] && holder.toViewControllerClass == [toVC class]) {
            pHolder = holder;
        }
        else if (holder.fromViewControllerClass == [toVC class] && holder.toViewControllerClass == [fromVC class]) {
            pHolder = holder;
            
            if (reversed) {
                *reversed = true;
            }
        }
    }
    
    return pHolder;
}

#pragma mark - Public Methods

+ (void)addTransitionWithFromViewControllerClass:(Class<ViewTransitionDataSource>)fromViewControllerClass ToViewControllerClass:(Class<ViewTransitionDataSource>)toViewControllerClass WithNavigationController:(UINavigationController *)navigationController WithDuration:(NSTimeInterval)duration;
{
    BOOL found = false;
    for (ParamsHolder *holder in [[ViewTransition shared] arrParamHolders]) {
        if (holder.fromViewControllerClass == fromViewControllerClass && holder.toViewControllerClass == toViewControllerClass) {
            holder.duration = duration;
            holder.navigation = navigationController;
            holder.navigation.delegate = [ViewTransition shared];
            
            found = true;
            break;
        }
    }
    
    if (!found) {
        ParamsHolder *holder = [[ParamsHolder alloc] init];
        holder.fromViewControllerClass = fromViewControllerClass;
        holder.toViewControllerClass = toViewControllerClass;
        holder.duration = duration;
        holder.navigation = navigationController;
        
        holder.navigation.delegate = [ViewTransition shared];
        [[[ViewTransition shared] arrParamHolders] addObject:holder];
    }
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    ParamsHolder *pHolder = [self paramHolderForFromVC:fromVC ToVC:toVC reversed:nil];
    if (pHolder) {
        return [ViewTransition shared];
    }
    else {
        return nil;
    }
}

#pragma mark - UIViewControllerContextTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<ViewTransitionDataSource> *fromVC =
        (UIViewController<ViewTransitionDataSource> *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<ViewTransitionDataSource> *toVC   =
        (UIViewController<ViewTransitionDataSource> *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL reversed = false;
    ParamsHolder *pHolder = [self paramHolderForFromVC:fromVC ToVC:toVC reversed:&reversed];
    
    if (!pHolder) {
        return;
    }
    
    UIView *fromView = [fromVC sharedView];
    UIView *toView = [toVC sharedView];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval dur = [self transitionDuration:transitionContext];
    
    // Take Snapshot of fomView
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    fromView.hidden = YES;
    
    // Setup the initial view states
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    if (!reversed) {
        toVC.view.alpha = 0;
        toView.hidden = YES;
        [containerView addSubview:toVC.view];
    }
    else {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
    [containerView addSubview:snapshotView];
    
    [UIView animateWithDuration:dur animations:^{
        if (!reversed) {
            toVC.view.alpha = 1.0; // Fade in
        }
        else {
            fromVC.view.alpha = 0.0; // Fade out
        }
        
        // Move the SnapshotView
        snapshotView.frame = [containerView convertRect:toView.frame fromView:toView.superview];
        
    } completion:^(BOOL finished) {
        // Clean up
        toView.hidden = NO;
        fromView.hidden = NO;
        [snapshotView removeFromSuperview];
        
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    ParamsHolder *pHolder = [self paramHolderForFromVC:fromVC ToVC:toVC reversed:nil];
    
    if (pHolder) {
        return pHolder.duration;
    }
    else {
        return 0;
    }
}

@end
