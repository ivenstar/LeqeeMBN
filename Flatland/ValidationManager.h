//
//  ValidationManager.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 15.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ValidatableField <NSObject>

- (void)markAsInvalid:(NSString *)errorMesage;
- (void)markAsValid;

@end

@interface ValidationManager : NSObject

/// initialize a validation manager with the given error message key prefix which is preprended to all error message keys
- (id) initWithMessageKeyPrefix:(NSString *)prefix;

/// Adds a generic validation block to the receiver.
- (void)addValidatorForField:(id<ValidatableField>)field
             errorMessageKey:(NSString *)errorMessageKey
                   validator:(BOOL(^)(id<ValidatableField>checkField))validator;

/// Adds a validation that requires fields to be not empty.
- (void)addRequiredValidatorForField:(id<ValidatableField>)field
                     errorMessageKey:(NSString *)errorMessageKey;

/// Adds a validation for string between minLength and maxLength.
- (void)addLengthValidatorForField:(id<ValidatableField>)field
                         minLength:(int)minLength
                         maxLength:(int)maxLength
                   errorMessageKey:(NSString *)errorMessageKey;

/// Ads a validation based on the given regular expression.
- (void)addRegExpValidatorForField:(id<ValidatableField>)field
                            regExp:(NSString *)regExp
                   errorMessageKey:(NSString *)errorMessageKey;

/// Adds a validation for numbers
- (void)addNumberValidatorForField:(id<ValidatableField>)field
                   errorMessageKey:(NSString *)errorMessageKey;

/// Adds a special validation for names which must be non-empty and of a certain length.
- (void)addNameValidatorForField:(id<ValidatableField>)field
                       maxLength:(int)maxLength
                 errorMessageKey:(NSString *)errorMessageKey;

/// Adds a special validation for email addresses (up to 50 characters) which must be non-empty.
- (void)addEmailValidatorForField:(id<ValidatableField>)field
                  errorMessageKey:(NSString *)errorMessageKey;

/// Adds a special validation for a field which must be identical to another field.
- (void)addConfirmationValidatorForField:(id<ValidatableField>)field
                             sourceField:(id<ValidatableField>)sourceField
                         errorMessageKey:(NSString *)errorMessageKey;

/// Displays the given validation errors. Fields are matched by errorMessageKey.
/// Returns NO if it couldn't handle all the errors and YES otherwise.
- (BOOL)showValidationErrors:(NSArray *)errors;

/// Validates everything, returns a list of errors for -showValidationErrors: or nil.
- (NSArray *)validateForErrors;

/// Validates everything, mark the fields accordingly and returns NO on errors.
- (BOOL)validate;

@end
