/**
 * \file 	ParkInfoViewController.m
 * \brief	Show park info.
 *  - 2017/04/12			edmundchen	File created.
 */

#import "ParkInfoViewController.h"


// ECTableViewCell

@interface ECTableViewCell (_Extend_)

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

@implementation ECTableViewCell (_Extend_)

- (UICollectionView*)collectionView
{
    return (UICollectionView*)self.customView;
}

@end


// ECCollectionViewCell

@interface ECCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto;

@end

@implementation ECCollectionViewCell

@synthesize labelTitle;
@synthesize imgPhoto;

@end


// ParkInfoViewController

@interface ParkInfoViewController ()

@end

@implementation ParkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BaseViewDataSource Functions

- (BOOL)should_Skip_Update_Item_Loading
{
    return YES;
}

- (void)init_Navigation_Bar
{
    [super init_Navigation_Bar];
    
    self.title = @"景點資訊";
}

- (void)perform_Update_Items
{
    NSDictionary *dic = [self.aryAttractions objectAtIndex:self.indexAttraction];
    
    _aryItems = [[NSMutableArray alloc] init];
    
    NSString *imageURL = [dic objectForKey:@"Image" default:@""];
    
    if (0 < imageURL.length)
    {
        [_aryItems addObject:@{@"type": @(kECCellStyleCustom), @"identifier": @"CellImage", @"image": imageURL}];
    }
    
    [_aryItems addObject:@{@"type": @(kECCellStyleInfo), @"title": @"公園名稱", @"value": [dic objectForKey:@"ParkName"]}];
    [_aryItems addObject:@{@"type": @(kECCellStyleInfo), @"title": @"景點名稱", @"value": [dic objectForKey:@"Name"]}];
    [_aryItems addObject:@{@"type": @(kECCellStyleInfo), @"title": @"開放時間", @"value": [dic objectForKey:@"OpenTime"]}];
    [_aryItems addObject:@{@"type": @(kECCellStyleDefault), @"title": [dic objectForKey:@"Introduction"]}];
    
    if (1 < self.aryAttractions.count)
    {
        [_aryItems addObject:@{@"type": @(kECCellStyleCustom), @"identifier": @"CellOtherAttr", @"title": @"相關景點"}];
    }
}

- (void)update_Items_On_Main_Thread
{
    [super update_Items_On_Main_Thread];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - DataSource of the UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.aryItems objectAtIndex:indexPath.row];
    NSInteger cellType = [[dic objectForKey:@"type"] integerValue];
    ECTableViewCell *cell = nil;
    
    if (kECCellStyleCustom == cellType)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[dic objectForKey:@"identifier"]];
        
        if ([[dic objectForKey:@"identifier"] isEqualToString:@"CellImage"])
        {
            [cell.imgViewIcon setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image" default:@""]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
        else
        {
            cell.labelTitle.text = [dic objectForKey:@"title"];
            [cell.collectionView reloadData];
        }
    }
    else
    {
        cell = [ECTableViewCell tableView:tableView cellWithStyle:cellType];
        
        // Set the data for the cell
        cell.labelTitle.text = [dic objectForKey:@"title"];
        cell.labelTitle.numberOfLines = 0;
        
        if (cell.hasInfo)
            cell.labelDetail1.text = [dic objectForKey:@"value"];
    }

    return cell;
}

#pragma mark - Delegate of the UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.aryItems objectAtIndex:indexPath.row];
    NSInteger cellType = [[dic objectForKey:@"type"] integerValue];
    
    if (kECCellStyleCustom == cellType)
    {
        if ([[dic objectForKey:@"identifier"] isEqualToString:@"CellImage"])    // Image
            return tableView.frame.size.width * 0.75;
        else    // Other Atrractions
            return 170;
    }
    else if (kECCellStyleDefault == cellType) // Introduction
    {
        CGFloat width = tableView.frame.size.width - 30;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 21)];
        label.numberOfLines = 0;
        label.text = [dic objectForKey:@"title"];
        label.font = [UIFont systemFontOfSize:15];
        
        [label sizeToFit];
        
        return MAX(44, label.frame.size.height + 30);
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    ECTableViewCell *myCell = (ECTableViewCell*)cell;
    
    myCell.labelTitle.font = [UIFont systemFontOfSize:15];
    myCell.labelDetail1.font = [UIFont systemFontOfSize:14];
    myCell.labelDetail1.textColor = [UIColor grayColor];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.aryAttractions.count - 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellAttr" forIndexPath:indexPath];
    
    // Get the other attraction items except the current attraction.
    NSUInteger index = (self.indexAttraction <= indexPath.item) ? indexPath.item + 1 : indexPath.item;
    NSDictionary *dic = [self.aryAttractions objectAtIndex:index];
    
    [cell.imgPhoto setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Image" default:@""]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    cell.imgPhoto.clipsToBounds = YES;
    cell.labelTitle.text = [dic objectForKey:@"Name"];
    cell.labelTitle.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = (self.indexAttraction <= indexPath.item) ? indexPath.item + 1 : indexPath.item;
    self.indexAttraction = index;
    
    [self onRefresh];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
