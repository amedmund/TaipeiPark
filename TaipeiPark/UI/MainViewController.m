/**
 * \file 	MainViewController.m
 * \brief	Implement the main UI for the app.
 *  - 2017/04/12			edmundchen	File created.
 */

#import "MainViewController.h"
#import "AFNetworking.h"
#import "ParkInfoViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    NSMutableArray *_aryParkTitles;     // Used to group the park attractions
    BOOL _loaded;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToParkInfoView"])
    {
        ParkInfoViewController *vc = (ParkInfoViewController*)[segue destinationViewController];
        
        SectionEntry *entry = [self.aryItems objectAtIndex:self.indexPathSel.section];
        
        vc.indexAttraction = self.indexPathSel.row;
        vc.aryAttractions = entry.items;
    }
}

#pragma mark - BaseViewDataSource Functions

- (void)init_UI
{
    [super init_UI];
}

- (void)init_Navigation_Bar
{
    [super init_Navigation_Bar];
    
    self.title = @"台北市公園景點";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = CLR_MAJOR;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
}

- (BOOL)should_Show_Back_Button
{
    return NO;
}

- (BOOL)should_Show_Refresh_Button
{
    return YES;
}

- (BOOL)should_Update_Items_When_View_Appear
{
    return !_loaded;
}

- (void)perform_Update_Items
{
    dispatch_semaphore_t sep = dispatch_semaphore_create(0);
    __block NSArray *items = nil;
    
    // Call API to get park informations
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://data.taipei/opendata/datalist/apiAccess" parameters:@{@"scope": @"resourceAquire", @"rid": @"bf073841-c734-49bf-a97f-3757a6013812"} progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSDictionary *response = (NSDictionary*)responseObject;
        
        items = [[response objectForKey:@"result"] objectForKey:@"results"];

        dispatch_semaphore_signal(sep);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"[Get park info] error = %@", error.localizedFailureReason);
        
        dispatch_semaphore_signal(sep);
    }];
    
    dispatch_semaphore_wait(sep, DISPATCH_TIME_FOREVER);
    
    // Parse the items
    _aryParkTitles = [[NSMutableArray alloc] init];
    _aryItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in items)
    {
        NSString *parkName = [dic objectForKey:@"ParkName"];
        SectionEntry *entry = nil;
        
        NSUInteger index = [_aryParkTitles indexOfObject:parkName];
        
        if (NSNotFound == index) // Create new section entry
        {
            entry = [SectionEntry entry_With_Title:parkName];
            
            index = _aryItems.count;
            [_aryItems addObject:entry];
            [_aryParkTitles addObject:parkName];
        }
        else // Get the exist section entry;
        {
            entry = [_aryItems objectAtIndex:index];
        }
        
        // Add the item into the section entry
        [entry.items addObject:dic];
    }
}

- (void)update_Items_On_Main_Thread
{
    [super update_Items_On_Main_Thread];
    
    _loaded = YES;
}

#pragma mark - DataSource of the UITableView

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionEntry *entry = [self.aryItems objectAtIndex:indexPath.section];
    NSDictionary *dic = [entry.items objectAtIndex:indexPath.row];
    
    ECTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellParkAttraction"];
    
    // Set the data for the cell
    cell.labelTitle.text = [dic objectForKey:@"Name"];
    cell.labelSubtitle.text = [dic objectForKey:@"ParkName"];
    
    [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Image" default:@""]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    cell.labelDetail1.text = [dic objectForKey:@"Introduction"];
    cell.labelDetail1.numberOfLines = 0;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Delegate of the UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionEntry *entry = [self.aryItems objectAtIndex:indexPath.section];
    NSDictionary *dic = [entry.items objectAtIndex:indexPath.row];
    
    CGFloat width = tableView.frame.size.width - 90 - 35;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 21)];
    label.numberOfLines = 0;
    label.text = [dic objectForKey:@"Introduction"];
    label.font = [UIFont systemFontOfSize:12];
    
    [label sizeToFit];
    
    return 80 + label.frame.size.height + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"ToParkInfoView" sender:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    ECTableViewCell *myCell = (ECTableViewCell*)cell;
    
    myCell.labelTitle.font = [UIFont systemFontOfSize:17];
    myCell.labelSubtitle.font = [UIFont systemFontOfSize:14];
    myCell.labelSubtitle.textColor = [UIColor grayColor];
    myCell.labelDetail1.font = [UIFont systemFontOfSize:12];
    myCell.labelDetail1.textColor = [UIColor grayColor];
}

@end
