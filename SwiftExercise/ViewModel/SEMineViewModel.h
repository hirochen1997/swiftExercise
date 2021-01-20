//
//  MineViewModel.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/18.
//

#ifndef SEMineViewModel_h
#define SEMineViewModel_h

#import "SEOCDataStruct.h"

@interface SEMineViewModel : NSObject

@property (nonatomic) NSMutableDictionary *datas;
@property (nonatomic,copy,readonly) NSString *infoSavePath;

- (void) fetchData;


@end

#endif /* MineViewModel_h */
