/* Copyright (c) 2014  ASUSTOR Inc.  All Rights Reserved. */
/**
 * \file 	Utility.m
 * \brief	Define the general function
 *  - 2014/01/06			edmundchen	File created.
 */

#import "Utility.h"
#import "Foundation+Extend.h"
#import <sys/utsname.h>

@interface DelegateHelper : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) void(^blockAlert)(BOOL clickCancel, NSInteger otherButtonIndex);
@property (nonatomic, strong) void(^blockActionSheet)(BOOL clickCancel, BOOL clickDestructive, NSInteger otherButtonIndex);
@property (nonatomic, strong) void(^blockInputAlert)(BOOL clickOK, NSString* input);

@end

@implementation DelegateHelper

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.blockAlert)
    {
        BOOL clickCancel = (alertView.cancelButtonIndex == buttonIndex);
        NSInteger otherButtonIndex = -1;
        
        // Calculate the other button index. It is 0 base.
        if (!clickCancel)
        {
            otherButtonIndex = buttonIndex;
        }
        
        self.blockAlert(clickCancel, otherButtonIndex);
        self.blockAlert = nil;
        
        NSLog(@"cancel %ld", (long)alertView.cancelButtonIndex);
        NSLog(@"%ld", (long)buttonIndex);
    }
    else if (self.blockInputAlert)
    {
        BOOL clickOK = (alertView.cancelButtonIndex != buttonIndex);
        UITextField *edit = [alertView textFieldAtIndex:0];
        
        self.blockInputAlert(clickOK, edit.text);
        self.blockInputAlert = nil;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.blockActionSheet)
    {
        BOOL clickCancel = (actionSheet.cancelButtonIndex == buttonIndex);
        BOOL clickDestructive = (actionSheet.destructiveButtonIndex == buttonIndex);
        NSInteger otherButtonIndex = -1;
        
        // Calculate the other button index. It is 0 base.
        if (!clickCancel && !clickDestructive)
        {
            NSInteger firstOtherButtonIndex = (0 <= actionSheet.destructiveButtonIndex) ? 1 : 0;
            otherButtonIndex = buttonIndex - firstOtherButtonIndex;
        }
        
        self.blockActionSheet(clickCancel, clickDestructive, otherButtonIndex);
        self.blockActionSheet = nil;
    }
}

@end

@implementation Utility

#pragma mark - System Functions

NSUInteger DeviceSystemMajorVersion(void)
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

NSUInteger DeviceScreenHeight(void)
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat nScreenHeight = rect.size.height;
    
    // In iOS8, the UIScreen is interface oriented
    if (IS_IOS8_LATER)
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation)
        {
            nScreenHeight = rect.size.width;
        }
    }
    
    return nScreenHeight;
}

NSUInteger DeviceScreenWidth(void)
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat nScreenWidth = rect.size.width;
    
    // In iOS8, the UIScreen is interface oriented
    if (IS_IOS8_LATER)
    {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation)
        {
            nScreenWidth = rect.size.height;
        }
    }
    
    return nScreenWidth;
}

NSString* DeviceModalName(void)
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    // iPod
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    // iPad
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"32 bit Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"64 bit Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";

    return deviceModel;
}

#pragma mark - Other Functions

+ (DelegateHelper*)shareDelegate
{
    static DelegateHelper *helper;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        helper = [[DelegateHelper alloc] init];
    });
    
    return helper;
}

+ (void)showAlert: (UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle complete: (void(^)(BOOL clickOK))completion
{
    [Utility showAlert:viewController complete:^(BOOL clickCancel, NSInteger otherButtonIndex){
        if (completion)
            completion(!clickCancel);
    }title:title message:message cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
}

+ (void)showAlert:(UIViewController*) viewController complete: (void(^)(BOOL clickCancel, NSInteger otherButtonIndex))completion title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *aryOtherButtonTitles = nil;
    
    if (nil != otherButtonTitles)
    {
        va_list args;
        
        va_start(args, otherButtonTitles);
        
        aryOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        
        // Add other button titles
        NSString* strBtnTitle = va_arg(args, NSString*);
        
        while (nil != strBtnTitle)
        {
            [aryOtherButtonTitles addObject:strBtnTitle];
            strBtnTitle = va_arg(args, NSString*);
        }
        
        va_end(args);
    }
    
    [Utility showAlert:viewController title:title message:message cancelButtonTitle:cancelTitle otherButtonTitle:aryOtherButtonTitles complete:completion];
}

+ (void)showAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle otherButtonTitle: (NSArray*) otherButtonTitles complete: (void(^)(BOOL clickCancel, NSInteger otherButtonIndex))completion
{
    if (nil != NSClassFromString(@"UIAlertController"))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Create cancel button
        if (nil != cancelTitle && 0 < cancelTitle.length)
        {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (completion)
                    completion(YES, -1);
            }];
            
            [alertController addAction:cancelAction];
        }
        
        for (NSInteger i = 0; i < otherButtonTitles.count; i++)
        {
            NSString* strBtnTitle = [otherButtonTitles objectAtIndex:i];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:strBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (completion)
                    completion(NO, i);
            }];
            
            [alertController addAction:otherAction];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [viewController presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        DelegateHelper *delegate = [Utility shareDelegate];
        
        delegate.blockAlert = completion;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
        
        if (nil != otherButtonTitles)
        {
            for (NSString *strBtnTitle in otherButtonTitles)
            {
                [alertView addButtonWithTitle:strBtnTitle];
            }
        }
        
        // Create the cancel button
        if (nil != cancelTitle && 0 < cancelTitle.length)
        {
            alertView.cancelButtonIndex = [alertView addButtonWithTitle:cancelTitle];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [alertView show];
        });
    }
}

+ (void)showInputAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle secure: (BOOL)secure complete: (void(^)(BOOL clickOK, NSString* input))completion
{
    if (nil != NSClassFromString(@"UIAlertController"))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Add text field
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = (secure) ? @"Password" : nil;
             textField.secureTextEntry = secure;
         }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (completion)
                completion(NO, nil);
        }];
        
        [alertController addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (completion)
            {
                UITextField *edit = alertController.textFields.firstObject;
                
                completion(YES, edit.text);
            }
        }];
        
        [alertController addAction:okAction];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [viewController presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        DelegateHelper *delegate = [Utility shareDelegate];
        
        delegate.blockInputAlert = completion;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
        
        alertView.alertViewStyle = secure ? UIAlertViewStyleSecureTextInput : UIAlertViewStylePlainTextInput;
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [alertView show];
        });
    }
}

+ (void)showInputAlert:(UIViewController*) viewController title:(NSString*) title message: (NSString*) message cancelButtonTitle: (NSString*) cancelTitle okButtonTitle: (NSString*) okTitle textField: (NSString*)text secure: (BOOL)secure placeholder: (NSString*)placeholder complete: (void(^)(BOOL clickOK, NSString* input))completion
{
    if (nil != NSClassFromString(@"UIAlertController"))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Add text field
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.text = text;
             textField.placeholder = (secure) ? @"Password" : placeholder;
             textField.secureTextEntry = secure;
         }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (completion)
                completion(NO, nil);
        }];
        
        [alertController addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (completion)
            {
                UITextField *edit = alertController.textFields.firstObject;
                
                completion(YES, edit.text);
            }
        }];
        
        [alertController addAction:okAction];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [viewController presentViewController:alertController animated:YES completion:nil];
        });
    }
}

+ (void)showActionSheet:(UIViewController*) viewController fromObject: (id) sourceObject complete: (void(^)(BOOL clickCancel, BOOL clickDestructive, NSInteger otherButtonIndex))completion title:(NSString*) title message:(NSString*) message cancelButtonTitle: (NSString*) cancelTitle destructiveButtonTitle: (NSString*) destructiveTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *aryOtherButtonTitles = nil;
    
    if (nil != otherButtonTitles)
    {
        va_list args;
        
        va_start(args, otherButtonTitles);
        
        aryOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        
        // Add other button titles
        NSString* strBtnTitle = va_arg(args, NSString*);
        
        while (nil != strBtnTitle)
        {
            [aryOtherButtonTitles addObject:strBtnTitle];
            strBtnTitle = va_arg(args, NSString*);
        }
        
        va_end(args);
    }
    
    [Utility showActionSheet:viewController fromObject:sourceObject title:title message:message cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitles:aryOtherButtonTitles complete:completion];
}

+ (void)showActionSheet:(UIViewController*) viewController fromObject: (id) sourceObject title:(NSString*) title message:(NSString*) message cancelButtonTitle: (NSString*) cancelTitle destructiveButtonTitle: (NSString*) destructiveTitle otherButtonTitles:(NSArray *)otherButtonTitles complete: (void(^)(BOOL clickCancel, BOOL clickDestructive, NSInteger otherButtonIndex))completion
{
    if (nil != NSClassFromString(@"UIAlertController"))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the cancel button
        if (nil != cancelTitle && 0 < cancelTitle.length)
        {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (completion)
                    completion(YES, NO, -1);
            }];
            
            [alertController addAction:cancelAction];
        }
        
        // Create the destructive button.
        if (nil != destructiveTitle && 0 < destructiveTitle.length)
        {
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                if (completion)
                    completion(NO, YES, -1);
            }];
            
            [alertController addAction:destructiveAction];
        }
        
        if (nil != otherButtonTitles)
        {
            for (NSInteger i = 0; i < otherButtonTitles.count; i++)
            {
                NSString *strBtnTitle = [otherButtonTitles objectAtIndex:i];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:strBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (completion)
                        completion(NO, NO, i);
                }];
                
                [alertController addAction:otherAction];
            }
        }
        
        if (IS_IPAD_DEVICE)
        {
            if ([sourceObject isKindOfClass:[UIBarButtonItem class]])
            {
                alertController.popoverPresentationController.barButtonItem  = sourceObject;
            }
            else if ([sourceObject isKindOfClass:[UIView class]])
            {
                alertController.popoverPresentationController.sourceView = sourceObject;
                alertController.popoverPresentationController.sourceRect = [sourceObject bounds];
            }
            else
            {
                alertController.popoverPresentationController.sourceView = viewController.view;
                alertController.popoverPresentationController.sourceRect = CGRectMake(viewController.view.frame.size.width/2, viewController.view.frame.size.height/2, 1, 1);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [viewController presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        DelegateHelper *delegate = [Utility shareDelegate];
        
        delegate.blockActionSheet = completion;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:destructiveTitle otherButtonTitles:nil];
        
        if (nil != otherButtonTitles)
        {
            for (NSString *strBtnTitle in otherButtonTitles)
            {
                [actionSheet addButtonWithTitle:strBtnTitle];
            }
        }
        
        // Create the cancel button
        if (nil != cancelTitle && 0 < cancelTitle.length)
        {
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelTitle];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [actionSheet showInView:viewController.view];
        });
    }
}

@end
