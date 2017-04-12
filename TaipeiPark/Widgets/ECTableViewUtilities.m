/**
 * \file 	ECTableViewUtilities.m
 * \brief	Define the relative class used for ECBaseTableViewController
 *  - 2015/05/07			edmundchen	File created.
 */

#import "ECTableViewUtilities.h"
#import "Masonry.h"

#pragma mark - SectionEntry

@implementation SectionEntry
{
    NSMutableArray *_items;
}

@synthesize title;
@synthesize description;
@synthesize items = _items;
@synthesize identifier;

- (id)init
{
    if (self = [super init]) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (SectionEntry*)entry_With_Title: (NSString*) title
{
    SectionEntry *entry = [[SectionEntry alloc] init];
    entry.title = title;
    
    return entry;
}

+ (SectionEntry*)entry_With_Title: (NSString*) title andIdentifier: (NSInteger) identifier
{
    SectionEntry *entry = [[SectionEntry alloc] init];
    entry.title = title;
    entry.identifier = identifier;
    
    return entry;
}

@end

#pragma mark - ECTableViewCell

/**
 *  Custom UITextField to show the multiple line text in left side of the UITextField.
 */
@interface MyTextField : UITextField

@end

@implementation MyTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, self.leftView.frame.size.width, bounds.size.height);
}

// Workaround since the leftView has no sending event.
// Get the superview of the leftView of UITextField
- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([[super hitTest:point withEvent:event] isEqual:self.leftView]) {
            return self;
    }
    
    return [super hitTest:point withEvent:event];
}

@end

@interface ECTableViewCell ()

@property (nonatomic, assign) ECTableViewCellStyle style;

@end

@implementation ECTableViewCell
{
    UILabel *_labelTitle;
    UILabel *_labelSubtitle;
    UILabel *_labelDetail1;
    UILabel *_labelDetail2;
    UILabel *_labelDetail3;
    
    UIImageView *_checkView;
    UIImageView *_indicatorView;
}

@synthesize labelTitle = _labelTitle;
@synthesize labelSubtitle = _labelSubtitle;
@synthesize labelDetail1 = _labelDetail1;
@synthesize labelDetail2 = _labelDetail2;
@synthesize labelDetail3 = _labelDetail3;

+ (NSString*)_get_Cell_Style_Identifier: (ECTableViewCellStyle) style
{
    static NSMutableDictionary *_dicCellStyles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dicCellStyles = [[NSMutableDictionary alloc] init];
        _dicCellStyles[@(kECCellStyleDefault)] = @"kECCellStyleDefault";
        _dicCellStyles[@(kECCellStyleSubtitle)] = @"kECCellStyleSubtitle";
        _dicCellStyles[@(kECCellStyleSubtitleWithAction)] = @"kECCellStyleSubtitleWithAction";
        _dicCellStyles[@(kECCellStyleInput)] = @"kECCellStyleInput";
        _dicCellStyles[@(kECCellStyleSecureInput)] = @"kECCellStyleSecureInput";
        _dicCellStyles[@(kECCellStyleSelection)] = @"kECCellStyleSelection";
        _dicCellStyles[@(kECCellStyleAction)] = @"kECCellStyleAction";
        _dicCellStyles[@(kECCellStyleSwitch)] = @"kECCellStyleSwitch";
        _dicCellStyles[@(kECCellStyleInfo)] = @"kECCellStyleInfo";
        _dicCellStyles[@(kECCellStyleInfoWithAction)] = @"kECCellStyleInfoWithAction";
        _dicCellStyles[@(kECCellStyleSubtitleWithInfoAndAction)] = @"kECCellStyleSubtitleWithInfoAndAction";
        _dicCellStyles[@(kECCellStyleSubtitleWithSelection)] = @"kECCellStyleSubtitleWithSelection";
        _dicCellStyles[@(kECCellStyleSubtitleWithInput)] = @"kECCellStyleSubtitleWithInput";
        _dicCellStyles[@(kECCellStyleSubtitleWithSecureInput)] = @"kECCellStyleSubtitleWithSecureInput";
        _dicCellStyles[@(kECCellStyleDatePicker)] = @"kECCellStyleDatePicker";
    });
    
    return [_dicCellStyles objectForKey:@(style)];
}

- (BOOL)hasSubtitle
{
    return [@[@(kECCellStyleSubtitle), @(kECCellStyleSubtitleWithAction), @(kECCellStyleSubtitleWithInfoAndAction), @(kECCellStyleSubtitleWithSelection), @(kECCellStyleSubtitleWithInput), @(kECCellStyleSubtitleWithSecureInput)] containsObject:@(self.style)];
}

- (BOOL)hasInfo
{
    return [@[@(kECCellStyleSubtitleWithInfoAndAction), @(kECCellStyleInfo), @(kECCellStyleInfoWithAction)] containsObject:@(self.style)];
}

- (BOOL)hasInput
{
    return [@[@(kECCellStyleSecureInput), @(kECCellStyleInput), @(kECCellStyleSubtitleWithInput), @(kECCellStyleSubtitleWithSecureInput)] containsObject:@(self.style)];
}

- (BOOL)withAction
{
    return [@[@(kECCellStyleSubtitleWithAction), @(kECCellStyleSubtitleWithInfoAndAction), @(kECCellStyleAction), @(kECCellStyleInfoWithAction)] containsObject:@(self.style)];
}

- (BOOL)withSelection
{
    return [@[@(kECCellStyleSelection), @(kECCellStyleSubtitleWithSelection)] containsObject:@(self.style)];
}

+(ECTableViewCell*) tableView: (UITableView*) tableView cellWithStyle: (enum ECTableViewCellStyle) style
{
    return [self tableView:tableView cellWithStyle:style scale: 0.4];
}

+(ECTableViewCell*) tableView: (UITableView*) tableView cellWithStyle: (enum ECTableViewCellStyle) style scale: (CGFloat) scale;
{
    ECTableViewCell *cell = nil;
    NSString *identifier = [ECTableViewCell _get_Cell_Style_Identifier:style];
    
    if (!identifier || 0 == identifier.length)
        return nil;
        
    // Try to get the cell by reused identifier.
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Create a new cell if needed.
    if (nil == cell)
    {
        // Base value
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 15, 10, 15);
        
        cell = [[ECTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.style = style;
        
        // Setup the default value
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (kECCellStyleDatePicker == cell.style)
        {
            cell.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 216)];
            cell.datePicker.date = [NSDate date];
            
            cell.datePicker.timeZone = [NSTimeZone systemTimeZone];
            cell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            
            [cell.contentView addSubview:cell.datePicker];
        }
        else if (cell.hasInput)
        {
            // Setup the left view
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (cell.contentView.frame.size.width*scale), 0)];
            
            cell.labelTitle = [[UILabel alloc] init];
            [view addSubview:cell.labelTitle];
            
            [cell.labelTitle mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(view);
                make.top.equalTo(view).offset(padding.top);
                make.right.equalTo(view).offset(-padding.right);
                make.bottom.equalTo(view).offset(-padding.bottom);
            }];
            
            if (cell.hasSubtitle)
            {
                cell.labelSubtitle = [[UILabel alloc] init];
                [view addSubview:cell.labelSubtitle];
                
                [cell.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(view);
                    make.bottom.equalTo(view.mas_centerY).offset(2);
                    make.right.equalTo(view).offset(-padding.right);
                }];
                
                [cell.labelSubtitle mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(cell.labelTitle.mas_left);
                    make.top.equalTo(view.mas_centerY);
                    make.right.equalTo(cell.labelTitle.mas_right);
                }];
            }
        
            // Setup the input
            cell.editInput = [[MyTextField alloc] init];
            cell.editInput.textAlignment = NSTextAlignmentRight;
            cell.editInput.leftView = view;
            cell.editInput.leftViewMode = UITextFieldViewModeAlways;
            cell.editInput.autocorrectionType = UITextAutocorrectionTypeNo;
            
            if (kECCellStyleSecureInput == style || kECCellStyleSubtitleWithSecureInput == style)
                cell.editInput.secureTextEntry = YES;
            
            [cell.contentView addSubview:cell.editInput];
            
            [cell.editInput mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(cell.contentView).offset(padding.left);
                make.top.equalTo(cell.contentView).offset(0);
                make.right.equalTo(cell.contentView).offset(-padding.right);
                make.bottom.equalTo(cell.contentView).offset(0);
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            // Setup the title
            cell.labelTitle = [[UILabel alloc] init];
            [cell.contentView addSubview:cell.labelTitle];
            
            [cell.labelTitle mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(cell.contentView).offset(padding.left);
                make.top.equalTo(cell.contentView).offset(padding.top);
                make.right.equalTo(cell.contentView).offset(-padding.right);
                make.bottom.equalTo(cell.contentView).offset(-padding.bottom);
            }];
            
            // Add the subview according to the cell style.
            switch (style)
            {
                case kECCellStyleSwitch:
                {
                    [cell.labelTitle mas_updateConstraints:^(MASConstraintMaker *make){
                        make.right.equalTo(cell.contentView).offset(-80);
                    }];
                    
                    cell.btnSwitch = [[UISwitch alloc] init];
                    [cell.contentView addSubview:cell.btnSwitch];
                    [cell.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make){
                        make.left.equalTo(cell.labelTitle.mas_right).offset(padding.left);
                        make.centerY.equalTo(cell.labelTitle.mas_centerY);
                    }];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                default:
                {
                    // Setup the subtitle
                    if (cell.hasSubtitle)
                    {
                        cell.labelSubtitle = [[UILabel alloc] init];
                        [cell.contentView addSubview:cell.labelSubtitle];
                        
                        // Adjust title layout
                        [cell.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make){
                            make.left.equalTo(cell.contentView).offset(padding.left);
                            make.bottom.equalTo(cell.contentView.mas_centerY);
                            make.right.equalTo(cell.contentView).offset(-padding.right);
                        }];
                        
                        [cell.labelSubtitle mas_makeConstraints:^(MASConstraintMaker *make){
                            make.left.equalTo(cell.labelTitle.mas_left);
                            make.top.equalTo(cell.contentView.mas_centerY).offset(2);
                            make.right.equalTo(cell.labelTitle.mas_right);
                        }];
                    }
                    
                    // Setup the Info
                    if (cell.hasInfo)
                    {
                        cell.labelDetail1 = [[UILabel alloc] init];
                        cell.labelDetail1.textAlignment = NSTextAlignmentRight;
                        [cell.contentView addSubview:cell.labelDetail1];
                        
                        [cell.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make){
                            make.left.equalTo(cell.contentView).offset(padding.left);
                            
                            if (cell.hasSubtitle)
                            {
                                make.bottom.equalTo(cell.contentView.mas_centerY);
                            }
                            else
                            {
                                make.top.equalTo(cell.contentView).offset(padding.top);
                                make.bottom.equalTo(cell.contentView).offset(-padding.bottom);
                            }
                            make.width.equalTo(cell.contentView).multipliedBy(scale);
                        }];
                        
                        [cell.labelDetail1 mas_makeConstraints:^(MASConstraintMaker *make){
                            make.left.equalTo(cell.labelTitle.mas_right).offset(padding.left);
                            make.right.equalTo(cell.contentView).offset(-padding.right);
                            make.top.equalTo(cell.contentView).offset(padding.top);
                            make.bottom.equalTo(cell.contentView).offset(-padding.bottom);
                        }];
                    }
                    
                    if (cell.withAction || cell.withSelection)
                    {
                        if (cell.hasInfo)
                        {
                            [cell.labelDetail1 mas_updateConstraints:^(MASConstraintMaker *make){
                                make.right.equalTo(cell.contentView).offset(-5);
                            }];
                        }
                        else
                        {
                            [cell.labelTitle mas_updateConstraints:^(MASConstraintMaker *make){
                                make.right.equalTo(cell.contentView).offset(-5);
                            }];
                        }
                        
                        if (cell.withAction)
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    break;
                }
            }
        }
    }
    
    return cell;
}

- (void)Set_Image_Icon:(UIImage *)icon
{
    [self Set_Image_Icon:icon withSize:icon.size];
}

- (void)Set_Image_Icon: (UIImage*) icon withSize: (CGSize) size
{
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 15, 10, 15);
    
    switch (self.style)
    {
        case kECCellStyleInput:
        case kECCellStyleSecureInput:
        {
            self.labelTitle = nil;
            self.labelSubtitle = nil;
            
            self.imgViewIcon = [[UIImageView alloc] initWithImage:icon];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + padding.left, size.height)];
            [view addSubview:self.imgViewIcon];
            
            [self.imgViewIcon mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(view);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(size);
            }];
            
            self.editInput.leftView = view;
            
            break;
        }
        case kECCellStyleDatePicker:   // Do nothing
        {
            break;
        }
        default:
        {
            if (self.imgViewIcon)
                [self.imgViewIcon removeFromSuperview];
            
            self.imgViewIcon = [[UIImageView alloc] initWithImage:icon];
            [self.contentView addSubview:self.imgViewIcon];
            
            [self.imgViewIcon mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.contentView).offset(padding.left);
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(size);
            }];
            
            // Adjust title layout
            [self.labelTitle mas_updateConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.contentView).offset(padding.left*2 + size.width);
            }];
            
            break;
        }
    }
}

- (void)Set_Image_Icon_Color: (UIColor*) color
{
    if (self.imgViewIcon)
    {
        UIImage *img = [self.imgViewIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imgViewIcon.image = img;
        self.imgViewIcon.tintColor = color;
    }
}

- (void)Set_Check_Icon: (UIImage*) checkImage;
{
    if (checkImage)
    {
        _checkView = [[UIImageView alloc] initWithImage:checkImage];
        
        if (self.withSelection && UITableViewCellAccessoryCheckmark == self.accessoryType)
            self.accessoryView = _checkView;
    }
}

- (void)Set_Check_Icon_Color: (UIColor*) color
{
    if (_checkView)
    {
        UIImage *img = [_checkView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _checkView.image = img;
        _checkView.tintColor = color;
    }
}

- (void)Set_Indicator_Icon: (UIImage*) indicatorImage
{
    if (indicatorImage)
    {
        _indicatorView = [[UIImageView alloc] initWithImage:indicatorImage];
        
        if (self.withAction && UITableViewCellAccessoryDisclosureIndicator == self.accessoryType)
            self.accessoryView = _indicatorView;
    }
}

- (void)Set_Indicator_Icon_Color: (UIColor*) color
{
    if (_indicatorView)
    {
        UIImage *img = [_indicatorView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _indicatorView.image = img;
        _indicatorView.tintColor = color;
    }
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    
    if (_checkView && self.withSelection)
    {
        self.accessoryView = (UITableViewCellAccessoryCheckmark == accessoryType) ? _checkView : nil;
    }
    else if (_indicatorView && self.withAction)
    {
        self.accessoryView = (UITableViewCellAccessoryDisclosureIndicator == accessoryType) ? _indicatorView : nil;
    }
}

@end
