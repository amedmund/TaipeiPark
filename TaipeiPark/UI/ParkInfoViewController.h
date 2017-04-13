/**
 * \file 	ParkInfoViewController.h
 * \brief	Show park info.
 *  - 2017/04/12			edmundchen	File created.
 */

#import "ECBaseTableViewController.h"

@interface ParkInfoViewController : ECBaseTableViewController

@property (nonatomic, strong) NSArray *aryAttractions;
@property (nonatomic, assign) NSUInteger indexAttraction;

@end
