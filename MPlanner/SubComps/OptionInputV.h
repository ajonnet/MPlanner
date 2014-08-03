//
//  OptionInputV.h
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionInputVDelegate;


@interface OptionInputV : UIView

@property (nonatomic, readwrite) NSUInteger mIdx;
@property (nonatomic, strong) Option *mOption;
@property (nonatomic, weak) id<OptionInputVDelegate> delegate;

+(OptionInputV *) getInstance;
@end

@protocol OptionInputVDelegate <NSObject>
-(void) removeCalledForOptionInputV:(OptionInputV *) obj;
@end
