//
//  CriterionsVC.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "CriterionsVC.h"
#import "CriteriaInputV.h"

@interface CriterionsVC () <UITableViewDataSource,UITableViewDelegate,CriteriaInputVDelegate>
{
    NSMutableArray *criterions;
    NSMutableArray *optionRatings;
    
    NSArray *defaultOptionRatings;
}

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@end

@implementation CriterionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initializing Criterions array
    criterions = [NSMutableArray array];
    [criterions addObject:[[Criterion alloc] init]];
    [criterions addObject:[[Criterion alloc] init]];
    
    
    //Initializing default Option Ratings
    NSMutableArray *ratings = [[NSMutableArray alloc] init];
    for (int j=0; j<self.mMission.mOptions.count; j++) {
        [ratings addObject:@(0)];
    }
    defaultOptionRatings = [NSArray arrayWithArray:ratings];
    
    //Initializing OptionRatings
    optionRatings = [NSMutableArray array];
    for (int i =0; i<criterions.count; i++) {
        [optionRatings addObject:[defaultOptionRatings copy]];
    }
}

#pragma mark - IBAction methods
- (IBAction)onAddOptionBtClick:(id)sender {
    [criterions addObject:[[Criterion alloc] init]];
    [optionRatings addObject:[defaultOptionRatings copy]];
    
    [self.tableV reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return criterions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static float height;
    static BOOL heightDefined;
    
    //Evaluating Height from instance of OptionInputV
    if (!heightDefined) {
        heightDefined = YES;
        CriteriaInputV *v = [CriteriaInputV getInstance];
        v.mOptions = self.mMission.mOptions;
        height = v.frame.size.height;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CriterionInputVCell";
    
    //Loading the Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.clipsToBounds = YES;
        
        CriteriaInputV *criterionInputV = [CriteriaInputV getInstance];
        criterionInputV.tag = 99;
        criterionInputV.mOptions = self.mMission.mOptions;
        criterionInputV.delegate = self;
        [cell.contentView addSubview:criterionInputV];
    }
    
    //Defining contents of Cell
    CriteriaInputV *v = (CriteriaInputV *)[cell viewWithTag:99];
    v.mCriterion = [criterions objectAtIndex:indexPath.row];
    v.mRatings = [optionRatings objectAtIndex:indexPath.row];
    v.mIdx = indexPath.row + 1;
    
    return cell;
}

#pragma mark - CriteriaInputVDelegate methods
-(void) removeCalledForCriteriaInputV:(CriteriaInputV *) obj
{
    NSUInteger idx = [criterions indexOfObject:obj.mCriterion];
    [criterions removeObject:obj.mCriterion];
    [optionRatings removeObjectAtIndex:idx];
    [self.tableV reloadData];
}

@end
