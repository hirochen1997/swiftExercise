//
//  MineViewModel.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/18.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "MineViewModel.h"

@implementation MineViewModel

@synthesize datas;
@synthesize infoSavePath;

- (instancetype)init {
    self = [super init];
    if (self) {
        datas = [NSMutableDictionary dictionary];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        infoSavePath = [docPath stringByAppendingPathComponent:@"MineViewData.json"];
        [self fetchData];
    }
    return self;
}

- (void)fetchData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:infoSavePath]) {
        // 存在就读取json数据反序列化
        NSLog(@"File Exist");
        NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:infoSavePath];
        [inputStream open];
        id streamObject = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *dict = (NSMutableDictionary*)streamObject;
        [inputStream close];
        
        // 初始化数据
        datas[@"userName"] = dict[@"userName"];
        datas[@"userImg"] = dict[@"userImg"];
        
    } else {
        // 不存在就创建
        [fileManager createFileAtPath:infoSavePath contents:nil attributes:nil];
        
        // 初始化数据
        datas[@"userName"] = @"空";
        datas[@"userImg"] = @"";
    }
    
    
}

@end
