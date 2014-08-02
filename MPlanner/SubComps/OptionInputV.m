//
//  OptionInputV.m
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "OptionInputV.h"

@interface OptionInputV () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblOptionIdx;
@property (weak, nonatomic) IBOutlet UITextField *tfOptionTitle;
@end

@implementation OptionInputV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - IBAction methods
- (IBAction)onRemoveBtClick:(id)sender {
    
}


#pragma mark - Properties setters and getters
-(void)setMIdx:(NSUInteger)mIdx
{
    _mIdx = mIdx;
    
    //Update the Label for OptionIdx
    self.lblOptionIdx.text = [NSString stringWithFormat:@"Option %d",mIdx];
}

-(void)setMOption:(Option *)mOption
{
    _mOption = mOption;
    
    //Updating the TextField value
    if (mOption.mTitle) {
        self.tfOptionTitle.text = mOption.mTitle;
    }else {
        self.tfOptionTitle.text = nil;
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //Reflect the updated text in mOption
    _mOption.mTitle = newString;
    
    return YES;
}

@end
