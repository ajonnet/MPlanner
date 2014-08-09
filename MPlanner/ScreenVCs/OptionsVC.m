//
//  OptionsVC.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "OptionsVC.h"
#import "OptionInputV.h"

@interface OptionsVC () <UITableViewDelegate, UITableViewDataSource,OptionInputVDelegate>
{
    NSMutableArray *options;
}

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@end

@implementation OptionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Initializing Options array
    options = [NSMutableArray array];
    [options addObject:[[Option alloc] init]];
    [options addObject:[[Option alloc] init]];
}

#pragma mark - IBAction methods
- (IBAction)onAddOptionBtClick:(id)sender {
    [options addObject:[[Option alloc] init]];
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
        for (Option *opt in options) {

            opt.mTitle = [opt.mTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (opt.mTitle.length == 0) {
                [self showErrorWithMsg:@"Title is reuqired for option"];
                return NO;
            }
        }
        
        //At least two should be there
        if (options.count < 2) {
            [self showErrorWithMsg:@"At Least two option should be specified"];
            return NO;
        }
        
        //ALL GOOD
        //Update the Mission object
        self.mMission.mOptions = options;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static float height;
    static BOOL heightDefined;
    
    //Evaluating Height from instance of OptionInputV
    if (!heightDefined) {
        heightDefined = YES;
        UIView *v = [OptionInputV getInstance];
        height = v.frame.size.height;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"OptionInputVCell";
    
    //Loading the Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.clipsToBounds = YES;
        
        OptionInputV *optionInputV = [OptionInputV getInstance];
        optionInputV.tag = 99;
        optionInputV.delegate = self;
        [cell.contentView addSubview:optionInputV];
    }
    
    //Defining contents of Cell
    OptionInputV *v = (OptionInputV *)[cell viewWithTag:99];
    v.mOption = [options objectAtIndex:indexPath.row];
    v.mIdx = indexPath.row + 1;
    
    return cell;
}

#pragma mark - OptionInputVDelegate methods
-(void) removeCalledForOptionInputV:(OptionInputV *) obj
{
    [options removeObject:obj.mOption];
    [self.tableV reloadData];
    
}

@end
