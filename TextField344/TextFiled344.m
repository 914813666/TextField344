//
//  TextFiled344.m
//  hshclient_rn
//
//  Created by qzp on 2019/4/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "TextFiled344.h"

@interface TextFiled344 () <UITextFieldDelegate>
@property (nonatomic,strong) NSString * previousTextFiledContent;
@property (nonatomic, strong) UITextRange * previousSelection;
@end


@implementation TextFiled344

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup {
    self.delegate = self;
    [self addTarget: self
             action:@selector(textChange:)
   forControlEvents: UIControlEventEditingChanged];
}

- (void) textChange:(UITextField *) text {
    if(text.text.length > 13) {
        text.text = [text.text substringToIndex: 13];
    }
    NSUInteger targetCursorPosition = [text offsetFromPosition: text.beginningOfDocument toPosition: text.selectedTextRange.start];
    NSString * currentStr = [text.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * preStr = [_previousTextFiledContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0， 否则为1
    char editFlag = 0;
    if(currentStr.length <= preStr.length) {
        editFlag = 0;
    } else {
        editFlag = 1;
    }
    
    
    
    //    if (editFlag == 0) { //非删除状态
    //        //处理复制
    //        if(text.text.length > 5) {
    //            if (![[text.text substringWithRange:NSMakeRange(3, 1)] isEqualToString:@" "]) {
    //                NSMutableString * mStr = [NSMutableString stringWithString: text.text];
    //                [mStr insertString:@" " atIndex:3];
    //
    //                self.text = mStr;
    //                [self textChange: self];
    //                return;
    //            }
    //        }
    //        if (text.text.length > 10) {
    //            if (![[text.text substringWithRange:NSMakeRange(8, 1)] isEqualToString:@" "]) {
    //                NSMutableString * mStr = [NSMutableString stringWithString: text.text];
    //                [mStr insertString:@" " atIndex:8];
    //                self.text = mStr;
    //                [self textChange: self];
    //                return;
    //            }
    //        }
    //
    //
    //    }
    
    
    NSMutableString * tempStr  = [[NSMutableString alloc] init];
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length >= 0) {
        spaceCount = 0;
    } else if (currentStr.length <7 && currentStr.length >=3) {
        spaceCount = 1;
    } else if (currentStr.length <12 && currentStr.length >=7) {
        spaceCount = 2;
    }
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@",[currentStr substringWithRange: NSMakeRange(0, 3)], @" "];
        } else if (i == 1) {
            [tempStr appendFormat:@"%@%@",[currentStr substringWithRange: NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@",[currentStr substringWithRange: NSMakeRange(7, 4)], @" "];
        }
    }
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@",[currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    
    if (currentStr.length < 4) {
        [tempStr appendString: [currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    } else if (currentStr.length > 3 && currentStr.length < 12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    text.text = tempStr;
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    if (editFlag == 0) {
        //删除
        if (editFlag == 0) {
            if (targetCursorPosition == 9 || targetCursorPosition == 4) {
                curTargetCursorPosition = targetCursorPosition -1;
            }
        }
    } else {
        //添加
        if(currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    //复制修正
    if(text.text.length == 13) {
        curTargetCursorPosition = 13;
    }
    
    UITextPosition * targetPositon = [text positionFromPosition:[text beginningOfDocument]
                                                         offset: curTargetCursorPosition];
    [text setSelectedTextRange: [text textRangeFromPosition:targetPositon toPosition :targetPositon]];
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    _previousTextFiledContent = textField.text;
    _previousSelection = textField.selectedTextRange;
    
    
    return YES;
}
- (NSString *)lastText {
    NSLog(@"%@",self.text);
    NSString * str = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  str;
}


@end

