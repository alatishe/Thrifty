//
//  HistoryObjC.h
//  Thrifty
//
//  Created by Roslyn Lu on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar/JTCalendar.h"

@interface HistoryObjC : UIViewController<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;

@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;

@property (weak, nonatomic) IBOutlet UIButton *changeModeButton;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@end
