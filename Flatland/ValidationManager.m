//
//  ValidationManager.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "ValidationManager.h"
#import "FlatRadioButtonGroup.h"
#import "FlatCheckbox.h"

@interface Validator : NSObject

@property (nonatomic, strong) UIView<ValidatableField> *field;
@property (nonatomic, strong) NSString *messageKey;
@property (nonatomic, strong) BOOL(^validator)(id<ValidatableField>checkField);
@property (nonatomic, readonly) NSString *fieldName;

@end

@implementation Validator

- (NSString *)fieldName {
    NSArray *parts = [self.messageKey componentsSeparatedByString:@" "];
    if ([parts count] >= 2) {
        return parts[0];
    }
    return @"";
}

@end

@implementation ValidationManager {
    NSMutableArray *_validators;
    NSString *_messageKeyPrefix;
}

- (id)initWithMessageKeyPrefix:(NSString *)prefix {
    self = [self init];
    if (self) {
        _messageKeyPrefix = prefix;
        _validators = [NSMutableArray new];
    }
    return self;
}

- (void)addValidatorForField:(UIView <ValidatableField> *)field errorMessageKey:(NSString *)errorMessageKey validator:(BOOL (^)(id<ValidatableField>))validator {
    
    Validator *v = [Validator new];
    v.field = field;
    v.messageKey = errorMessageKey;
    v.validator = validator;
    [_validators addObject:v];
}

- (void)addRequiredValidatorForField:(id<ValidatableField>)field
                     errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        if ([checkField isKindOfClass:[UITextField class]]) {
            return !IsEmpty(((UITextField*)checkField).text);
        } else if ([checkField isKindOfClass:[FlatRadioButtonGroup class]]) {
            return ((FlatRadioButtonGroup *)checkField).selectedIndex != -1;
        }
        else if ([checkField isKindOfClass:[FlatCheckbox class]]) {
            return ((FlatCheckbox *)checkField).on;
        }
        return NO;
    }];
}

- (void)addRegExpValidatorForField:(id<ValidatableField>)field
                            regExp:(NSString *)regExp
                   errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        NSString *text = ((UITextField *)checkField).text;
        if (!text) {
            text = @"";
        }
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regExp options:0 error:NULL];
        NSTextCheckingResult *r = [re firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
        BOOL result = r && [r range].location != NSNotFound;
        return result;
    }];
}

- (void)addLengthValidatorForField:(id<ValidatableField>)field
                         minLength:(int)minLength
                         maxLength:(int)maxLength
                   errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        NSString *text = ((UITextField *)checkField).text;
        return [text length] >= minLength && [text length] <= maxLength;
    }];
}

- (void)addNumberValidatorForField:(id<ValidatableField>)field
                   errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        NSString *text = ((UITextField *)checkField).text;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return text && [numberFormatter numberFromString:text] != nil;
    }];
}

- (void)addNameValidatorForField:(id<ValidatableField>)field maxLength:(int)maxLength
                 errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        return !IsEmpty(((UITextField*)checkField).text) && ValidateName(((UITextField*)checkField).text, maxLength);
    }];
}

- (void)addEmailValidatorForField:(id<ValidatableField>)field
                  errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        return !IsEmpty(((UITextField*)checkField).text) && ValidateEmailAddress(((UITextField*)checkField).text);
    }];
}

- (void)addConfirmationValidatorForField:(id<ValidatableField>)field
                             sourceField:(id<ValidatableField>)sourceField errorMessageKey:(NSString *)errorMessageKey {
    [self addValidatorForField:field errorMessageKey:errorMessageKey validator:^BOOL(id<ValidatableField> checkField) {
        return [((UITextField*)checkField).text isEqualToString:((UITextField*)sourceField).text];
    }];
}

- (BOOL)showValidationErrors:(NSArray *)errors {
    BOOL scrolled = NO;
    
    if (!errors) {
        return YES;
    }
    
    NSMutableArray *remaingErrors = [NSMutableArray arrayWithArray:errors];
    for (Validator *v in _validators) {
        for (NSString *error in remaingErrors) {
            if ([error hasPrefix:v.fieldName]) {
                [remaingErrors removeObject:error];
                [v.field markAsInvalid: T([_messageKeyPrefix stringByAppendingString:error])];
                //this is the first error, so scroll it into view if possible
                if (!scrolled) {
                    scrolled = [self scrollIntoView:v.field];
                }
                break;
            }
        }
    }
    return [remaingErrors count] == 0;
}

- (NSArray *)validateForErrors {
    NSMutableArray *errors = [NSMutableArray new];
    
    for (Validator *v in _validators) {
        if (!v.validator(v.field)) {
            [errors addObject:v.messageKey];
        }
    }
    
    return [errors count] ? errors : nil;
}

- (BOOL)validate {
    BOOL isValid = YES;
    BOOL scrolled = NO;
    NSLog(@"Sinri 0529 debug start validate");
    for (Validator *v in _validators) {
        if (v.validator(v.field)) {
            [v.field markAsValid];
            NSLog(@"Sinri 0529 debug validator this item ok,isValid=%@",(isValid?@"YES":@"NO"));
        } else {
            NSLog(@"invalid field:: %@", T([_messageKeyPrefix stringByAppendingString:v.messageKey]));
            [v.field markAsInvalid: T([_messageKeyPrefix stringByAppendingString:v.messageKey])];
            //this is the first error, so scroll it into view if possible
            if (!scrolled) {
                scrolled = [self scrollIntoView:v.field];
            }
            isValid = NO;
        }
        NSLog(@"Sinri 0529 debug validator in fieldNAme=%@,desc=%@,isValid=%@",v.fieldName,v.field.description,(isValid?@"YES":@"NO"));
    }
    NSLog(@"Sinri 0529 debug validator over,isValid=%@",(isValid?@"YES":@"NO"));
    return isValid;
}

#pragma mark - Private

- (BOOL)scrollIntoView:(UIView *)view {
    UIScrollView *parent = [self findScrollViewParent:view];
    if (parent) {
        [parent scrollRectToVisible:CGRectInset(view.frame, -6, -6) animated:YES];
        return YES;
    }
    return NO;
}

- (UIScrollView *)findScrollViewParent:(UIView *)view {
    if ([view.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)view.superview;
    }
    if (view.superview) {
        return [self findScrollViewParent:view.superview];
    }
    return nil;
}

@end
