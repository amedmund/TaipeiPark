/**
 * \file 	ECTableViewUtilities.h
 * \brief	Define the relative class used for ECBaseTableViewController
 *  - 2015/05/07			edmundchen	File created.
 */

#import <Foundation/Foundation.h>

#pragma mark - SectionEntry

/**
 *  The class used to store the items and informations for each section in the table view.
 */
@interface SectionEntry : NSObject

/// The title of the section, used to show on the header.
@property (nonatomic, copy) NSString *title;

/// The description of the section, used to show on the footer.
@property (nonatomic, copy) NSString *description;

/// The items for each cell in the section.
@property (nonatomic, strong) NSMutableArray *items;

/// The identifier of the section entry
@property (nonatomic, assign) NSInteger identifier;

+ (SectionEntry*)entry_With_Title: (NSString*) title;

+ (SectionEntry*)entry_With_Title: (NSString*) title andIdentifier: (NSInteger) identifier;

@end

#pragma mark - ECTableViewCell

@class ECTableViewCell;

/**
 *  Define the standard cell style
 */
typedef NS_ENUM(NSInteger, ECTableViewCellStyle)
{
    kECCellStyleCustom,
    
    /// Simple cell with only a labelTitle in the left side.
    kECCellStyleDefault,
    
    /// labelTitle in the left side with accessoryType UITableViewCellAccessoryDisclosureIndicator
    kECCellStyleAction,
    
    /// labelTitle in the left side and labelDetail1 in the right side.
    kECCellStyleInfo,
    
    /// labelTitle in the left side, labelDetail1 in the right side with accessoryType UITableViewCellAccessoryDisclosureIndicator.
    kECCellStyleInfoWithAction,
    
    /// TextFiled with labeTitle in the left side.
    kECCellStyleInput,
    
    /// TextFiled with labeTitle in the left side and use secure mode.
    kECCellStyleSecureInput,
    
    /// labelTitle in the left side with accessoryType UITableViewCellAccessoryCheckmark
    kECCellStyleSelection,
    
    /// labelTitle in the left side and btnSwitch in the right side.
    kECCellStyleSwitch,
    
    /// labelTitle in the left top side and labelSubtitle in the left bottom side.
    kECCellStyleSubtitle,
    
    /// labelTitle in the left top side and labelSubtitle in the left bottom side with accessoryType UITableViewCellAccessoryDisclosureIndicator.
    kECCellStyleSubtitleWithAction,
    
    /// labelTitle in the left top side, labelSubtitle in the left bottom side and labelDetail1 in the right side with accessoryType UITableViewCellAccessoryDisclosureIndicator.
    kECCellStyleSubtitleWithInfoAndAction,
    
    /// TextFiled with labelTitle in the left top side and labelSubtitle in the left bottom side.
    kECCellStyleSubtitleWithInput,
    
    /// TextFiled with labelTitle in the left top side and labelSubtitle in the left bottom side. Use secure mode.
    kECCellStyleSubtitleWithSecureInput,
    
    /// labelTitle in the left top side and labelSubtitle in the left bottom side with accessoryType UITableViewCellAccessoryCheckmark
    kECCellStyleSubtitleWithSelection,
    
    /// Display the UIDatePicker
    kECCellStyleDatePicker,
};

@protocol ECTableViewCellDelegate <NSObject>

@optional

- (void)tableViewCell: (ECTableViewCell*) cell didSwipeGesture: (UISwipeGestureRecognizer*) gesture;

@end

/**
 *  The custom cell with many UI component properties, easy to customize the tableview in storyboard.
 */
@interface ECTableViewCell : UITableViewCell

// Button
@property (nonatomic, strong) IBOutlet UIButton *button1;
@property (nonatomic, strong) IBOutlet UIButton *button2;
@property (nonatomic, strong) IBOutlet UIButton *button3;
@property (nonatomic, strong) IBOutlet UIButton *button4;
@property (nonatomic, strong) IBOutlet UISwitch *btnSwitch;

// Text
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDetail1;
@property (nonatomic, strong) IBOutlet UILabel *labelDetail2;
@property (nonatomic, strong) IBOutlet UILabel *labelDetail3;
@property (nonatomic, strong) IBOutlet UITextField *editInput;
@property (nonatomic, strong) IBOutlet UITextView *textView;

// Image
@property (nonatomic, strong) IBOutlet UIImageView *imgViewIcon;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewMark;

// View
@property (nonatomic, strong) IBOutlet UIView *customView;
@property (nonatomic, strong) IBOutlet UIView *customView2;
@property (nonatomic, strong) IBOutlet UIView *customView3;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

/// The cell style, default is kECCellStyleCustom.
@property (nonatomic, assign, readonly) ECTableViewCellStyle style;

/// The cell attribute according to the style
@property (nonatomic, assign, readonly) BOOL hasSubtitle;

/// The cell attribute according to the style
@property (nonatomic, assign, readonly) BOOL hasInfo;

/// The cell attribute according to the style
@property (nonatomic, assign, readonly) BOOL hasInput;

/// The cell attribute according to the style
@property (nonatomic, assign, readonly) BOOL withAction;

/// The cell attribute according to the style
@property (nonatomic, assign, readonly) BOOL withSelection;

/// The delegate of the ECTableViewCell
@property (nonatomic, weak) id<ECTableViewCellDelegate> delegate;

/**
 * \brief	Generate the custom tableview cell by specific style
 * \param   style   The cell style
 * \return  Return the ECTableViewCell instance. Return nil if the cell style is not matched.
 */
+(ECTableViewCell*) tableView: (UITableView*) tableView cellWithStyle: (enum ECTableViewCellStyle) style;

+(ECTableViewCell*) tableView: (UITableView*) tableView cellWithStyle: (enum ECTableViewCellStyle) style scale: (CGFloat) scale;

/**
 *  Set the image icon to imgViewIcon property and adjust the UI layout if the cell is one of the ECTableViewCellStyle, except kECCellStyleCustom.
 */
- (void)Set_Image_Icon: (UIImage*) icon;

- (void)Set_Image_Icon: (UIImage*) icon withSize: (CGSize) size;

- (void)Set_Image_Icon_Color: (UIColor*) color;

/**
 *  Set the custom check icon. Set the accessoryType to UITableViewCellAccessoryCheckmark to show check mark.
 */
- (void)Set_Check_Icon: (UIImage*) checkImage;

- (void)Set_Check_Icon_Color: (UIColor*) color;

/**
 *  Set the custom indicator icon. Set the accessoryType to UITableViewCellAccessoryDisclosureIndicator to show indicator.
 */
- (void)Set_Indicator_Icon: (UIImage*) indicatorImage;

- (void)Set_Indicator_Icon_Color: (UIColor*) color;

@end
