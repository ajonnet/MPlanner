//
//  DetailsVC.m
//  MPlanner
//
//  Created by Amit Jain on 10/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *orderedOptions;
    NSArray *orderedCriterions;
}

//Scroll View
@property (weak, nonatomic) IBOutlet UIScrollView *scvw;
@property (weak, nonatomic) IBOutlet UIView *scvwContentV;

//Table View
@property (weak, nonatomic) IBOutlet UITableView *optionsTableV;
@property (weak, nonatomic) IBOutlet UITableView *criterionsTableV;
@end

@implementation DetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Ordered Options
    orderedOptions = [self.mMission.mOptions sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(Option *obj1, Option *obj2) {
        return [obj2.mRelativeWeight compare:obj1.mRelativeWeight];
    }];
    
    //Ordered Criterions
    orderedCriterions = [self.mMission.mCriterions sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(Criterion *obj1, Criterion *obj2) {
        return [obj2.mRelativeWeight compare:obj1.mRelativeWeight];
    }];
}

-(void) viewWillAppear:(BOOL)animated
{
    //Configuring ScrollView
    self.scvw.contentSize = self.scvwContentV.frame.size;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Options
    if (tableView == self.optionsTableV) {
        
        return orderedOptions.count;
    }
    
    //Criterions
    return orderedCriterions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Options
    if (tableView == self.optionsTableV) {
        
        NSString *cellIdentifier = @"OptionCell";
        
        //Loading the Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Defining contents of Cell
        Option *obj = [orderedOptions objectAtIndex:indexPath.row];
        //Title
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        lblTitle.text = [NSString stringWithFormat:@"%@",obj.mTitle];
        
        //Progress View
        UIView *prgV = [cell viewWithTag:2];
        float perVal = [obj.mRelativeWeight floatValue] / [obj.mMaxWeight floatValue];
        CGRect rect = prgV.frame;
        rect.size.width = cell.frame.size.width * perVal;
        prgV.frame = rect;
        
        //Percentage Lbl
        UILabel *lblPer = (UILabel *)[cell viewWithTag:3];
        lblPer.text = [NSString stringWithFormat:@"%0.2f/%0.2f",[obj.mRelativeWeight floatValue],[obj.mMaxWeight floatValue]];
        
        return cell;
    }
    
    //Criterions
    NSString *cellIdentifier = @"CriterionCell";
    
    //Loading the Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Defining contents of Cell
    Criterion *obj = [orderedCriterions objectAtIndex:indexPath.row];
    //Title
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    lblTitle.text = [NSString stringWithFormat:@"%@",obj.mTitle];
    
    //Progress View
    UIView *prgV = [cell viewWithTag:2];
    float perVal = [obj.mRelativeWeight floatValue] / [obj.mMaxWeight floatValue];
    CGRect rect = prgV.frame;
    rect.size.width = cell.frame.size.width * perVal;
    prgV.frame = rect;
    
    //Percentage Lbl
    UILabel *lblPer = (UILabel *)[cell viewWithTag:3];
    lblPer.text = [NSString stringWithFormat:@"%0.2f/%0.2f",[obj.mRelativeWeight floatValue],[obj.mMaxWeight floatValue]];
    
    return cell;
}

@end
