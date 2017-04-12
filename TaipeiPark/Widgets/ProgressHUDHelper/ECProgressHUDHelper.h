/**
 * \file 	ECProgressHUDHelper.h
 * \brief	Handle the HUD behavior, using JGProgressHUD.
 *  - 2015/02/26			edmundchen	File created.
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ECHUDStyle)
{
    ECHUDStyleExtraLight = 0,
    ECHUDStyleLight,
    ECHUDStyleDark
};

typedef NS_ENUM(NSUInteger, ECHUDIndicatorViewStyle)
{
    ECHUDIndicatorViewStyleNone,
    ECHUDIndicatorViewStyleDefault,
    ECHUDIndicatorViewStylePieProgress,
    ECHUDIndicatorViewStyleSuccess,
    ECHUDIndicatorViewStyleError,
};

@interface ECProgressHUDHelper : NSObject

/**
 * \brief	The main presented text on the HUD.
 */
@property (nonatomic, strong) NSString* text;

/**
 * \brief	The presented detail text under the main text on the HUD.
 */
@property (nonatomic, strong) NSString* detail;

/**
 * \brief	The string used to show on HUD for cancel comfirm.
 */
@property (nonatomic, strong) NSString* cancelString;

/**
 * \brief	The appearance style of the HUD.
 */
@property (nonatomic, assign) ECHUDStyle style;

/// The indicatore view style of the HUD. If set before run time, the style will be applied when showing HUD later. If set at run time, the style will be applied immedicately.
@property (nonatomic, assign) ECHUDIndicatorViewStyle indicatorViewStyle;

/**
 * \brief	The boolean value to indicate if showing the overlay background.
 */
@property (nonatomic, assign) BOOL dimBackground;


#pragma mark - Operation

/**
 * \brief	Show the HUD for a work that waste long time.
 * \param   action          The block for the work that waste long time.
 *          targetView      The view in which the HUD is presented.
 *          completion      The block to do something after the HUD dismissed.
 */
- (BOOL)show_HUD: (void(^)(void))action inView: (UIView*) targetView completion: (void(^)(void))completion;

/**
 * \brief	Show the HUD for a work that waste long time. And can cancel the work.
 * \param   action          The block for the work that waste long time.
 *          targetView      The view in which the HUD is presented.
 *          completion      The block to do something after the HUD dismissed.
 *          cancelBlock     The block to do something for canceling the work.
 */
- (BOOL)show_Cancellable_HUD: (void(^)(void))action inView: (UIView*) targetView completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock;

/**
 *  Show the HUD for a while. And will show the progress.
 *  @param  targetView      The view in which the HUD is presented.
 *  @param  delay           The HUD will be hidden after the time (seconds).
 *  @param  completion      The block to do something after the HUD dismissed.
 */
- (BOOL)show_HUD: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion: (void(^)(void))completion;

/**
 *  Show the HUD. The HUD will not disappear until user call the hide_HUD method.
 * 
 *  @param   targetView      The view in which the HUD is presented.
 *  @return     If showing the HUD correctly.
 */
- (BOOL)show_HUD: (UIView*) targetView;

/**
 *  Show the HUD for a work with the pie progress.
 *  
 *  @param  action          The block for the work.
 *  @param  targetView      The view in which the HUD is presented.
 *  @param  progressBlock   The block to return the progress of the work. The value is 0 to 1.
 *  @param  interval        The time interval to get the progress. Default is 0.1 second.
 *  @param  completion      The block to do something after the HUD dismissed.
 */
- (BOOL)show_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView progress: (CGFloat(^)(BOOL *stop))progressBlock interval: (NSTimeInterval) interval completion: (void(^)(void))completion;

/**
 *  Show the HUD for a work with the pie progress.
 *
 *  @param  action          The block for the work.
 *  @param  targetView      The view in which the HUD is presented.
 *  @param  progressBlock   The block to return the progress of the work. The value is 0 to 1.
 *  @param  interval        The time interval to get the progress. Default is 0.1 second.
 *  @param  completion      The block to do something after the HUD dismissed.
 *  @param  cancelBlock     The block to do something for canceling the work.
 */
- (BOOL)show_Cancellable_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView progress: (CGFloat(^)(BOOL *stop))progressBlock interval: (NSTimeInterval) interval completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock;

/**
 *  Show the HUD for a work with the pie progress.
 *
 *  @param  action          The block for the work.
 *  @param  targetView      The view in which the HUD is presented.
 *  @param  time            The time interval to show the HUD
 *  @param  completion      The block to do something after the HUD dismissed.
 */
- (BOOL)show_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion: (void(^)(void))completion;

/**
 *  Show the HUD for a work with the pie progress.
 *
 *  @param  action          The block for the work.
 *  @param  targetView      The view in which the HUD is presented.
 *  @param  time            The time interval to show the HUD
 *  @param  completion      The block to do something after the HUD dismissed.
 *  @param  cancelBlock     The block to do something for canceling the work.
 */
- (BOOL)show_Cancellable_Pie_Progress_HUD: (void(^)(void))action inView: (UIView*) targetView hideAfterDelay: (NSTimeInterval) delay completion: (void(^)(void))completion cancel: (void(^)(void))cancelBlock;

/**
 *  Show the HUD with pie progress. The HUD will not disappear until user call the hide_HUD method.
 *
 *  @param   targetView      The view in which the HUD is presented.
 *  @return     If showing the HUD correctly.
 */
- (BOOL)show_Pie_Progress_HUD: (UIView*) targetView;

/**
 * \brief	Call the method to hide the HUD called by show_HUD:(UIView*)targetView.
 */
- (BOOL)hide_HUD: (void(^)(void))completion;

/**
 *  Set the progress for the HUD
 *
 *  @param  progress    The progress value with float. It is between 0 to 1.
 */
- (void)set_HUD_Progress: (CGFloat) progress;

@end
