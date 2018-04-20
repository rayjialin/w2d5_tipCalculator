//
//  ViewController.m
//  TipCalculator
//
//  Created by ruijia lin on 4/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmount;
@property (weak, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UIButton *calculateTipButton;

@property NSLayoutConstraint *tipButtonBottomAnchor;
@property NSLayoutConstraint *totalAmountBottomAnchor;
@property NSLayoutConstraint *tipAmountBottomAnchor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.billAmountTextField.delegate = self;
    self.tipPercentageTextField.delegate = self;
    
    self.totalAmount.translatesAutoresizingMaskIntoConstraints = NO;
    self.tipAmount.translatesAutoresizingMaskIntoConstraints = NO;
    self.calculateTipButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tipButtonBottomAnchor = [self.calculateTipButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-30];
    self.tipButtonBottomAnchor.active = YES;
    
    self.totalAmountBottomAnchor = [self.totalAmount.bottomAnchor constraintEqualToAnchor:self.calculateTipButton.topAnchor constant:-20];
    self.totalAmountBottomAnchor.active = YES;
    
    self.tipAmountBottomAnchor = [self.tipAmount.bottomAnchor constraintEqualToAnchor:self.totalAmount.topAnchor constant:-20];
    self.tipAmountBottomAnchor.active = YES;
}


- (IBAction)calculateTipSlider:(UISlider *)sender {
    float tipPercent = sender.value;
    float billAmount;
    
    if ([self.billAmountTextField.text isEqualToString:@""]){
        billAmount = 0.00;
    }else {
        billAmount = [[NSString stringWithFormat:@"%@",[self.billAmountTextField.text substringFromIndex:1]] floatValue];
        
    }
    
    self.tipAmount.text = [NSString stringWithFormat:@"Tip Amount:%0.2f", billAmount * tipPercent  / 100.0];
    self.totalAmount.text = [NSString stringWithFormat:@"Total Bill Amount: $%0.2f", billAmount + billAmount * tipPercent / 100.0];
}



- (IBAction)calculateTip:(id)sender {
    // calculate tip of 15%
    float tipPercent;
    float billAmount;
    
    if ([self.tipPercentageTextField.text isEqualToString:@""]){
        tipPercent = 0.00;
    }else {
        tipPercent = [[NSString stringWithFormat:@"%@", [self.tipPercentageTextField.text substringToIndex:self.tipPercentageTextField.text.length]] floatValue];
    }
    
    if ([self.billAmountTextField.text isEqualToString:@""]){
        billAmount = 0.00;
    }else {
        billAmount = [[NSString stringWithFormat:@"%@",[self.billAmountTextField.text substringFromIndex:1]] floatValue];
        
    }
    
    self.tipAmount.text = [NSString stringWithFormat:@"Tip Amount:%0.2f", billAmount * tipPercent  / 100.0];
    self.totalAmount.text = [NSString stringWithFormat:@"Total Bill Amount: $%0.2f", billAmount + billAmount * tipPercent / 100.0];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textAlignment = NSTextAlignmentRight;
    
    if (textField == self.billAmountTextField){
        textField.text = [NSString stringWithFormat:@"$"];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.tipPercentageTextField){
        textField.text = [NSString stringWithFormat:@"%ld%%", [textField.text integerValue]];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.tipPercentageTextField resignFirstResponder];
    [self.billAmountTextField resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification*)notification{
    NSValue *rectValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [rectValue CGRectValue];
    
    [self.view layoutIfNeeded];
    self.tipButtonBottomAnchor.constant = -30 - rect.size.height;
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    [self.view layoutIfNeeded];
    self.tipButtonBottomAnchor.constant = -30;
    
}

@end
