//
//  OrderInputV.m
//  MPlanner
//
//  Created by Amit Jain on 10/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "OrderInputV.h"

@interface OrderInputV ()

@property (weak, nonatomic) IBOutlet UILabel *lblCriteriaLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblCriteriaRight;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation OrderInputV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(OrderInputV *) getInstance
{
    OrderInputV *view = nil;
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"OrderInputV" owner:self options:nil];
    
    for (id obj in bundle) {
        if ([obj isKindOfClass:[OrderInputV class]]) {
            view = (OrderInputV *)obj;
        }
    }
    
    assert(view != nil);
    
    return view;
}

- (IBAction)onSliderValChanged:(UISlider *)sender {
    NSInteger val = lroundf(sender.value);
    
    //Update Orders Array
    [self.mOrders replaceObjectAtIndex:_mIdx withObject:@(val)];
    
    //Updating the slider to snap
    sender.value = val;
}

#pragma mark - Properties setters and getters
-(void)setMIdx:(NSUInteger)mIdx
{
    _mIdx = mIdx;
    
    //Rendering the index
    Criterion *leftCriterion = [self.mLeftCriterions objectAtIndex:mIdx];
    Criterion *rightCriterion = [self.mRightCriterions objectAtIndex:mIdx];
    NSNumber *order = [self.mOrders objectAtIndex:mIdx];
    self.lblCriteriaLeft.text = leftCriterion.mTitle;
    self.lblCriteriaRight.text = rightCriterion.mTitle;
    self.slider.value = [order integerValue];
}
@end
