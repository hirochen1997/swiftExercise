//
//  MineViewModel.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/18.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SEMineViewModel.h"

@interface SEMineViewModel ()

@property  NSString* infoSavePath;

@end


@implementation SEMineViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.datas = [NSMutableDictionary dictionary];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.infoSavePath = [docPath stringByAppendingPathComponent:@"MineViewData.json"];
        [self fetchData];
    }
    return self;
}

- (void)fetchData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.infoSavePath]) {
        // 存在就读取json数据反序列化
        NSLog(@"File Exist");
        NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:self.infoSavePath];
        [inputStream open];
        id streamObject = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *dict = (NSMutableDictionary*)streamObject;
        [inputStream close];
        
        // 初始化数据
        self.datas[@"userName"] = dict[@"userName"];
        self.datas[@"userImg"] = dict[@"userImg"];
        
    } else {
        // 不存在就创建
        [fileManager createFileAtPath:self.infoSavePath contents:nil attributes:nil];
        
        // 初始化数据
        self.datas[@"userName"] = @"空";
        self.datas[@"userImg"] = @"";
    }
    
}

@end
