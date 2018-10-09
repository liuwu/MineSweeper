//
//  LWCardTextView.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/9.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "LWCardTextView.h"

#import "REFormattedNumberField.h"
#import "NSString+RENumberFormat.h"

@interface LWCardTextView()<UITextFieldDelegate>

//@property (nonatomic, strong) REFormattedNumberField *creditCardField;
@property (copy, nonatomic) NSString *currentFormattedText;

@property (copy, nonatomic) NSString *format;
@property (copy, readonly, nonatomic) NSString *unformattedText;

@property (nonatomic, assign) LWCardTextViewType type;

@end

@implementation LWCardTextView

- (instancetype)initWithType:(LWCardTextViewType)type {
    _type = type;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化默认状态
        self.backgroundColor = [UIColor whiteColor];
        
        QMUILabel *titleLabel = [[QMUILabel alloc] init];
        titleLabel.font = UIFontMake(15.f);
        titleLabel.textColor = WLColoerRGB(51.f);
        titleLabel.text = @"卡号";
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel sizeToFit];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10.f);
            make.centerY.mas_equalTo(self);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.enablesReturnKeyAutomatically = YES;
        textField.textColor =  WLColoerRGB(51.f);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = WLFONT(15);
        textField.textAlignment = NSTextAlignmentRight;
        textField.backgroundColor = WLColoerRGB(255.f);
        switch (_type) {
            case LWCardTextViewTypeCardNO:
            {
                self.number = @"";
                textField.delegate = self;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                self.format = @"XXXX XXXX XXXX XXXX";
                [textField addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
                
            default:
            {
                textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
        }
        
        [self addSubview:textField];
//        [textField wl_setDebug:YES];
        self.textField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - 100.f, 44.f));
            make.right.mas_equalTo(self).mas_offset(-10.f);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)formatInput:(UITextField *)textField {
    
    // If it was not deleteBackward event
    //
    if (![textField.text isEqualToString:self.currentFormattedText]) {
        __typeof (self) __weak weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __typeof (self) __strong strongSelf = weakSelf;
            strongSelf.number = strongSelf.unformattedText;
            textField.text = [strongSelf.unformattedText re_stringWithNumberFormat:strongSelf.format];
            strongSelf.currentFormattedText = textField.text;
            [strongSelf.textField sendActionsForControlEvents:UIControlEventEditingChanged];
        });
    }
}


- (NSString *)unformattedText {
    
    if (!self.format) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:NULL];
        return [regex stringByReplacingMatchesInString:self.textField.text options:0 range:NSMakeRange(0, self.textField.text.length) withTemplate:@""];
    }
    NSString *trimmedFromat = [[self.format componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789X"] invertedSet]] componentsJoinedByString:@""];
    NSString *trimmedText = [[self.textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    NSMutableString *unformattedText = [NSMutableString string];
    NSUInteger length = MIN([trimmedFromat length], [trimmedText length]);
    
    for (NSUInteger i = 0; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        
        NSString *symbol = [trimmedText substringWithRange:range];
        if (![[trimmedFromat substringWithRange:range] isEqualToString:symbol]) {
            [unformattedText appendString:symbol];
        }
    }
    
    return [unformattedText copy];
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self wl_setBorderWidth:0.8f color:_selectBorderColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self wl_setBorderWidth:0.8f color:_defaultBorderColor];
}

- (void)setPlaceholder:(NSString *)placeholder {
//    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
}

@end
