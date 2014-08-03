//
//  OptionRatingInputV.h
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionRatingInputV : UIView

@property (nonatomic, strong) Option *mOption;
@property (nonatomic, readwrite) NSUInteger mRating;

+(OptionRatingInputV *) getInstance;
@end
