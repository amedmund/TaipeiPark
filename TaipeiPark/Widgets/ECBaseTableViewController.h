/**
 * \file 	ECBaseTableViewController.h
 * \brief	Define the general behavior or UI layout for each table view.
 *  - 2015/01/22			edmundchen	File created.
 */

#import "ECBaseViewController.h"
#import "ECTableViewUtilities.h"

/**
 *  The custom table view controller.
 */
@interface ECBaseTableViewController : ECBaseViewController <UITableViewDataSource, UITableViewDelegate>

/// The customized table view
@property(nonatomic, strong, readwrite) IBOutlet UITableView *tableView;

/// The selected indexPath.
@property (nonatomic, strong) NSIndexPath* indexPathSel;

/*
 *  Delete the tableview cell with animation
 *
 *  @param  indexPath       The index of the cell that want to delete
 *  @param  removeItem      If also delete the item in self.aryItems
 */
- (void)remove_TableView_Cell: (NSIndexPath*) indexPath withItems: (BOOL) removeItem;

@end

