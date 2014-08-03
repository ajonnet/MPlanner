//
//  CriteriaInputV.m
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "CriteriaInputV.h"
#import "OptionRatingInputV.h"

@interface CriteriaInputV ()
{
    NSArray *optionRatingVArray;
}

@property (weak, nonatomic) IBOutlet UILabel *lblCriteriaIdx;
@property (weak, nonatomic) IBOutlet UITextField *tfCrtieriaTitle;
@property (weak, nonatomic) IBOutlet UIView *OptionsRatingPlaceHolderV;

@end

@implementation CriteriaInputV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(CriteriaInputV *) getInstance
{
    CriteriaInputV *view = nil;
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"CriteriaInputV" owner:self options:nil];
    
    for (id obj in bundle) {
        if ([obj isKindOfClass:[CriteriaInputV class]]) {
            view = (CriteriaInputV *)obj;
        }
    }
    
    assert(view != nil);
    
    return view;
}

#pragma mark - IBAction methods
- (IBAction)onRemoveBtClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeCalledForCriteriaInputV:)]) {
        [self.delegate removeCalledForCriteriaInputV:self];
    }
}

#pragma mark - Properties Setters and Getters
-(void)setMCriterion:(Criterion *)mCriterion
{
    _mCriterion = mCriterion;
    
    //Updating Criteria Title
    self.tfCrtieriaTitle.text = mCriterion.mTitle;
}

-(void)setMIdx:(NSUInteger)mIdx
{
    _mIdx = mIdx;
    
    //Updating Idx Label
    self.lblCriteriaIdx.text = [NSString stringWithFormat:@"%d",mIdx];
}

-(void)setMOptions:(NSArray *)mOptions
{
    _mOptions = mOptions;
    
    //Add views for various Options
    [self renderViewForOptions:mOptions];
}

-(void)setMRatings:(NSArray *)mRatings
{
    //Update ratings for various Option Items
    for (int i =0; i< mRatings.count; i++) {
        NSNumber *rating = [mRatings objectAtIndex:i];
        OptionRatingInputV *v = [optionRatingVArray objectAtIndex:i];
        v.mRating = [rating integerValue];
    }
}

-(NSArray *)mRatings
{
    NSMutableArray *ratingsArray = [NSMutableArray array];
    
    //Getting value of ratings from various optionRatingInputV
    for (int i =0; i< optionRatingVArray.count; i++) {
        OptionRatingInputV *v = [optionRatingVArray objectAtIndex:i];
        [ratingsArray addObject:@(v.mRating)];
    }
    
    return ratingsArray;
}


#pragma mark - Private methods
-(void) renderViewForOptions:(NSArray *) options
{
    //Remove all OptionRatingInputVs
    for (UIView *subV in self.OptionsRatingPlaceHolderV.subviews) {
        [subV removeFromSuperview];
    }
    
    //Create and add OptionRatingInputVs
    NSMutableArray *viewArr = [NSMutableArray array];
    CGPoint nextVOrigin = CGPointMake(0, 0);
    for (int i=0; i<options.count; i++) {
        
        Option *optionObj = [options objectAtIndex:i];
        
        //Create the view for option rating
        OptionRatingInputV *v = [OptionRatingInputV getInstance];
        v.mOption = optionObj;
        v.mRating = 0;
        
        //Adding the view to the Place Holder
        [self.OptionsRatingPlaceHolderV addSubview:v];
        CGRect rect = v.frame;
        rect.origin.x = nextVOrigin.x;
        rect.origin.y = nextVOrigin.y;
        v.frame = rect;
        
        
        //Updating the Origin point for next view
        nextVOrigin.y = CGRectGetMaxY(v.frame);
        
        [viewArr addObject:v];
    }
    
    optionRatingVArray = viewArr;
    
    //Resize the placeholder View
    CGRect rect = self.OptionsRatingPlaceHolderV.frame;
    rect.size.height = nextVOrigin.y;
    
    //Resize the self view
    rect = self.frame;
    rect.size.height = CGRectGetMaxY(self.OptionsRatingPlaceHolderV.frame);
}
@end
