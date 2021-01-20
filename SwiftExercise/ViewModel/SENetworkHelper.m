//
//  NetworkHelper.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/19.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SENetworkHelper.h"

@implementation SENetworkHelper
+ (void)httpGetRequest:(NSString *)url
              callback:(blk)handle {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 设置这个才能成功获取json文件
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *receiveStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"请求成功：%@", jsonArray);
        handle(jsonArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@", error);
    }];
    
}

@end


