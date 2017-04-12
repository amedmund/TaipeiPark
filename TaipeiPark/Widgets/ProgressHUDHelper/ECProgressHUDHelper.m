/**
 * \file 	ECProgressHUDHelper.m
 * \brief	Handle the HUD behavior, using JGProgressHUD.
 *  - 2015/02/26			edmundchen	File created.
 */

#import "ECProgressHUDHelper.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUDIndeterminateIndicatorView.h"

@interface ECProgressHUDHelper () <JGProgressHUDDelegate>

@end

@implementation ECProgressHUDHelper
{
    JGProgressHUDStyle _HUDStyle;
    JGProgressHUD *_HUD;
    NSTimer *_timer;
    
    void (^_completeBlock)(void);
    CGFloat (^_progressBlock)(BOOL *stop);
}

#pragma mark - Initial Functions

@synthesize text = _text;
@synthesize detail = _detail;
@synthesize indicatorViewStyle = _indicatorViewStyle;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _HUDStyle = JGProgressHUDStyleDark;     // Default
        self.text = @"Loading";
        self.cancelString = @"Cancel";
        self.detail = nil;
    }
    
    return self;
}

#pragma mark - Property

- (void)setStyle:(enum ECHUDStyle)style
{
    _HUDStyle = (JGProgressHUDStyle)style;
}

- (ECHUDStyle)style
{
    return (ECHUDStyle)_HUDStyle;
}

- (void)setIndicatorViewStyle:(ECHUDIndicatorViewStyle)indicatorViewStyle
{
    _indicatorViewStyle = indicatorViewStyle;
    
    if (_HUD)
    {
        [self set_HUD_Indicator_View_Style:_indicatorViewStyle];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    if (_HUD)
    {
        _HUD.textLabel.text = text;
    }
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    
    if (_HUD)
    {
        _HUD.detailTextLabel.text = detail;
    }
}

#pragma mark - Operaions

- (BOOL)show_HUD: (void(^)(void))action inView: (UIView*) targetView completion: (void(^)(void))completion
{
    if ([self show_HUD:targetView])
    {
        [self _setup_Complete_Behavior:completion];
        [self _do_Action:action];
    
        return YES;
    }
    
    return NO;
}

- (BOOL)show_Cancellable_HUD: (void(^)(void))action inView: (UIView*) targetView completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock
{
    if ([self show_HUD:targetView])
    {
        [self _setup_Cancal_Behavior:cancelBlock];
        [self _setup_Complete_Behavior:completion];
        [self _do_Action:action];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)show_HUD: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion:(void (^)(void))completion
{
    if ([self show_HUD:targetView])
    {
        [self _setup_Complete_Behavior:completion];
        [_HUD dismissAfterDelay:delay];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)show_HUD: (UIView*) targetView
{
    if (_HUD)
        return NO;
    
    _HUD = [self _prototypeHUD];
    
    _HUD.textLabel.text = self.text;
    if (self.detail)
        _HUD.detailTextLabel.text = self.detail;
    
    [_HUD showInView:targetView];
    
    return YES;
}

- (BOOL)show_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView progress: (CGFloat(^)(BOOL *stop))progressBlock interval: (NSTimeInterval) interval completion: (void(^)(void))completion
{
    if ([self show_Pie_Progress_HUD:targetView])
    {
        [self _setup_Complete_Behavior:completion];
        
        if (progressBlock)
            _progressBlock = progressBlock;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            if (action)
                action();
            
            dispatch_sync(dispatch_get_main_queue(), ^(){
                _timer = [NSTimer timerWithTimeInterval:interval ?: 0.1 target:self selector:@selector(_update_Progress:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            });
            
        });
        
        return YES;
    }
    
    return NO;
}

- (BOOL)show_Cancellable_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView progress: (CGFloat(^)(BOOL *stop))progressBlock interval: (NSTimeInterval) interval completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock
{
    if ([self show_Pie_Progress_HUD:action inView:targetView progress:progressBlock interval:interval completion:completion])
    {
        [self _setup_Cancal_Behavior:cancelBlock];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)show_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion: (void(^)(void))completion
{
    __block CGFloat progress = 0;
    CGFloat delta = 1.0 / (delay / 0.1);
    
    return [self show_Pie_Progress_HUD:action inView:targetView progress:^CGFloat(BOOL *stop){
        progress += delta;
        
        if (1.0 <=progress)
        {
            *stop = YES;
        }
        
        return progress;
    }interval:0.1 completion:completion];
}

- (BOOL)show_Cancellable_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock
{
    if ([self show_Pie_Progress_HUD:action inView:targetView hideAfterDelay:delay completion:completion])
    {
        [self _setup_Cancal_Behavior:cancelBlock];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)show_Pie_Progress_HUD: (UIView*) targetView
{
    if (_HUD)
        return NO;
    
    _HUD = [self _prototypeHUD];
    
    _HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:_HUD.style];
    _HUD.textLabel.text = self.text;
    if (self.detail)
        _HUD.detailTextLabel.text = self.detail;
    
    [_HUD showInView:targetView];
    
    return YES;
}

- (BOOL)hide_HUD: (void(^)(void))completion
{
    [_HUD dismiss];
    
    [self _setup_Complete_Behavior:completion];
    
    return YES;
}

- (void)set_HUD_Indicator_View_Style: (ECHUDIndicatorViewStyle) style;
{
    if (_HUD)
    {
        if (ECHUDIndicatorViewStyleNone == style)
            _HUD.indicatorView = nil;
        else if (ECHUDIndicatorViewStyleDefault == style)
            _HUD.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:_HUD.style];
        else if (ECHUDIndicatorViewStylePieProgress == style)
            _HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:_HUD.style];
        else if (ECHUDIndicatorViewStyleSuccess == style)
            _HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        else if (ECHUDIndicatorViewStyleError == style)
            _HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    }
}

#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    _HUD = nil;
    
    if (_completeBlock)
    {
        void (^block)(void) = [_completeBlock copy];
        _completeBlock = nil;
        
        block();
    }
}

#pragma mark - Private Methods

- (JGProgressHUD *)_prototypeHUD
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:_HUDStyle];
    
    if (ECHUDIndicatorViewStyleDefault != self.indicatorViewStyle)
        [self set_HUD_Indicator_View_Style:self.indicatorViewStyle];
    
    if (self.dimBackground) {
        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    }
    
    HUD.delegate = self;
    
    return HUD;
}

- (void)_setup_Complete_Behavior: (void(^)(void))completeBlock
{
    if (completeBlock)
        _completeBlock = completeBlock;
}

- (void)_do_Action: (void(^)(void))actionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if (actionBlock)
            actionBlock();
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [self hide_HUD:nil];
        });
    });
}

- (void)_setup_Cancal_Behavior: (void(^)(void))cancelBlock
{
    __block BOOL confirmationAsked = NO;
    __weak ECProgressHUDHelper *wSelf = self;
    
    // Store the orignial indicator view
    JGProgressHUDIndicatorView *indicatorView = _HUD.indicatorView;
    
    _HUD.tapOnHUDViewBlock = ^(JGProgressHUD *h) {
        __strong ECProgressHUDHelper *sSelf = wSelf;
        
        if (confirmationAsked)
        {
            if (cancelBlock)
                cancelBlock();
            
            [h dismiss];
        }
        else
        {
            h.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            h.textLabel.text = [NSString stringWithFormat:@"%@ ?", sSelf.cancelString];
            if (sSelf.detail)
                h.detailTextLabel.text = nil;
            confirmationAsked = YES;
            
            __weak __typeof(h) wH = h;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wH && confirmationAsked)
                {
                    confirmationAsked = NO;
                    __strong __typeof(wH) sH = wH;
                    
                    sH.indicatorView = indicatorView;
                    sH.textLabel.text = sSelf.text;
                    if (sSelf.detail)
                        sH.detailTextLabel.text = sSelf.detail;
                }
            });
        }
    };
    
    _HUD.tapOutsideBlock = ^(JGProgressHUD *h) {
        __strong ECProgressHUDHelper *sSelf = wSelf;
        
        if (confirmationAsked)
        {
            confirmationAsked = NO;
            h.indicatorView = indicatorView;
            h.textLabel.text = sSelf.text;
            if (sSelf.detail)
                h.detailTextLabel.text = sSelf.detail;
        }
    };
}

- (void)_update_Progress: (NSTimer*) aTimer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        __block BOOL stop = NO;
        
        CGFloat progress = _progressBlock(&stop);
        
        dispatch_sync(dispatch_get_main_queue(), ^(){
            [_HUD setProgress:progress animated:YES];
            
            if (stop)
            {
                [self _stop_Progress];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_HUD dismiss];
                });
            }
        });
        
    });
}

- (void)_stop_Progress
{
    [_timer invalidate];
    _timer = nil;
    _progressBlock = nil;
}

- (void)set_HUD_Progress: (CGFloat) progress
{
    if (_HUD && 0 <= progress && 1 >= progress)
    {
        [_HUD setProgress:progress animated:YES];
    }
}

@end
