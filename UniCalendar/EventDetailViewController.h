//
//  EventDetailViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 7/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) Event *event;

@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;

@end
