//
//  ECalendarPickerView.h
//  ECalendarPickerViewDemo
//
//  Created by measta on 2016/12/4.
//  Copyright © 2016年 meast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECalendarPickerView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) NSArray *enableDayOfWeek;
@property (nonatomic) BOOL enableAllDay;
@property (nonatomic) BOOL enablePastDay;
@property (nonatomic) BOOL enableFutureDay;
@property (nonatomic, copy) void(^callbackOK)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, copy) void(^callbackSelected)(NSInteger day, NSInteger month, NSInteger year);

- (instancetype)initOnView:(UIView *)view;

@end
