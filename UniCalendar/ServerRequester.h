//
//  ServerRequester.h
//  JSON_test
//
//  Created by Liu Weilong on 2/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequester : NSObject

@property(nonatomic, strong) NSString * result;

@property (nonatomic, strong) NSURLConnection*		conn;
@property (nonatomic, strong) NSMutableData*		receivedData;
@property (nonatomic, strong) NSString*				pageURLString;
@property (nonatomic, strong) NSMutableDictionary*	postVariables;

@property (nonatomic, readwrite, assign)	id		failureTarget;
@property (nonatomic, readwrite, assign)	SEL		failureSelector;

@property (nonatomic, readwrite, assign)	id		loadedTarget;
@property (nonatomic, readwrite, assign)	SEL		loadedSelector;

@property (nonatomic, readwrite, assign)	id		serverDidReceiveTarget;
@property (nonatomic, readwrite, assign)	SEL		serverDidReceiveSelector;

@property (nonatomic, strong) ServerRequester* selfReference;

+(id)serverRequestWithURLString:(NSString*)urlString postVariables:(NSMutableDictionary*)postDictionary timeOutInterval:(float)timeOutInterval retries:(int)retries;
+(id)serverRequestWithURLString:(NSString*)urlString postVariables:(NSMutableDictionary*)postDictionary timeOutInterval:(float)timeOutInterval;
-(void)setOnFailSelector:(id)target				selector:(SEL)selector;
-(void)setOnLoadedSelector:(id)target			selector:(SEL)selector;
-(void)setOnServerDidReceiveSelector:(id)target selector:(SEL)selector;
-(void)makeRequest;
-(void)kill;
-(void)stopRequest;
@end
