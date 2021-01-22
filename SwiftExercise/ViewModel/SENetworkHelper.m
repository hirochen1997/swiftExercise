//
//  NetworkHelper.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/19.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SENetworkHelper.h"
#import <AVKit/AVKit.h>

@implementation SENetworkHelper
+ (void)httpGetRequest:(NSString *)url
              callback:(blk _Nonnull)handle {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 设置这个才能成功获取json文件
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *receiveStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"get请求成功：%@", jsonArray);
        handle(jsonArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get请求失败：%@", error);
    }];
    
}

+ (void)httpPostRequest:(NSString *)url
               callback:(blk2 _Nonnull)handle {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post请求成功");
        handle();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post请求失败：%@", error);
    }];
}

/*
+ (UIImage*) getFrameOfVideo:(NSString*) url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = true;
    CMTime time = CMTimeMakeWithSeconds(10, 10); // 获取第一秒的截图
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *result = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return result;
}*/

@end


