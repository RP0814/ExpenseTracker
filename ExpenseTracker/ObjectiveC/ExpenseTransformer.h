//
//  ExpenseTransformer.h
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseTransformer : NSObject
+ (NSArray<NSDictionary *> *)transformExpenses:(NSArray<NSDictionary *> *)expenses;

@end


NS_ASSUME_NONNULL_END
