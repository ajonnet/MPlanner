//
//  OptionRatingInputV.m
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "OptionRatingInputV.h"

@interface OptionRatingInputV ()

@property (weak, nonatomic) IBOutlet UILabel *lblOptionTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UISlider *sliderRating;
@end

@implementation OptionRatingInputV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(OptionRatingInputV *) getInstance
{
    OptionRatingInputV *view = nil;
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"OptionRatingInputV" owner:self options:nil];
    
    for (id obj in bundle) {
        if ([obj isKindOfClass:[OptionRatingInputV class]]) {
            view = (OptionRatingInputV *)obj;
        }
    }
    
    assert(view != nil);
    
    return view;
}

#pragma mark - IBAction methods
- (IBAction)sliderValChanged:(UISlider *)sender {
    
    NSUInteger val = (NSUInteger)roundf(sender.value);
    
    _mRating = val;
    
    //Updating the Rating Lbl
    self.lblRating.text = [NSString stringWithFormat:@"%d",val];
    
    //Notify the delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(ratingChangedForOptionRatingInputV:)]) {
        [self.delegate ratingChangedForOptionRatingInputV:self];
    }
}

#pragma mark - Properties setters and getters
-(void)setMOption:(Option *)mOption
{
    _mOption = mOption;
    
    //Updating the Option Title
    self.lblOptionTitle.text = mOption.mTitle;
}

-(void)setMRating:(NSUInteger)mRating
{
    NSUInteger val = (NSUInteger)roundf(mRating);
    
    _mRating = val;
    
    //Update the slider value
    self.sliderRating.value = val;
    
    //Updating the Rating Lbl
    self.lblRating.text = [NSString stringWithFormat:@"%d",val];
}

#pragma mark - private methods
-(void) baseInit
{
    self.sliderRating.continuous = YES;
}

@end
