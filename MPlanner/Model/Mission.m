//
//  Mission.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "Mission.h"

@interface Rating : NSObject <NSCoding>

@property (nonatomic, strong) Option *mOption;
@property (nonatomic, strong) Criterion *mCriterion;
@property (nonatomic, strong) NSNumber *mValue;
@end

@interface CriterionOrder : NSObject <NSCoding>

@property (nonatomic, strong) Criterion *mCriterionA;
@property (nonatomic, strong) Criterion *mCriterionB;
@property (nonatomic, readwrite) NSComparisonResult mOrder;
@end

@interface Mission ()
{
    NSMutableArray *ratings;
    NSMutableArray *criterionOrders;
}

@end

@implementation Mission

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_mCriterions = [NSArray array];
        self->_mOptions = [NSArray array];
        self->ratings = [NSMutableArray array];
        self->criterionOrders = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public methods
//Order setter and getter
-(void) setOrder:(NSComparisonResult) order
   forCriterionA:(Criterion *) criterionA
   andCriterionB:(Criterion *) criterionB
{
    //Nil Check
    if (nil == criterionA || nil == criterionB) {
        return;
    }
    
    //Update if order is already
    CriterionOrder *cOrder = [self getCriterionOrderObjHavingCriterions:@[criterionA,criterionB]];
    if (cOrder) {
        if ([cOrder.mCriterionA isEqual:criterionA] && [cOrder.mCriterionB isEqual:criterionB]) {
            cOrder.mOrder = order;
        } else {
            cOrder.mOrder = -1 * order;
        }
        return;
    }
    
    //Creating and Adding the new relation
    CriterionOrder *newCriterionOrder = [[CriterionOrder alloc] init];
    newCriterionOrder.mCriterionA = criterionA;
    newCriterionOrder.mCriterionB = criterionB;
    newCriterionOrder.mOrder = order;
    [criterionOrders addObject:newCriterionOrder];
}

-(NSComparisonResult) getOrderBtwCriterionA:(Criterion *) criterionA
                              andCriterionB:(Criterion *) criterionB
{
    CriterionOrder *obj = [self getCriterionOrderObjHavingCriterions:@[criterionA,criterionB]];
    
    //Nil Check
    if (nil == obj) {
        NSLog(@"Order not found");
        return NSOrderedSame;
    }
    
    NSComparisonResult order = obj.mOrder;
    
    //Matching the order to the give sequence of criterions
    if (![obj.mCriterionA isEqual:criterionA]) {
        order = -1 * order;
    }
    
    return order;
}

//Rating setter and getter
-(void) setRating:(NSNumber *) rating
      ofCriterion:(Criterion *) criterion
        forOption:(Option *) option
{
    //Nil Check
    if (!rating || !criterion || !option) {
        return;
    }
    
    //Update the rating if already exists
    Rating *ratingObj = [self getRatingObjHavingCriterion:criterion Option:option];
    if (ratingObj) {
        ratingObj.mValue = rating;
        return;
    }
    
    //Creating and adding the new relation
    Rating *newRatingObj = [[Rating alloc] init];
    newRatingObj.mValue = rating;
    newRatingObj.mCriterion = criterion;
    newRatingObj.mOption = option;
    [ratings addObject:newRatingObj];
}

-(NSNumber *) getRatingOfCriterion:(Criterion *) criterion
                         forOption:(Option *) option
{
    Rating *obj = [self getRatingObjHavingCriterion:criterion Option:option];
    
    //Nil Check
    if (!obj) {
        NSLog(@"Rating not found");
        return nil;
    }
    
    return obj.mValue;
}

-(Option *) renderBestOption
{
    
    //Calculating relative weight of each criterion
    NSMutableArray *relativeWeights = [NSMutableArray array];
    for (int i =0; i < _mCriterions.count; i++) {
        
        float weight = 0;
        Criterion *criterionA = _mCriterions[i];
        for (int j = 0; j< _mCriterions.count; j++) {
            if (i==j) continue;
            
            Criterion *criterionB = _mCriterions[j];
            CriterionOrder *orderObj = [self getCriterionOrderObjHavingCriterions:@[criterionA,criterionB]];
        
            //Nil Check
            if (!orderObj) {
                NSLog(@"Required Order between Criterions missing");
                return nil;
            }
            
            //Rendering Order between CriterionA and CriterionB
            NSComparisonResult order = orderObj.mOrder;
            if (![orderObj.mCriterionA isEqual:criterionA]) {
                order = -1 * order;
            }
            
            //Renedering relative weight between CriterionA and CriterionB
            float relWeight = 0;
            relWeight = (order == NSOrderedAscending)?0:relWeight;
            relWeight = (order == NSOrderedSame)?0.5:relWeight;
            relWeight = (order == NSOrderedDescending)?1:relWeight;
            
            weight+=relWeight;
        }
        
        [relativeWeights addObject:@(weight)];
    }
    
    //Rendering the weight for each Option
    // optionWeight = criterionRelativeWeight * criterionRating
    NSMutableArray *optionWeights = [NSMutableArray array];
    for (int i =0; i< _mOptions.count;i++) {

        Option *optionObj = _mOptions[i];
        
        float weight = 0;
        for (Criterion *criterionObj in _mCriterions) {
            Rating *ratingObj = [self getRatingObjHavingCriterion:criterionObj Option:optionObj];
            
            //Nil Check
            if (!ratingObj) {
                NSLog(@"Rating for a criterion is missing");
                return nil;
            }
            
            float criterionRating = [ratingObj.mValue floatValue];
            float criterionRelativeWeight = [[relativeWeights objectAtIndex:[_mCriterions indexOfObject:criterionObj]] floatValue];
            weight += criterionRating * criterionRelativeWeight;
        }
        
        [optionWeights addObject:@(weight)];
    }
    
    
    //Evaluation the best Option
    BOOL flagMultipleBestOption = false;
    Option *bestOption = _mOptions[0];
    float bestOptionWeight = [optionWeights[0] floatValue];
    for (int i =1; i< optionWeights.count; i++) {
        
        float optionWeight = [optionWeights[i] floatValue];
 
        
        if (optionWeight == bestOptionWeight) {
            flagMultipleBestOption = true;
            continue;
        }
        
        if (optionWeight > bestOptionWeight) {
            bestOption = _mOptions[i];
            bestOptionWeight = optionWeight;
            
            flagMultipleBestOption = false;
        }
    }
    
    //Only single best option should be there
    if (flagMultipleBestOption) {
        NSLog(@"Best Option cant be evaluated as there is a Tie");
        return nil;
    }
    
    return bestOption;
}

#pragma mark - NSCoding protocol
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mTitle forKey:@"Title"];
    [encoder encodeObject:self.mOptions forKey:@"OptionsArr"];
    [encoder encodeObject:self.mCriterions forKey:@"CriterionsArr"];
    [encoder encodeObject:ratings forKey:@"OptionsRatings"];
    [encoder encodeObject:criterionOrders forKey:@"CriterionsOrder"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mTitle = [aDecoder decodeObjectForKey:@"Title"];
        self.mOptions = [aDecoder decodeObjectForKey:@"OptionsArr"];
        self.mCriterions = [aDecoder decodeObjectForKey:@"CriterionsArr"];
        ratings = [aDecoder decodeObjectForKey:@"OptionsRatings"];
        criterionOrders = [aDecoder decodeObjectForKey:@"CriterionsOrder"];
    }
    return self;
}

#pragma mark - properties setters and getters
-(void)setMCriterions:(NSArray *)mCriterions
{
    _mCriterions = mCriterions;
    
    if (nil == mCriterions) {
        _mCriterions = [NSArray array];
    }
    
    [self updateRatingAndCriterionOrders];
}

-(void) setMOptions:(NSArray *)mOptions
{
    _mOptions = mOptions;

    if (nil == mOptions) {
        _mOptions = [NSArray array];
    }
    
    [self updateRatingAndCriterionOrders];
}

#pragma mark - private methods
-(Rating *) getRatingObjHavingCriterion:(Criterion *) criterion Option:(Option *) option
{
    Rating *obj = nil;
    
    for (Rating *rating in ratings) {
        if ([rating.mOption isEqual:option] && [rating.mCriterion isEqual:criterion]) {
            obj = rating;
            break;
        }
    }
    
    return obj;
}

-(CriterionOrder *) getCriterionOrderObjHavingCriterions:(NSArray *) criterions
{
    CriterionOrder *criterionA = criterions[0];
    CriterionOrder *criterionB = criterions[1];
    
    CriterionOrder *obj = nil;
    
    for (CriterionOrder *order in criterionOrders) {
        NSArray *criterionArr = @[order.mCriterionA,order.mCriterionB];
        if ([criterionArr indexOfObject:criterionA] != NSNotFound &&
            [criterionArr indexOfObject:criterionB] != NSNotFound) {
            obj = order;
            break;
        }
    }
    
    return obj;
}

-(void) updateRatingAndCriterionOrders
{
    //Updating Ratings
    NSMutableArray *obseleteRatings = [NSMutableArray array];
    for (Rating *rating in ratings) {
        if ([_mOptions indexOfObject:rating.mOption] == NSNotFound ||
            [_mCriterions indexOfObject:rating.mCriterion] == NSNotFound) {
            [obseleteRatings addObject:rating];
        }
    }
    [obseleteRatings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ratings removeObject:obj];
    }];
    
    
    //Updating CriterionOrders
    NSMutableArray *obseleteCriterionOrders = [NSMutableArray array];
    for (CriterionOrder *order in criterionOrders) {
        if ([_mCriterions indexOfObject:order.mCriterionA] == NSNotFound ||
            [_mCriterions indexOfObject:order.mCriterionB] == NSNotFound) {
            [obseleteCriterionOrders addObject:order];
        }
    }
    [obseleteCriterionOrders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [criterionOrders removeObject:obj];
    }];
}
@end

@implementation Rating
-(NSString *)description {
    NSString *str = [NSString stringWithFormat:@"[%@]->Cr[%@]Op[%@]",_mValue,_mCriterion,_mOption];
    return str;
}

#pragma mark - NSCoding protocol
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mCriterion forKey:@"Criterion"];
    [encoder encodeObject:self.mOption forKey:@"Option"];
    [encoder encodeObject:self.mValue forKey:@"RatingVal"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mCriterion = [aDecoder decodeObjectForKey:@"Criterion"];
        self.mOption = [aDecoder decodeObjectForKey:@"Option"];
        self.mValue = [aDecoder decodeObjectForKey:@"RatingVal"];
    }
    return self;
}
@end

@implementation CriterionOrder
-(NSString *)description {
    NSString *str = [NSString stringWithFormat:@"[%d]->CrA[%@]crB[%@]",_mOrder,_mCriterionA,_mCriterionB];
    return str;
}

#pragma mark - NSCoding protocol
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mCriterionA forKey:@"CriterionA"];
    [encoder encodeObject:self.mCriterionB forKey:@"CriterionB"];
    [encoder encodeObject:@(self.mOrder) forKey:@"Order"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mCriterionA = [aDecoder decodeObjectForKey:@"CriterionA"];
        self.mCriterionB = [aDecoder decodeObjectForKey:@"CriterionB"];
        self.mOrder = [[aDecoder decodeObjectForKey:@"Order"] integerValue];
    }
    return self;
}
@end

@implementation Option
-(NSString *)description { return _mTitle; }

#pragma mark - NSCoding protocol
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mTitle forKey:@"OptionTitle"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mTitle = [aDecoder decodeObjectForKey:@"OptionTitle"];
    }
    return self;
}
@end

@implementation Criterion
-(NSString *)description { return _mTitle; }

#pragma mark - NSCoding protocol
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mTitle forKey:@"CriterionTitle"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.mTitle = [aDecoder decodeObjectForKey:@"CriterionTitle"];
    }
    return self;
}
@end
