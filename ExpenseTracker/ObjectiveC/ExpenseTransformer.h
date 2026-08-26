//
//  ExpenseTransformer.h
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseTransformer : NSObject
/// Existing transformation API.
///
/// This method is intentionally kept unchanged so the existing
/// Swift networking implementation continues to work.
+ (NSArray<NSDictionary *> *)transformExpenses:(NSArray<NSDictionary *> *)expenses;

/// New Objective-C networking + transformation API.
///
/// This method fetches the JSON, parses it, validates the raw
/// expense dictionaries and returns transformed expenses.
+ (void)fetchAndTransformExpensesFromURL:(NSURL *)url
                              completion:(void (^)(NSArray<NSDictionary *> * _Nullable expenses,
                                                   NSError * _Nullable error))completion;


@end


NS_ASSUME_NONNULL_END
