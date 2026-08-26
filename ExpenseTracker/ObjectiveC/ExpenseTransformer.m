//
//  ExpenseTransformer.m
//  ExpenseTracker
//
//  Created by Apple on 24/08/26.
//

#import "ExpenseTransformer.h"

@implementation ExpenseTransformer

#pragma mark - Existing Transformation

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

#pragma mark - Objective-C Fetch + Transform

+ (void)fetchAndTransformExpensesFromURL:(NSURL *)url
                              completion:(void (^)(NSArray<NSDictionary *> * _Nullable expenses,
                                                   NSError * _Nullable error))completion
{
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession]
     dataTaskWithURL:url
     completionHandler:^(NSData * _Nullable data,
                         NSURLResponse * _Nullable response,
                         NSError * _Nullable error) {

        if (error != nil) {
            completion(nil, error);
            return;
        }

        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {

            NSError *responseError =
            [NSError errorWithDomain:@"ExpenseAPIError"
                                code:1001
                            userInfo:@{
                                NSLocalizedDescriptionKey:
                                    @"Invalid HTTP response."
                            }];

            completion(nil, responseError);
            return;
        }

        NSHTTPURLResponse *httpResponse =
        (NSHTTPURLResponse *)response;

        if (httpResponse.statusCode < 200 ||
            httpResponse.statusCode >= 300) {

            NSError *statusError =
            [NSError errorWithDomain:@"ExpenseAPIError"
                                code:httpResponse.statusCode
                            userInfo:@{
                                NSLocalizedDescriptionKey:
                                    @"The server returned an unsuccessful status code."
                            }];

            completion(nil, statusError);
            return;
        }

        if (data == nil) {

            NSError *dataError =
            [NSError errorWithDomain:@"ExpenseAPIError"
                                code:1002
                            userInfo:@{
                                NSLocalizedDescriptionKey:
                                    @"No data was returned by the server."
                            }];

            completion(nil, dataError);
            return;
        }

        NSError *jsonError = nil;

        id jsonObject =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:0
                                          error:&jsonError];

        if (jsonError != nil) {
            completion(nil, jsonError);
            return;
        }

        if (![jsonObject isKindOfClass:[NSArray class]]) {

            NSError *formatError =
            [NSError errorWithDomain:@"ExpenseAPIError"
                                code:1003
                            userInfo:@{
                                NSLocalizedDescriptionKey:
                                    @"Expected the API response to be an array."
                            }];

            completion(nil, formatError);
            return;
        }

        NSArray *rawExpenses = (NSArray *)jsonObject;

        NSMutableArray<NSDictionary *> *expenseDictionaries =
        [NSMutableArray array];

        for (id object in rawExpenses) {

            if ([object isKindOfClass:[NSDictionary class]]) {
                [expenseDictionaries addObject:object];
            }
        }

        NSArray<NSDictionary *> *transformedExpenses =
        [self transformExpenses:expenseDictionaries];

        completion(transformedExpenses, nil);
    }];

    [task resume];
}

@end
