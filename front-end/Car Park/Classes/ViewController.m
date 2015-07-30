//
//  ViewController.m
//  Car Park
//
//  Created by Ömer Emre Aslan on 30/07/15.
//  Copyright © 2015 Ömer Emre Aslan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) NSArray *filledSlots;
@property (nonatomic) NSInteger floor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.floor = 1;
}

- (NSDictionary *)settings
{
    if (!_settings)
        _settings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://oeaslan.com/node/settings"]] options:NSJSONReadingAllowFragments error:nil];
    return _settings;
}

- (NSArray *)filledSlots
{
    if (!_filledSlots) {
        NSDictionary *slotsDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://oeaslan.com/node/getfilledslots"]] options:NSJSONReadingAllowFragments error:nil];
        _filledSlots = [slotsDict objectForKey:@"slots"];
    }
    return _filledSlots;
}

#pragma mark - CollectionView Delegate and Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *slot = [self.settings objectForKey:@"slot"];
    return [slot intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"slotCell" forIndexPath:indexPath];
    if ([self isCellAvailable:indexPath :self.floor]) {
        [cell setBackgroundColor:[UIColor greenColor]];
    } else if ([self isCellOnMe:indexPath :self.floor]) {
        [cell setBackgroundColor:[UIColor blueColor]];
    } else {
        [cell setBackgroundColor:[UIColor redColor]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.collectionView.frame.size.width / 16, self.collectionView.bounds.size.height / 7);
    return size;
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.2;
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.collectionView.bounds.size.height / 7;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   
    
    [self reloadAvailability];
    
    if ([self isCellAvailable:indexPath :self.floor]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"test title"
                                              message:@"Test"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                    
                                       
                                       UIDevice *device = [UIDevice currentDevice];
                                       NSString *currentDeviceId = [[device identifierForVendor]UUIDString];
                                       NSString *slot = [NSString stringWithFormat:@"%d,%d",indexPath.row / 15, indexPath.row % 15];
                                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oeaslan.com/node/enter-car?deviceId=%@&slot=%@&floor=%ld",currentDeviceId, slot, (long)self.floor]]] options:NSJSONReadingAllowFragments error:nil];
                                       NSString *result = [dict objectForKey:@"message"];
                                       if ([result isEqualToString:@"success"]) {
                                           UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                                           [cell setBackgroundColor:[UIColor blueColor]];
                                       } else {
                                           
                                       }
                                       
                                       
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"test title"
                                              message:@"Test"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];

        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - TableView Delegate and Data source

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *floor = [self.settings objectForKey:@"floor"];
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"levelCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. floor",indexPath.row+1];
    return cell;
}

- (BOOL)isCellAvailable:(NSIndexPath *)indexPath :(NSInteger)floor
{
    //[self reloadAvailability];
    for (NSDictionary *slot in self.filledSlots) {
        NSString *slotStr = [slot objectForKey:@"slot"];
        NSString *slotForIndexPath = [NSString stringWithFormat:@"%d,%d",indexPath.row / 15, indexPath.row % 15];
        NSString *floorStr = [slot objectForKey:@"floor"];
        NSInteger floorForIndexPath = [floorStr intValue];
        if ([slotStr isEqualToString:slotForIndexPath] && floor == floorForIndexPath) {
            return NO;
        }
    }
    return YES;
    
}

- (BOOL)isCellOnMe:(NSIndexPath *)indexPath :(NSInteger)floor
{
    for (NSDictionary *slot in self.filledSlots) {
        NSString *slotStr = [slot objectForKey:@"slot"];
        NSString *slotForIndexPath = [NSString stringWithFormat:@"%d,%d",indexPath.row / 15, indexPath.row % 15];
        NSString *floorStr = [slot objectForKey:@"floor"];
        NSInteger floorForIndexPath = [floorStr intValue];
        
        UIDevice *device = [UIDevice currentDevice];
        NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
        
        NSString *deviceId = [slot objectForKey:@"deviceId"];
        
        BOOL isSameDevice = [deviceId isEqualToString:currentDeviceId];
        if ([slotStr isEqualToString:slotForIndexPath] && floor == floorForIndexPath && isSameDevice) {
            return YES;
        }
    }
    return NO;

}

- (void)reloadAvailability
{
    NSDictionary *slotsDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://oeaslan.com/node/getfilledslots"]] options:NSJSONReadingAllowFragments error:nil];
    self.filledSlots = [slotsDict objectForKey:@"slots"];
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.floor = indexPath.row+1;
    [self.collectionView reloadData];
}

@end
