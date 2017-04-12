/**
 * \file 	ECBaseViewController.h
 * \brief	Define the general behavior or UI layout for each view.
 *              
 *  - 2013/12/16			edmundchen	File created.
 */

#import <UIKit/UIKit.h>
#import "ECProgressHUDHelper.h"

#pragma mark - BaseViewDataSource

@protocol BaseViewDataSource <NSObject>

/**
 * \brief	Setup the UI layout. Customize the UI layout here and need to call [super init_UI].
 */
- (void)init_UI;

/**
 * \brief	Update the items in second thread. If the function 'should_Skip_Update_Item_Loading'
 *          return YES, It will be call in main thread. Customize the updated items here.
 *          Overwrite the function to update data by calling CGI.
 */
- (void)perform_Update_Items;

/**
 * \brief	Update the UI in main thread after the items are updated.
 *          Overwrite the function to update UI in main thread.
 */
- (void)update_Items_On_Main_Thread;

/**
 * \brief	Show loading HUD when updating items or not.
 * \return  Default return NO.
 */
- (BOOL)should_Skip_Update_Item_Loading;

/**
 * \brief	Determine if should update item when view appear
 * \return  Default return YES.
 */
- (BOOL)should_Update_Items_When_View_Appear;

/**
 * \brief	Determine if the loading HUD is cancellable.
 * \return  Default return NO.
 */
- (BOOL)is_Loading_Cancellable;

/**
 * \brief   The Function is called when user cancel the perform_Update_Items function.
 */
- (void)update_Items_Will_Cancelled;

@end


#pragma mark - NavigationDataSource

@protocol NavigationDataSource <NSObject>

/**
 * \brief	Setup the navigation bar. Customize the navigation bar here and need to call [super init_Navigation_Bar].
 */
- (void)init_Navigation_Bar;

/**
 * \brief	Define the presentation mode (Push/Modal) of the UIViewController.
 * \return  Default return NO as push presentation mode.
 */
- (BOOL)isModalMode;

/**
 * \brief	Show/Hide the refresh button on the right side of navigation bar.
 * \return  Default return NO.
 */
- (BOOL)should_Show_Refresh_Button;

/**
 * \brief	Show/Hide the back button on the left side of navigation bar.
 * \return  Default return YES.
 */
- (BOOL)should_Show_Back_Button;

/**
 * \brief	Create the refresh bar button
 * \return  The refresh bar button
 */
- (UIBarButtonItem*)barButton_For_Refresh_Button;

/**
 * \brief	Create the back bar button.
 * \return  The back bar button.
 */
- (UIBarButtonItem*)barButton_For_Back_Button;


@end


#pragma mark - ECBaseViewController

@interface ECBaseViewController : UIViewController <UIAlertViewDelegate, BaseViewDataSource, NavigationDataSource>
{
    NSMutableArray *_aryItems;
}

#pragma mark - Properties

/// The HUD helper to show loading.
@property (nonatomic, strong) ECProgressHUDHelper* HUD;

/// The base view to show HUD
@property (nonatomic, readonly) UIView* HUDTargetView;

/// The items for the table view or other UI component. Each item should be a dictionary.
@property (nonatomic, strong) NSArray* aryItems;

#pragma mark - Actions

/**
 * \brief	Back to previous view.
 */
- (void)onBack;

/**
 * \brief	Refresh the items.
 */
- (void)onRefresh;

@end

