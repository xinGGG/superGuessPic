//
//  viewData.h
//  超级猜图
//
//  Created by mac on 15/4/13.
//  Copyright (c) 2015年 xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewData : UIView
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *options;

- (instancetype)initWithDict:(NSDictionary *) dict;
+ (instancetype)myViewData:(NSDictionary *) dict;
+(NSArray *)questions;

@end
