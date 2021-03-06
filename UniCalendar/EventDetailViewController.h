//
//  EventDetailViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 7/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *description;

@end
