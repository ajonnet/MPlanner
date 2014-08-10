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
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        lblTitle.text = [NSString stringWithFormat:@"%d",indexPath.row];
        
        return cell;
    }
    
    //Criterions
    NSString *cellIdentifier = @"CriterionCell";
    
    //Loading the Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Defining contents of Cell
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    lblTitle.text = [NSString stringWithFormat:@"%d+",indexPath.row];
    
    return cell;
}

@end
