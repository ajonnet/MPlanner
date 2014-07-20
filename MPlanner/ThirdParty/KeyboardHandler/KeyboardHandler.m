//
//  KeyboardHandler.m
//  Keyboard Handler
//
//  Created by Amit Jain on 25/04/13.
//  Copyright (c) 2013 ajonnet. All rights reserved.
//

#import "KeyboardHandler.h"

@interface KeyboardHandler ()
{
    UIToolbar *keybAccessory;
    UIBarButtonItem *previousBarBt;
    UIBarButtonItem *nextBarBt;
    UIView *activeField;
    
    BOOL keyboardHasAppeard;
}
//KeyboardAccessory ToolBar related methods
- (void)loadKeybAccessoryToolBar;
- (void)nextInputField:(id)sender;
- (void)previousInputField:(id)sender;
- (void)doneEditing:(id)sender;

//TextField and TextView Hanlding
- (void)registerForUITextFieldNotificationsForTextField:(UITextField *) tf;
- (void)registerForUITextViewNotificationsForTextView:(UITextView *) tv;
- (void)textFieldDidBeginEditing:(NSNotification *) notif;
- (void)textFieldDidEndEditing:(NSNotification *) notif;
- (void)textFieldTextDidChange:(NSNotification *) notif;

//Keyboard Handling
- (void)registerForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)notif;
- (void)keyboardWillBeHidden:(NSNotification*)notif;

- (CGRect) getPaddedFrameForView:(UIView *) view;
- (CGRect) getPaddedFrameInRespectToHostingScvwForView:(UIView *) view;
- (void) endEditing;
@end

@implementation KeyboardHandler
- (id)init
{
    self = [super init];
    if (self) {
        keyboardHasAppeard = NO;
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark properties setters and getters methods
-(void)setInputItems:(NSArray *)inputItems{
    _inputItems = nil;
    _inputItems = inputItems;
    
    //LazyLoading of Keyboard AccessoryView
    if (nil == keybAccessory) { 
        [self loadKeybAccessoryToolBar];
    }
    
    //Register keyboard AccessoryView for the inputItems
    for (UITextField *tf in inputItems) {
        tf.inputAccessoryView = keybAccessory;
        
        //Register for Notifications
        if ([tf isKindOfClass:[UITextView class]]) {
            //Registering for various TextView notifications
            [self registerForUITextViewNotificationsForTextView:(UITextView *)tf];
        }else{
            //Registering for various TextField notifications
            [self registerForUITextFieldNotificationsForTextField:tf];
        }
    }
}

-(void)setHostingSCVW:(UIScrollView *)hostingSCVW{
    _hostingSCVW = nil;
    _hostingSCVW = hostingSCVW;
    
    //Register for keyboard notifications
    [self registerForKeyboardNotifications];
    
    //Making editing end when hostingSCVW get Tapped
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    singleTap.delegate = self;
    [self.hostingSCVW addGestureRecognizer:singleTap];
}


#pragma mark UIGestureRecognizerDelegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //Detecting if touch is on a UITableView
    UIView *tmpV = touch.view;
    BOOL tableViewPresent = NO;
    while (tmpV != _hostingSCVW) {
        if ([tmpV isKindOfClass:[UITableView class]]) {
            tableViewPresent = YES;
            break;
        }
        tmpV = tmpV.superview;
    }
    
    return ! ([touch.view isKindOfClass:[UIControl class]] || tableViewPresent);
}

#pragma mark KeyboardAccessory Toolbar related methods
- (void)loadKeybAccessoryToolBar{
    //Loading the keybAccessory Toolbar
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"KeybAccView" owner:self options:nil];
    for (id object in bundle) {
        if ([object isKindOfClass:[UIToolbar class]]) {
            keybAccessory = (UIToolbar *) object;
            break;
        }
    }
    
    //Refrencing the previous, next, done barButtons
    __block UIBarButtonItem *doneBarBt;
    [keybAccessory.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIBarButtonItem class]]) {
            UIBarButtonItem *barBt = (UIBarButtonItem *) obj;
            if (1 == barBt.tag) { //PreviousBarBt
                previousBarBt = barBt;
            }else if(2 == barBt.tag){ //NextBarBt
                nextBarBt = barBt;
            }else if (3 == barBt.tag){ //DoneBarBt
                doneBarBt = barBt;
            }
        }
    }];
    
    
    //Associating the selectors
    previousBarBt.target = self;
    previousBarBt.action = @selector(previousInputField:);
    nextBarBt.target = self;
    nextBarBt.action = @selector(nextInputField:);
    doneBarBt.target = self;
    doneBarBt.action = @selector(doneEditing:);
}

- (void)nextInputField:(id)sender{
    NSUInteger idx = [self.inputItems indexOfObject:activeField];
    UITextField *nextInputField = [self.inputItems objectAtIndex:(idx + 1)];
    
    [nextInputField becomeFirstResponder];
}

- (void)previousInputField:(id)sender{
    NSUInteger idx = [self.inputItems indexOfObject:activeField];
    UITextField *prevInputField = [self.inputItems objectAtIndex:(idx - 1)];
    
    [prevInputField becomeFirstResponder];
}

- (void)doneEditing:(id)sender{
    [activeField resignFirstResponder];
}

#pragma mark UITextView Notification Handler methods
- (void)registerForUITextViewNotificationsForTextView:(UITextView *) tv
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:tv];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:tv];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:tv];
}

#pragma mark UITextField Notification Handler methods
- (void)registerForUITextFieldNotificationsForTextField:(UITextField *) tf
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:tf];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:tf];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:tf];
}

- (void)textFieldDidBeginEditing:(NSNotification *) notif 
{
    activeField = [notif object];
    
    //Adjust he inputAccessory according to the position of textField in inputItems
    NSUInteger idx = [self.inputItems indexOfObject:activeField];
    previousBarBt.enabled = YES;
    nextBarBt.enabled = YES;
    if (idx == 0) {
        previousBarBt.enabled = NO;
    }
    if(idx == (self.inputItems.count - 1)){
        nextBarBt.enabled = NO;
    }
    
    //scrolling the textField to visible area
    if (self.hostingSCVW && keyboardHasAppeard)
        [self.hostingSCVW scrollRectToVisible:[self getPaddedFrameInRespectToHostingScvwForView:activeField] animated:YES];
}

- (void)textFieldDidEndEditing:(NSNotification *) notif 
{
    //DLog(@"textFieldDidEndEditingcalled");
    activeField = nil;
}

//TODO: to be implemented
- (void)textFieldTextDidChange:(NSNotification *) notif
{
    //TODO: to be removed
    //#pragma mark UITextFieldDelegate methods
    //- (BOOL)textFieldShouldReturn:(UITextField *)textField
    //{
    //    //DLog(@"textFieldShouldReturn called");
    //    [textField resignFirstResponder];
    //    return YES;
    //}
}

#pragma mark Keybaord Notification handlers
-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notif
{
    //Getting keyboard & scvw intersection rect
    CGRect keybFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keybFrame = [self.hostingSCVW convertRect:keybFrame fromView:[[UIApplication sharedApplication] keyWindow]];
    CGRect keybScvwIntersectFrame = CGRectIntersection(self.hostingSCVW.bounds, keybFrame);
    
    //Adjusting the scvw insets
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keybScvwIntersectFrame.size.height, 0.0);
    self.hostingSCVW.contentInset = contentInsets;
    self.hostingSCVW.scrollIndicatorInsets = contentInsets;
    
    
    //scrolling the active field to visible area
    if ((nil != activeField) && (keyboardHasAppeard == NO))
        [self.hostingSCVW scrollRectToVisible:[self getPaddedFrameInRespectToHostingScvwForView:activeField] animated:YES];
    
     
    keyboardHasAppeard = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)notif
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.hostingSCVW.contentInset = UIEdgeInsetsZero;
    self.hostingSCVW.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
    
    keyboardHasAppeard = NO;
}

#pragma mark private methods
//TODO: to be removed, substituted by "getPaddedFrameInRespectToHostingScvwForView"
- (CGRect) getPaddedFrameForView:(UIView *) view
{
    CGFloat padding = 5;
    CGRect frame = view.frame;
    frame.size.height += 2 * padding;
    frame.origin.y -= padding;
    
    return frame;
}

- (CGRect) getPaddedFrameInRespectToHostingScvwForView:(UIView *) view
{
    CGFloat padding = 5;
    CGRect frame = view.frame;
    frame.size.height += 2 * padding;
    frame.origin.y -= padding;
    
    if (self.hostingSCVW) {
        frame = [self.hostingSCVW convertRect:frame fromView:view.superview];
    }
    
    return frame;
}

-(void)endEditing{
    [self.hostingSCVW endEditing:YES];
}
@end
