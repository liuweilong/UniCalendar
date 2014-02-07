//
//  EventDetailViewController.m
//  UniCalendar
//
//  Created by Liu Weilong on 7/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.event = [[Event alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    
    self.eventTitle.text = self.event.title;
    self.description.text = self.event.description;
}

- (IBAction)addEventToCalendar:(id)sender {
    EKEvent *newEvent = [EKEvent eventWithEventStore:self.eventStore];
    
    [newEvent setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    
    newEvent.title = self.event.title;
    newEvent.startDate = self.event.startDate;
    newEvent.endDate = self.event.endDate;
    newEvent.allDay = self.event.allDay;
    newEvent.notes = self.event.description;
    
    NSError *err;
    
    [self.eventStore saveEvent:newEvent span:EKSpanThisEvent commit:YES error:&err];
    if (err) {
        NSLog(@"Failed, error:%@", err.localizedDescription);
    } else {
        NSLog(@"Successed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
