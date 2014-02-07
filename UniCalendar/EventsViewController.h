//
//  EventsViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 7/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EventsViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *eventArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) EKEventStore *eventStore;

@end
