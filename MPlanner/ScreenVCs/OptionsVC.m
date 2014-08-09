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
