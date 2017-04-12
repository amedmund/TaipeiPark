/**
 * \file 	ECBaseTableViewController.h
 * \brief	Define the general behavior or UI layout for each table view.
 *  - 2015/01/22			edmundchen	File created.
 */

#import "ECBaseTableViewController.h"

// ECBaseTableViewController

@interface ECBaseTableViewController () <ECTableViewCellDelegate>

@end

@implementation ECBaseTableViewController

@synthesize tableView = _tableView;
@synthesize indexPathSel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}

#pragma mark - Override Methods

- (void)onBack
{
    // Hide the keyboard
    [self.view endEditing:YES];
    
    [super onBack];
}

#pragma mark - DataSource of ECBaseViewController

- (void)init_UI
{
    [super init_UI];
    
    if (self.tableView)
    {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = IS_IPAD_DEVICE ? 50 : 44;
        
        // Make the table view not show the separator line in the empty area.
        self.tableView.tableFooterView = [[UIView alloc] init];
        
        // Disable the scroll behaivor if the content size is samll than the table view size.
        self.tableView.alwaysBounceVertical = (UITableViewStylePlain == self.tableView.style) ? YES : NO;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)update_Items_On_Main_Thread
{
    [super update_Items_On_Main_Thread];
    
    if (self.tableView)
    {
        [self.tableView reloadData];
    }
}

- (void)remove_TableView_Cell: (NSIndexPath*) indexPath withItems: (BOOL) removeItem
{
    if (nil != indexPath)
    {
        if (removeItem)
        {
            if (0 < [self.tableView numberOfSections] && [[self.aryItems firstObject] isKindOfClass:[SectionEntry class]])
            {
                SectionEntry *entry = [self.aryItems objectAtIndex:indexPath.section];
                [entry.items removeObjectAtIndex:indexPath.row];
            }
            else
            {
                // Remove the indicate item from self.curItems
                [_aryItems removeObjectAtIndex:indexPath.row];
            }
        }
        
        [self.tableView beginUpdates];
        
        // Remove the cell from table view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
    }
}

#pragma mark - DataSource of the UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SectionEntry *entry = [self.aryItems objectAtIndex:section];
    return entry.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionEntry *entry = [self.aryItems objectAtIndex:section];
    return entry.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.aryItems.count;
}

#pragma mark - Delegate of the UITableView

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return (UITableViewCellSelectionStyleNone == cell.selectionStyle) ? nil : indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathSel = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Keyboard Handler

- (void)_keyboardDidHide:(NSNotification*)aNotification
{
}

@end
