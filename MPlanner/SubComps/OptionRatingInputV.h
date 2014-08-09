//
//  OptionRatingInputV.h
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionRatingInputVDelegate;

@interface OptionRatingInputV : UIView

@property (nonatomic, strong) Option *mOption;
@property (nonatomic, readwrite) NSUInteger mRating;
@property (nonatomic, weak) id<OptionRatingInputVDelegate> delegate;

+(OptionRatingInputV *) getInstance;
@end

@protocol OptionRatingInputVDelegate <NSObject>

-(void) ratingChangedForOptionRatingInputV:(OptionRatingInputV *) obj;

@end