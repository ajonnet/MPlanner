//
//  PrioritizeVC.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "PrioritizeVC.h"
#import "OrderInputV.h"

@interface PrioritizeVC ()
{
    NSMutableArray *LeftCriterions;
    NSMutableArray *RightCriterions;
    NSMutableArray *OrderSet;
}

@end

@implementation PrioritizeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Initialize Sets for Criterions Order
    LeftCriterions = [NSMutableArray array];
    RightCriterions = [NSMutableArray array];
    OrderSet = [NSMutableArray array];
    for (int i=0; i<self.mMission.mCriterions.count; i++) {
        for (int j=i+1; j< self.mMission.mCriterions.count; j++) {
            [LeftCriterions addObject:self.mMission.mCriterions[i]];
            [RightCriterions addObject:self.mMission.mCriterions[j]];
            [OrderSet addObject:[NSNumber numberWithInt:NSOrderedSame]];
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:NextBtId]) {
        CustomVC *vc = [segue destinationViewController];
        vc.mMission = self.mMission;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:NextBtId]) {
        
        //ALL GOOD
        //Add the Orders
        for (int i =0; i< OrderSet.count; i++) {
            NSComparisonResult order = [OrderSet[i] integerValue];
            [self.mMission setOrder:order
                      forCriterionA:LeftCriterions[i]
                      andCriterionB:RightCriterions[i]];
            
            //NSComparisonResult order2 = [self.mMission getOrderBtwCriterionA:LeftCriterions[i] andCriterionB:RightCriterions[i]];
            //NSLog(@"[%d,%d]->%@, %@",order,order2,LeftCriterions[i],RightCriterions[i]);
        }
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return OrderSet.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static float height;
    static BOOL heightDefined;
    
    //Evaluating Height from instance of OptionInputV
    if (!heightDefined) {
        heightDefined = YES;
        OrderInputV *v = [OrderInputV getInstance];
        height = v.frame.size.height;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OrderInputVCell";
    
    //Loading the Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.clipsToBounds = YES;
        
        OrderInputV *orderInputV = [OrderInputV getInstance];
        orderInputV.tag = 99;
        orderInputV.mLeftCriterions = LeftCriterions;
        orderInputV.mRightCriterions = RightCriterions;
        orderInputV.mOrders = OrderSet;
        [cell.contentView addSubview:orderInputV];
    }
    
    //Defining contents of Cell
    OrderInputV *v = (OrderInputV *)[cell viewWithTag:99];
    v.mIdx = indexPath.row;
    
    return cell;
}


@end
