//
//  ViewController.m
//  超级猜图
//
//  Created by mac on 15/4/13.
//  Copyright (c) 2015年 xing. All rights reserved.
//

#import "ViewController.h"
#import "viewData.h"
@interface ViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleNum;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign,nonatomic) int index;

@property (nonatomic,strong) UIButton *cover;
@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

@property (weak, nonatomic) IBOutlet UIButton *sroce;
@end

@implementation ViewController

-(UIButton *)cover{
    if (_cover ==nil) {
        _cover = [[UIButton alloc]initWithFrame:self.view.frame];
        _cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _cover.alpha = 0;
        [self.view addSubview:_cover];
        
        [_cover addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
        self.cover = _cover;
    }
    return _cover;
}

-(NSArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = [viewData questions];
    }
    return _dataArray;
}

// 调整状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.index = -1;
    [self nextImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define kNameW 35
#define kNameH 35
#define kMargin 10
#define kTotalCol 7

//下一张
- (IBAction)nextImage{
    
    self.index++;
    if (self.index ==self.dataArray.count) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜你" message:@"已通关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"知道", nil];
        [self.view addSubview:alert];
        
        [alert show];
        return;
    }
    
    viewData *data = self.dataArray[self.index];
    self.titleNum.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.dataArray.count];
    self.titleLabel.text = data.title;
    [self.iconButton setImage:[UIImage imageNamed:data.icon] forState:UIControlStateNormal];
    
    
    
    if (self.index < self.dataArray.count-1) {
        self.nextBtn.enabled = YES;
    }else {
        self.nextBtn.enabled = NO;
    }
    
    
    //清除按钮
    for (UIView *view in self.answerView.subviews) {
        [view removeFromSuperview];
    }
    
    //设置答案按钮
    [self setupAnswer:data];
    
    //设置备选答案
    [self setupOptions:data];
    
}

// 设置答案
- (void)setupAnswer:(viewData *)data{
    
    CGFloat answerW = self.answerView.bounds.size.width;
    int length = data.answer.length;
    CGFloat answerX = (answerW - kNameW *length - kMargin *(length -1) )*0.5;
    for (int i = 0 ; i < length  ; i++) {
        CGFloat x = answerX + i * (kMargin + kNameW);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, kNameW, kNameH)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.answerView addSubview:btn];
    }
}

// 设置备选答案
- (void)setupOptions:(viewData *)data{
    
    if (self.optionsView.subviews.count != data.options.count) {
        
        for (UIView *view in self.optionsView.subviews){
            [view removeFromSuperview];
        }
        
        CGFloat optionsW = self.answerView.bounds.size.width;
        int optionsCount = data.options.count;
        CGFloat optionsX = (optionsW - kNameW *kTotalCol - kMargin *(kTotalCol -1))*0.5;
        for (int i = 0 ; i < optionsCount  ; i++) {
            
            int row = i / kTotalCol;
            int col = i % kTotalCol;
            
            CGFloat x = optionsX + col *(kNameW + kMargin);
            CGFloat y = row * (kNameH + 10);
            UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(x, y, kNameW, kNameH)];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //设置点击事件
            [btn addTarget:self action:@selector(clickOptions:) forControlEvents:UIControlEventTouchUpInside];
            [self.optionsView addSubview:btn];
        }
        NSLog(@"创建");
    }
    int i = 0;
    for (UIButton *btn  in self.optionsView.subviews) {
        [btn setTitle:data.options[i++] forState:UIControlStateNormal];
        btn.hidden = NO;
    }
    
}

/**
 *  点击备选答案
 *
 *  @param btn <#btn description#>
 */
- (void)clickOptions:(UIButton *)btn {
    
    //找最后文字为空的按钮
    UIButton *lastBtn = [self firstAnswerButton];
    
    
    // 找不到为空 说明已满
    if (lastBtn ==nil) {
        return;
    }
    
    //设置答案区
    [lastBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    
    //隐藏
    btn.hidden = YES;
    //判断是否正确
    [self judge];
    
}

/**
 *  判断答案是否正确
 */
- (void) judge{
    
    BOOL isFull = YES;
    NSMutableString *strM = [NSMutableString string];
    //遍历答案，组合字符串
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0) {
            isFull = NO;
            break;
        }else
        {
            [strM appendString:btn.currentTitle];
        }
    }
    //答案已填满，以下判断是否正确
    if (isFull) {
        NSLog(@"已填满");
        viewData *data = self.dataArray[self.index];
        if ([strM isEqualToString:data.answer]) {
            NSLog(@"答对了");
            [self setAnswerButtonsColor:[UIColor blueColor]];
            [self performSelector:@selector(nextImage) withObject:nil afterDelay:0.5];
            
            //加分
            int sroce =  self.sroce.currentTitle.intValue ;
            sroce += 100 ;
            [self.sroce setTitle:[NSString stringWithFormat:@"%d",sroce] forState:UIControlStateNormal];
        }else{
            NSLog(@"答错了");
            [self setAnswerButtonsColor:[UIColor redColor]];
            
            //减分
            int sroce =  self.sroce.currentTitle.intValue ;
            sroce -= 100 ;
            [self.sroce setTitle:[NSString stringWithFormat:@"%d",sroce] forState:UIControlStateNormal];
        }
    }
    
}

/** 修改答题区按钮的颜色 */
- (void)setAnswerButtonsColor:(UIColor *)color
{
    for (UIButton *btn in self.answerView.subviews) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}

- (UIButton *)firstAnswerButton{
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            return btn;
        }
    }
    return nil;
}

//查看大图
- (IBAction)bigImage{
    
    /**
     *  创建遮罩
     */
    if (self.cover.alpha == 0) {
        [self cover];
        // 按钮放大
        CGFloat w = self.view.bounds.size.width;
        CGFloat h = w;
        CGFloat y = (self.view.bounds.size.height - h)* 0.5;
        // 按钮放在最前面
        [self.view bringSubviewToFront:self.iconButton];
        
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame = CGRectMake(0,y,w,h);
            self.cover.alpha = 1.0;
        }];
    }else
    {
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame = CGRectMake(85, 85, 150, 150);
            self.cover.alpha = 0;
        }];
    }
    
    
}



@end
