//
//  ExpenseTransformer.m
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

#import "ExpenseTransformer.h"

@implementation ExpenseTransformer

+ (NSArray<NSDictionary *> *)transformExpenses:(NSArray<NSDictionary *> *)expenses {
    NSMutableArray<NSDictionary *> *transformedExpenses = [NSMutableArray array];

    for (NSDictionary *expense in expenses) {
        NSString *expenseId = expense[@"id"];
        NSString *title = expense[@"title"];
        NSNumber *amount = expense[@"amount"];
        NSString *date = expense[@"date"];

        if (![expenseId isKindOfClass:[NSString class]] ||
            ![title isKindOfClass:[NSString class]] ||
            ![amount isKindOfClass:[NSNumber class]] ||
            ![date isKindOfClass:[NSString class]]) {
            continue;
        }

        NSDictionary *transformedExpense = @{
            @"id": expenseId,
            @"title": title,
            @"amount": amount,
            @"date": date
        };

        [transformedExpenses addObject:transformedExpense];
    }

    return [transformedExpenses copy];
}

@end
