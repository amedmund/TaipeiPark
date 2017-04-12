/**
 * \file 	ECBaseViewController.m
 * \brief	Define the general behavior or UI layout for each view.
 *  - 2013/12/16			edmundchen	File created.
 */

#import "ECBaseViewController.h"
//#import "UtilityObject.h"
//#import "UIKit+Extend.h"

@interface ECBaseViewController ()

@end

@implementation ECBaseViewController
{
    BOOL _bDoneOperation;
    
    id _delegateCustomUI;
}

@synthesize HUD;
@synthesize aryItems = _aryItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Init the HUD
    self.HUD = [[ECProgressHUDHelper alloc] init];
    
    [self _init_UI];
    [self _init_Navigation_Bar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self should_Skip_Update_Item_Loading] && [self should_Update_Items_When_View_Appear])
        [self _update_Items];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self should_Skip_Update_Item_Loading] && [self should_Update_Items_When_View_Appear])
        [self _update_Items];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", self);
}

#pragma mark - Property

- (UIView*)HUDTargetView
{
    if (nil != self.tabBarController.view)
        return self.tabBarController.view;
    else if (nil != self.navigationController.view)
        return self.navigationController.view;
        
    return self.view;
}

#pragma mark - Action Functions

- (void)onBack
{
    self.HUD = nil;
    
    if ([self isModalMode])
    {
        [self dismissViewControllerAnimated:YES completion:^(){
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onRefresh
{
    [self _update_Items];
}

#pragma mark - BaseViewDataSource Functions

- (void)perform_Update_Items
{
    // Overwrite the function to update data by calling CGI.
}

- (void)update_Items_On_Main_Thread
{
    // Overwrite the function to update UI in main thread.
}

- (BOOL)should_Skip_Update_Item_Loading
{
    return NO;
}

- (BOOL)should_Update_Items_When_View_Appear
{
    return YES;
}

- (void)update_Items_Will_Cancelled
{
    
}

- (BOOL)is_Loading_Cancellable
{
    return NO;
}

- (void)init_UI
{
    
}

#pragma mark - NavigationDataSource

- (void)init_Navigation_Bar
{
    
}

- (BOOL)isModalMode
{
    return NO;
}

- (BOOL)should_Show_Refresh_Button
{
    return NO;
}

- (BOOL)should_Show_Back_Button
{
    return YES;
}

- (UIBarButtonItem*)barButton_For_Refresh_Button
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefresh)];
}

- (UIBarButtonItem*)barButton_For_Back_Button
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBack)];
}

#pragma mark - Private Functions

- (void)_init_UI
{
    self.navigationController.navigationBar.translucent = NO;

    [self init_UI];
}

- (void)_init_Navigation_Bar
{
    if ([self should_Show_Back_Button])
    {
        self.navigationItem.leftBarButtonItem = [self barButton_For_Back_Button];
    }
    else
    {
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
    
    // Setup the right bar button
    if ([self should_Show_Refresh_Button])
    {
        self.navigationItem.rightBarButtonItem = [self barButton_For_Refresh_Button];
    }
    
    [self init_Navigation_Bar];
}

- (void)_update_Items
{
    if ([self should_Skip_Update_Item_Loading])
    {
        [self perform_Update_Items];
        [self performSelectorOnMainThread:@selector(update_Items_On_Main_Thread) withObject:nil waitUntilDone:NO];
    }
    else
    {
        if ([self is_Loading_Cancellable])
        {
            [self.HUD show_Cancellable_HUD:^(){
                [self perform_Update_Items];
            }inView:self.HUDTargetView completion:^(){
                [self update_Items_On_Main_Thread];
            } cancel:^()
             {
                 [self update_Items_Will_Cancelled];
             }];
        }
        else
        {
            [self.HUD show_HUD:^(){
                [self perform_Update_Items];
            }inView:self.HUDTargetView completion:^(){
                [self update_Items_On_Main_Thread];
            }];
        }
    }
}

@end
