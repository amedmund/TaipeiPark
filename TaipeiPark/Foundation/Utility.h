/**
 * \file 	Utility.h
 * \brief	Define the general function
 *  - 2014/01/06			edmundchen	File created.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_IOS6_EARLIER (DeviceSystemMajorVersion() < 7)
#define IS_IOS7_EARLIER (DeviceSystemMajorVersion() < 8)
#define IS_IOS7_LATER (DeviceSystemMajorVersion() >= 7)
#define IS_IOS8_LATER (DeviceSystemMajorVersion() >= 8)
#define IS_IPHONE5_LATER ((DeviceScreenHeight() == 568) ? YES : NO)
#define IS_IPAD_DEVICE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE_DEVICE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_INTERFACE_LANDSCAPE ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)

#define IS_IPHONE_RETINA_4 ((DeviceScreenHeight() == 568) ? YES : NO)      // iPhone 5
#define IS_IPHONE_RETINA_4_7 ((DeviceScreenHeight() == 667) ? YES : NO)    // iPhone 6
#define IS_IPHONE_RETINA_5_5 ((DeviceScreenHeight() == 736) ? YES : NO)    // iPhone 6 plus

@interface Utility : NSObject


#pragma mark - System Functions

/**
 * \brief	Get the iOS verstion on the device
 * \return	Return iOS major verstion
 */
NSUInteger DeviceSystemMajorVersion(void);

/**
 * Get the Screen height for iOS 7 later.
 * 
 * @return	Return the screen height
 */
NSUInteger DeviceScreenHeight(void);

/**
 * Get the Screen height for iOS 7 later.
 *
 * @return	Return the screen width
 */
NSUInteger DeviceScreenWidth(void);

/**
 * Get the device modal name, like iPhone 5, iPhone 6 Plus, etc.
 *
 * @return	Return modal name of the device.
 */
NSString* DeviceModalName(void);

#pragma mark - Other Functions

/**
 *  The method is a wrapper to show alert for iOS 7 and iOS 8.
 *
 *  @param  viewController      The view controller to show the alert.
 *  @param  title               The title of alert.
 *  @param  message             The message of alert.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  okTitle             The title of ok button.
 *  @param  complete            The block is called when user click one button on the alert. The boolean value clickOK shows if the user click the ok button.
 */
+ (void)showAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle complete: (void(^)(BOOL clickOK))completion;

/**
 *  The method is a wrapper to show alert for iOS 7 and iOS 8.
 *
 *  @param  viewController      The view controller to show the alert.
 *  @param  title               The title of alert.
 *  @param  message             The message of alert.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  otherButtonTitles   The other button titles. it is variable arguments, should end with nil.
 *  @param  complete            The block is called when user click one button on the alert. The boolean value clickOK shows if the user click the ok button.
 */
+ (void)showAlert:(UIViewController*) viewController complete: (void(^)(BOOL clickCancel, NSInteger otherButtonIndex))completion title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


+ (void)showAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle otherButtonTitle: (NSArray*) otherButtonTitles complete: (void(^)(BOOL clickCancel, NSInteger otherButtonIndex))completion;

/**
 *  The method is a wrapper to show alert with an input edit for iOS 7 and iOS 8.
 *
 *  @param  viewController      The view controller to show the alert.
 *  @param  title               The title of alert.
 *  @param  message             The message of alert.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  okTitle             The title of ok button.
 *  @param  complete            The block is called when user click one button on the alert. The boolean value "clickOK" shows if the user click the ok button and the "input" is the user input string.
 */
+ (void)showInputAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle secure: (BOOL)secure complete: (void(^)(BOOL clickOK, NSString* input))completion;

/**
 *  The method is a wrapper to show alert with an input edit for iOS 8.
 *
 *  @param  viewController      The view controller to show the alert.
 *  @param  title               The title of alert.
 *  @param  message             The message of alert.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  okTitle             The title of ok button.
 *  @param  textField           The input of textField.
 *  @param  placeholder         The placeholder of textField.
 *  @param  complete            The block is called when user click one button on the alert. The boolean value "clickOK" shows if the user click the ok button and the "input" is the user input string.
 */
+ (void)showInputAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle textField: (NSString*)text secure: (BOOL)secure placeholder: (NSString*)placeholder complete: (void(^)(BOOL clickOK, NSString* input))completion;

/**
 *  The method is a wrapper to show action sheet for iOS 7 and iOS 8.
 *
 *  @param  viewController      The view controller to show the action sheet.
 *  @param  sourceObject        The source object for iPad to popover the action sheet.
 *  @param  complete            The block is called when user click one button on the action sheet. The boolean value clickCancel shows if the user click the cancel button. The boolean value clickDestructive shows if the user click the destructive button. The integer otherButtonIndex indicate which other button is clicked and is started with 0.
 *  @param  title               The title of action sheet.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  otherButtonTitles   The other button titles. it is variable arguments, should end with nil.
 */
+ (void)showActionSheet:(UIViewController*) viewController fromObject: (id) sourceObject complete: (void(^)(BOOL clickCancel, BOOL clickDestructive, NSInteger otherButtonIndex))completion title:(NSString*) title message:(NSString*) message cancelButtonTitle: (NSString*) cancelTitle destructiveButtonTitle: (NSString*) destructiveTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  The method is a wrapper to show action sheet for iOS 8 later.
 *
 *  @param  viewController      The view controller to show the action sheet.
 *  @param  sourceObject        The source object for iPad to popover the action sheet.
 *  @param  complete            The block is called when user click one button on the action sheet. The boolean value clickCancel shows if the user click the cancel button. The boolean value clickDestructive shows if the user click the destructive button. The integer otherButtonIndex indicate which other button is clicked and is started with 0.
 *  @param  title               The title of action sheet.
 *  @param  cancelTitle         The title of cancel button.
 *  @param  otherButtonTitles   The string array of other button titles
 */
+ (void)showActionSheet:(UIViewController*) viewController fromObject: (id) sourceObject title:(NSString*) title message:(NSString*) message cancelButtonTitle: (NSString*) cancelTitle destructiveButtonTitle: (NSString*) destructiveTitle otherButtonTitles:(NSArray *)otherButtonTitles complete: (void(^)(BOOL clickCancel, BOOL clickDestructive, NSInteger otherButtonIndex))completion;

@end
