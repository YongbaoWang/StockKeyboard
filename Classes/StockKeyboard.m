//
//  StockKeyboard.m
//  Lucky
//
//  Created by Ever on 15/12/7.
//  Copyright © 2015年 xiaolucky. All rights reserved.
//

#import "StockKeyboard.h"
#import <AudioToolbox/AudioServices.h>

#define kBoardHeight          (216.0)                      //键盘高度
#define kBoardWidth [UIScreen mainScreen].bounds.size.width//键盘宽度

#define kLineWidth (1) //线条宽度
#define kLineGrayColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0     alpha:1]//线条颜色
#define kLineWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0    alpha:1]//线条颜色

#define kAreaDarkGrayColor [UIColor colorWithRed:207/255.0 green:208/255.0 blue:212/255.0 alpha:1]//图形背景色
#define kAreaGrayColor [UIColor colorWithRed:227/255.0 green:229/255.0 blue:233/255.0     alpha:1]//图形背景色
#define kAreaWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0    alpha:1]//图形背景色

#define kTitleColor [UIColor blackColor]//文字颜色
#define kLeftTitleFontSize   (14)       //左侧文字大小
#define kMiddleTitleFontSize (18)       //中间文字大小
#define kRightTitleFontSize  (16)       //右侧文字大小

#define kABCBtnHMargin       (2)        //ABC按键水平间距
#define kABCBtnVMargin       (5)        //ABC按键垂直间距
#define kFunBtnInternalSpace (10)       //功能按键之间间距

@interface StockKeyboard()

//Number type
/**
 *  所有btn宽度
 */
@property (assign, nonatomic) CGFloat allBtnWidth;
/**
 *  左侧btn高度
 */
@property (assign, nonatomic) CGFloat leftBtnHeight;
/**
 *  右侧btn高度
 */
@property (assign, nonatomic) CGFloat rightBtnHeight;
/**
 *  中间btn高度
 */
@property (assign, nonatomic) CGFloat middleBtnHeight;
/**
 *  左侧区域标题数组
 */
@property (strong, nonatomic) NSArray<__kindof NSString *> *leftTitleArray;
/**
 *  中间区域标题数组
 */
@property (strong, nonatomic) NSArray<__kindof NSString *> *middleTitleArray;
/**
 *  右侧区域标题数组
 */
@property (strong, nonatomic) NSArray<__kindof NSString *> *rightTitleArray;
/**
 *  选中的btn rect
 */
@property (assign, nonatomic) CGRect touchRect;
/**
 *  选中btn 正常颜色
 */
@property (strong, nonatomic) UIColor *normalColor;
/**
 *  选中btn 时颜色
 */
@property (strong, nonatomic) UIColor *touchColor;


//ABC type
/**
 *  ABC区域标题数组
 */
@property (strong, nonatomic) NSArray<__kindof NSString *> *abcTitleArray;
/**
 *  功能区域标题数组
 */
@property (strong, nonatomic) NSArray<__kindof NSString *> *funTitleArray;
/**
 *  所有按键识别区域
 */
@property (strong, nonatomic) NSMutableArray<__kindof NSValue *> *btnRectArrayM;

@end

@implementation StockKeyboard

- (instancetype)initWithKeyboardType:(KeyboardType)type andTextFieldView:(UITextField *)textField
{
    self = [super initWithFrame:CGRectMake(0, 0, kBoardWidth, kBoardHeight)];
    if (self) {
        _keyboardType = type;
        _textField = textField;
        _touchRect = CGRectZero;
        
        //        textField.inputView = self;
        
    }
    return self;
}

#pragma mark - Property
- (NSMutableArray<NSValue *> *)btnRectArrayM{
    if (_btnRectArrayM == nil) {
        _btnRectArrayM = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _btnRectArrayM;
}

-(void)setKeyboardType:(KeyboardType)keyboardType{
    
    _keyboardType = keyboardType;
    _touchRect = CGRectZero;
}

-(void)setTextField:(UITextField *)textField{
    
    _textField = textField;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.keyboardType == KeyboardTypeNumber) {
        
        //设置键盘背景色
        CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
        CGContextFillRect(context, rect);
        
        self.leftTitleArray = @[@"600",@"601",@"000",@"300",@"002"];
        self.middleTitleArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"ABC",@"0",@"."];
        self.rightTitleArray = @[@"Del",@"隐藏",@"清空",@"确定"];
        
        self.allBtnWidth = kBoardWidth / 5.0;
        self.leftBtnHeight = kBoardHeight / self.leftTitleArray.count;
        self.rightBtnHeight = kBoardHeight / self.rightTitleArray.count;
        self.middleBtnHeight = self.rightBtnHeight;
        
        //背景色(左侧)
        CGRect leftArea = CGRectMake(0, 0, self.allBtnWidth, kBoardHeight);
        [self fillRect:context rect:leftArea fillColor:kAreaGrayColor];
        
        //背景色(中间)
        CGRect middleArea = CGRectMake(self.allBtnWidth, 0, kBoardWidth - self.allBtnWidth, kBoardHeight);
        [self fillRect:context rect:middleArea fillColor:kAreaWhiteColor];
        
        //背景色(右侧)
        CGRect rightArea = CGRectMake(kBoardWidth - self.allBtnWidth, 0, self.allBtnWidth, kBoardHeight);
        [self fillRect:context rect:rightArea fillColor:kAreaGrayColor];
        
        //竖线
        for (int i = 0; i < 4; i++) {
            
            CGPoint point1 = CGPointMake(self.allBtnWidth * (i + 1), 0);
            CGPoint point2 = CGPointMake(self.allBtnWidth * (i + 1), kBoardHeight);
            [self drawLine:context fromPoint:point1 toPoint:point2 lineColor:kLineGrayColor];
        }
        
        //横线(左侧)
        CGFloat offest = 10; //线条左右各留出对少间距
        for (int i = 0; i < self.leftTitleArray.count; i++) {
            
            CGPoint point1 = CGPointMake(offest, self.leftBtnHeight * (i + 1));
            CGPoint point2 = CGPointMake(self.allBtnWidth - offest, self.leftBtnHeight * (i + 1));
            [self drawLine:context fromPoint:point1 toPoint:point2 lineColor:kLineWhiteColor];
            
        }
        
        //横线(中间及右侧)
        for (int i = 0; i < 3; i++) {
            CGPoint point1 = CGPointMake(self.allBtnWidth, self.middleBtnHeight * (i + 1));
            CGPoint point2 = CGPointMake(kBoardWidth, self.middleBtnHeight * (i + 1));
            [self drawLine:context fromPoint:point1 toPoint:point2 lineColor:kLineGrayColor];
            
        }
        
        [self fillSelectBtnColor:context];
        
        //按钮文字(左侧)
        for (int i = 0; i < self.leftTitleArray.count; i++) {
            NSString *title = self.leftTitleArray[i];
            CGRect textRect = CGRectMake(0, self.leftBtnHeight * i, self.allBtnWidth, self.leftBtnHeight);
            [self drawTitle:context inRect:textRect title:title fontSize:kLeftTitleFontSize];
        }
        
        //按钮文字(中间)
        for (int i = 0; i < self.middleTitleArray.count; i++) {
            NSString *title = self.middleTitleArray[i];
            CGRect textRect = CGRectMake(self.allBtnWidth * (i%3 + 1), self.middleBtnHeight * (i/3), self.allBtnWidth, self.middleBtnHeight);
            [self drawTitle:context inRect:textRect title:title fontSize:kMiddleTitleFontSize];
        }
        
        //按钮文字(右侧)
        for (int i = 0; i < self.rightTitleArray.count; i++) {
            NSString *title = self.rightTitleArray[i];
            CGRect textRect = CGRectMake(kBoardWidth - self.allBtnWidth, self.rightBtnHeight * i, self.allBtnWidth, self.rightBtnHeight);
            [self drawTitle:context inRect:textRect title:title fontSize:kRightTitleFontSize];
        }
        
        
    }else if(self.keyboardType == KeyboardTypeABC){
        
        [self.btnRectArrayM removeAllObjects];
        
        //设置键盘背景色
        CGContextSetFillColorWithColor(context,kAreaGrayColor.CGColor);
        CGContextFillRect(context, rect);
        
        self.abcTitleArray = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
        self.funTitleArray = @[@"123",@"隐藏",@"清空",@"确定"];
        
        CGFloat abcBtnWidth = (kBoardWidth - kABCBtnHMargin * 2 * 10)/10.0;
        CGFloat abcBtnHeight = (kBoardHeight - kABCBtnVMargin * 2 * 4)/4.0;
        CGFloat funBtnWidth = (kBoardWidth - kFunBtnInternalSpace * 5)/self.funTitleArray.count;
        CGFloat funBtnHeight = abcBtnHeight;
        
        //字母(第一行)
        for (int i = 0; i < 10; i++) {
            
            CGRect btnRect = CGRectMake(kABCBtnHMargin + (abcBtnWidth + kABCBtnHMargin * 2) * i, kABCBtnVMargin, abcBtnWidth, abcBtnHeight);
            [self fillRoundRect:context rect:btnRect backgroundColor:kAreaWhiteColor];
            [self drawTitle:context inRect:btnRect title:self.abcTitleArray[i] fontSize:kMiddleTitleFontSize];
            
            [self.btnRectArrayM addObject:[NSValue valueWithCGRect:btnRect]];
            
        }
        
        //字母(第二行)
        CGFloat offset = (abcBtnWidth + kABCBtnHMargin * 2)/2.0;
        for (int i = 0; i < 9; i++) {
            
            CGRect btnRect = CGRectMake(offset + kABCBtnHMargin + (abcBtnWidth + kABCBtnHMargin * 2) * i,(kABCBtnVMargin * 2 + abcBtnHeight) + kABCBtnVMargin, abcBtnWidth, abcBtnHeight);
            [self fillRoundRect:context rect:btnRect backgroundColor:kAreaWhiteColor];
            [self drawTitle:context inRect:btnRect title:self.abcTitleArray[i + 10] fontSize:kMiddleTitleFontSize];
            
            [self.btnRectArrayM addObject:[NSValue valueWithCGRect:btnRect]];
            
        }
        
        //字母(第三行)
        offset = kFunBtnInternalSpace;
        for (int i = 0; i < 7; i++) {
            
            CGRect btnRect = CGRectMake(offset + kABCBtnHMargin + (abcBtnWidth + kABCBtnHMargin * 2) * i,(kABCBtnVMargin * 2 + abcBtnHeight) * 2 + kABCBtnVMargin, abcBtnWidth, abcBtnHeight);
            [self fillRoundRect:context rect:btnRect backgroundColor:kAreaWhiteColor];
            [self drawTitle:context inRect:btnRect title:self.abcTitleArray[i + 19] fontSize:kMiddleTitleFontSize];
            
            [self.btnRectArrayM addObject:[NSValue valueWithCGRect:btnRect]];
        }
        
        //字母(第三行) 最右侧 功能键
        CGRect btnRect = CGRectMake(kBoardWidth - kFunBtnInternalSpace - funBtnWidth, (kABCBtnVMargin * 2 + abcBtnHeight) * 2 + kABCBtnVMargin, funBtnWidth, funBtnHeight);
        [self fillRoundRect:context rect:btnRect backgroundColor:kAreaDarkGrayColor];
        [self drawTitle:context inRect:btnRect title:@"Del" fontSize:kRightTitleFontSize];
        
        [self.btnRectArrayM addObject:[NSValue valueWithCGRect:btnRect]];
        
        //底部功能键
        for (int i = 0; i < self.funTitleArray.count; i++) {
            
            CGRect btnRect = CGRectMake(kFunBtnInternalSpace + (funBtnWidth + kFunBtnInternalSpace) * i ,(kABCBtnVMargin * 2 + abcBtnHeight) * 3 + kABCBtnVMargin, funBtnWidth, funBtnHeight);
            [self fillRoundRect:context rect:btnRect backgroundColor:kAreaDarkGrayColor];
            [self drawTitle:context inRect:btnRect title:self.funTitleArray[i] fontSize:kRightTitleFontSize];
            
            [self.btnRectArrayM addObject:[NSValue valueWithCGRect:btnRect]];
            
        }
        
    }
    
}

#pragma mark - Private Action
//画直线
- (void)drawLine:(CGContextRef)context fromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 lineColor:(UIColor *)lineColor{
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    CGContextStrokePath(context);
}

//填充矩形
- (void)fillRect:(CGContextRef)context rect:(CGRect)rect fillColor:(UIColor *)fillColor{
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, rect);
}

//写入文字
- (void)drawTitle:(CGContextRef)context inRect:(CGRect)rect title:(NSString *)title fontSize:(CGFloat)fontSize{
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:kTitleColor};
    CGRect titleRect = [title boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
    
    CGPoint originPoint = CGPointMake(CGRectGetMidX(rect) - titleRect.size.width/2, CGRectGetMidY(rect) - titleRect.size.height/2);
    [title drawAtPoint:originPoint withAttributes:attributes];
    
}

//填充圆角矩形
- (void)fillRoundRect:(CGContextRef)context rect:(CGRect)rect backgroundColor:(UIColor *)background{
    
    //设置选中btn的背景色
    if (CGRectEqualToRect(self.touchRect, rect)) {
        
        background = self.touchColor;
        self.touchRect = CGRectZero;
    }
    
    CGContextSetFillColorWithColor(context, background.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1.5), 1, [UIColor colorWithRed:137/255.0 green:139/255.0 blue:143/255.0 alpha:1].CGColor);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetShadow(context, CGSizeZero, 0);
    
}

/**
 *  设置选中btn的背景色
 *
 *  @param context 当前上下文
 */
- (void)fillSelectBtnColor:(CGContextRef)context{
    
    if (!CGRectEqualToRect(self.touchRect, CGRectZero)) {
        
        [self fillRect:context rect:self.touchRect fillColor:self.touchColor];
        self.touchRect = CGRectZero;
    }
    
}

#pragma mark - UIResponder Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self playKeyboardSound];
    
    if (self.keyboardType == KeyboardTypeNumber) {
        
        //判断点击区域：左侧
        if (touchPoint.x < self.allBtnWidth) {
            
            int j = touchPoint.y / self.leftBtnHeight;
            NSString *title = self.leftTitleArray[j];
            [self numberAction:title];
            self.touchRect = CGRectMake(0, self.leftBtnHeight * j, self.allBtnWidth, self.leftBtnHeight);
            self.normalColor = kAreaGrayColor;
            self.touchColor = kAreaWhiteColor;
            NSLog(@"%@",title);
            
        }
        else if(touchPoint.x >=self.allBtnWidth && touchPoint.x <=(kBoardWidth - self.allBtnWidth)){
            
            int i = (touchPoint.x - self.allBtnWidth)/self.allBtnWidth;
            int j = touchPoint.y /self.middleBtnHeight;
            NSString *title = self.middleTitleArray[j * 3 + i];
            if ((j * 3 + i) == 9) {
                [self abcAction];
            }else {
                [self numberAction:title];
            }
            self.touchRect = CGRectMake(self.allBtnWidth * (i + 1), self.middleBtnHeight * j, self.allBtnWidth, self.middleBtnHeight);
            self.normalColor = kAreaWhiteColor;
            self.touchColor = kAreaGrayColor;
            NSLog(@"%@",title);
        }
        else if(touchPoint.x > (kBoardWidth - self.allBtnWidth)){
            
            int j = touchPoint.y / self.rightBtnHeight;
            NSString *title = self.rightTitleArray[j];
            NSLog(@"%@",title);
            switch (j) {
                case 0:
                    [self backspaceAction];
                    break;
                case 1:
                    [self hideAction];
                    break;
                case 2:
                    [self clearAction];
                    break;
                case 3:
                    [self confirmAction];
                    break;
                default:
                    NSAssert(false, @"touchPoint btn calc error !");
                    break;
            }
            self.touchRect = CGRectMake(kBoardWidth - self.allBtnWidth, self.rightBtnHeight * j, self.allBtnWidth, self.rightBtnHeight);
            self.normalColor = kAreaGrayColor;
            self.touchColor = kAreaWhiteColor;
            
        }
    }
    else if(self.keyboardType == KeyboardTypeABC){
        
        for (int i = 0; i < self.btnRectArrayM.count; i++) {
            
            CGRect btnRect = [(NSValue *)self.btnRectArrayM[i] CGRectValue];
            if (CGRectContainsPoint(btnRect, touchPoint)) {
                
                self.touchRect = btnRect;
                
                if (i < 26) {
                    
                    self.normalColor = kAreaWhiteColor;
                    self.touchColor = kAreaDarkGrayColor;
                    
                    [self numberAction:self.abcTitleArray[i]];
                    
                }else if(i == 26){
                    
                    [self backspaceAction];
                    self.normalColor = kAreaDarkGrayColor;
                    self.touchColor = kAreaWhiteColor;
                    
                }else if(i > 26){
                    
                    switch (i) {
                        case 27:
                            [self abcAction];
                            break;
                        case 28:
                            [self hideAction];
                            break;
                        case 29:
                            [self clearAction];
                            break;
                        case 30:
                            [self confirmAction];
                            break;
                        default:
                            NSAssert(false, @"i error !");
                            break;
                    }
                    
                    self.normalColor = kAreaDarkGrayColor;
                    self.touchColor = kAreaWhiteColor;
                    
                }
                break;
                
            }
        }
        
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self setNeedsDisplay];
}

/**
 *  播放按键音
 */
-(void)playKeyboardSound
{
    //1000 - 2000 为系统提示音, 1105 = Tock.caf
    AudioServicesPlaySystemSound(1105);   //播放IOS系统自带按键声音
    
}

#pragma mark - Button Action
/**
 *  数字键/字母键
 *
 *  @param title 数字
 */
- (void)numberAction:(NSString *)title{
    
    self.textField.text = [NSString stringWithFormat:@"%@%@",self.textField.text,title];
    
    [self.textField sendActionsForControlEvents:UIControlEventEditingChanged];
}

/**
 *  删除键
 */
- (void)backspaceAction{
    
    NSString *txt = self.textField.text;
    if (txt.length > 0) {
        self.textField.text = [txt stringByReplacingCharactersInRange:NSMakeRange(txt.length - 1, 1) withString:@""];
        [self.textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
}

/**
 *  隐藏键
 */
- (void)hideAction{
    
    [self.textField resignFirstResponder];
}

/**
 *  清空键
 */
- (void)clearAction{
    
    self.textField.text = @"";
    [self.textField sendActionsForControlEvents:UIControlEventEditingChanged];
}

/**
 *  确定键
 */
- (void)confirmAction{
    
    if (self.confirmBlock != nil) {
        self.confirmBlock();
    }
}

/**
 *  ABC键
 */
- (void)abcAction{
    
    if (self.keyboardType == KeyboardTypeABC) {
        self.keyboardType = KeyboardTypeNumber;
    }else{
        self.keyboardType = KeyboardTypeABC;
    }
    self.touchRect = CGRectZero;
    [self setNeedsDisplay];
}

@end
