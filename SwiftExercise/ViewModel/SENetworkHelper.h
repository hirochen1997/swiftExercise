//
//  NetworkHelper.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/19.
//

#ifndef SENetworkHelper_h
#define SENetworkHelper_h

typedef void(^blk)(NSArray<NSDictionary*>* _Nonnull);

@interface SENetworkHelper : NSObject

+ (void) httpGetRequest:(NSString* _Nonnull) url
               callback:(blk _Nonnull ) handle;

@end

#endif /* NetworkHelper_h */
