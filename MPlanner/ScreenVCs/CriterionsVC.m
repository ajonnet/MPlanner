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
    
    NSMutableArray *defaultOptionRatings;
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
    defaultOptionRatings = ratings;
    
    
    //Initializing OptionRatings
    optionRatings = [NSMutableArray array];
    for (int i =0; i<criterions.count; i++) {
        [optionRatings addObject:[defaultOptionRatings mutableCopy]];
    }
}

#pragma mark - IBAction methods
- (IBAction)onAddOptionBtClick:(id)sender {
    [criterions addObject:[[Criterion alloc] init]];
    [optionRatings addObject:[defaultOptionRatings mutableCopy]];
    
    [self.tableV reloadData];
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
        
        //No Option should be with empty title
        for (Criterion *crtn in criterions) {
            
            crtn.mTitle = [crtn.mTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (crtn.mTitle.length == 0) {
                [self showErrorWithMsg:@"Title is reuqired for Criterion"];
                return NO;
            }
        }
        
        //ALL GOOD
        //Add the Criterions
        self.mMission.mCriterions = criterions;
        
        //Setting rating for each option for each criterion
        for (int i =0; i < criterions.count; i++) {
            
            Criterion *crtnObj = [criterions objectAtIndex:i];
            for (int j=0; j< self.mMission.mOptions.count; j++) {
                
                Option *optObj = [self.mMission.mOptions objectAtIndex:j];
                NSNumber *rating = optionRatings[i][j];;
            
                [self.mMission setRating:rating ofCriterion:crtnObj forOption:optObj];
                //NSNumber *obj = [self.mMission getRatingOfCriterion:crtnObj forOption:optObj];
                //NSLog(@"%@-> %@-> %@,%@",crtnObj,optObj,rating,obj);
                
            }
        }
    }
    
    return YES;
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
