//
// REValidator.h
// REValidation
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface REValidator : NSObject

@property (strong, readonly, nonatomic) NSDictionary *parameters;
@property (copy, nonatomic) NSError *(^inlineValidation)(id object, NSString *name);

///-----------------------------
/// @name Getting Validator Instance
///-----------------------------

+ (instancetype)validator;
+ (instancetype)validatorWithParameters:(NSDictionary *)parameters;
+ (instancetype)validatorWithInlineValidation:(NSError *(^)(id object, NSString *name))validation;

///-----------------------------
/// @name Configuring Representation
///-----------------------------

+ (NSString *)name;
+ (NSDictionary *)parseParameterString:(NSString *)string;

///-----------------------------
/// @name Validating Objects
///-----------------------------

+ (NSError *)validateObject:(NSObject *)object variableName:(NSString *)name parameters:(NSDictionary *)parameters;
+ (NSError *)validateObject:(NSObject *)object variableName:(NSString *)name validation:(NSError *(^)(id object, NSString *name))validation;

@end
