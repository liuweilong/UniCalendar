//
//  UserEventsTableViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 24/1/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface UserEventsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

- (NSDate *)dateAtBeginningOfDayForDay:(NSDate *)date;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;

@end
