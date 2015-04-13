//
//  viewData.m
//  超级猜图
//
//  Created by mac on 15/4/13.
//  Copyright (c) 2015年 xing. All rights reserved.
//

#import "viewData.h"



@implementation viewData

- (instancetype)initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
};
+ (instancetype)myViewData:(NSDictionary *) dict
{
    return [[self alloc]initWithDict:dict];
};
+ (NSArray *)questions
{

    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arr addObject:[self myViewData:dict]];
    }
    return arr;
};

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {answer: %@, icon: %@, title: %@, options: %@}", self.class, self, self.answer, self.icon, self.title, self.options];
}

@end
