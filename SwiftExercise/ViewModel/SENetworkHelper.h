//
//  NetworkHelper.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/19.
//

#ifndef SENetworkHelper_h
#define SENetworkHelper_h

typedef void(^blk)(NSArray<NSDictionary*>* _Nonnull);
typedef void(^blk2)(void);

@interface SENetworkHelper : NSObject

+ (void) httpGetRequest:(NSString* _Nonnull) url
               callback:(blk _Nonnull ) handle;

+ (void) httpPostRequest:(NSString* _Nonnull) url
                callback:(blk2 _Nonnull) handle;

//+ (UIImage* _Nonnull) getFrameOfVideo:(NSString* _Nonnull) url;

@end

#endif /* NetworkHelper_h */
