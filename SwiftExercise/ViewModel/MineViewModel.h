//
//  MineViewModel.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/18.
//

#ifndef MineViewModel_h
#define MineViewModel_h

#import "OCDataStruct.h"

@interface MineViewModel : NSObject

@property (readwrite) NSMutableDictionary *datas;
@property (readonly) NSString *infoSavePath;

- (void) fetchData;


@end

#endif /* MineViewModel_h */
