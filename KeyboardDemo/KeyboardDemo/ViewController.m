//
//  ViewController.m
//  KeyboardDemo
//
//  Created by Ever on 15/12/8.
//  Copyright © 2015年 Lucky. All rights reserved.
//

#import "ViewController.h"

#import "StockKeyboard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    textField.center = self.view.center;
    textField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:textField];
    
    StockKeyboard *keyboard = [[StockKeyboard alloc] initWithKeyboardType:KeyboardTypeABC andTextFieldView:textField];
    keyboard.confirmBlock = ^(){
        NSLog(@"ok button press");
    };
    textField.inputView = keyboard;
    
    [textField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
