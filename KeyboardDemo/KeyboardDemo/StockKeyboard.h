//
//  StockKeyboard.h
//  Lucky
//
//  Created by Ever on 15/12/7.
//  Copyright © 2015年 xiaolucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KeyboardTypeNumber,
    KeyboardTypeABC
} KeyboardType;

@interface StockKeyboard : UIView

/**
 *  键盘类型
 */
@property (assign, nonatomic) KeyboardType keyboardType;

/**
 *  要自定义键盘的文本框
 */
@property (weak, nonatomic) UITextField *textField;

/**
 *  确定键 回调block
 */
@property (copy, nonatomic) void (^confirmBlock)();

/**
 *  初始化方法
 *
 *  @param type 键盘类型
 *
 *  @return 键盘实例对象
 */
- (instancetype)initWithKeyboardType:(KeyboardType)type andTextFieldView:(UITextField *)textField;

@end
