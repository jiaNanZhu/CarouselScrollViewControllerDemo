//
//  ViewController.m
//  CellTEst
//
//  Created by YB on 16/2/15.
//  Copyright © 2016年 YB. All rights reserved.
//

#import "CarouselController.h"
#import "UIImageView+WebCache.h"
//#define SCREEN_SIZE mainFrame

@interface CarouselController ()<UIScrollViewDelegate>
{
    UIScrollView     *mainScroll;
    NSArray          *urlArray;
    UIPageControl    *page;
    CGRect            mainFrame;
    NSTimer          *timer;
}
@end

@implementation CarouselController
- (instancetype)initWithUrlArray:(NSArray *)url andFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        urlArray = url;
        mainFrame = frame;
        self.view.frame = mainFrame;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!urlArray)
    {
        urlArray = @[];
    }
    if (!mainFrame.size.height)
    {
        mainFrame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100);
    }
    [self setScrollView];
    if (urlArray.count>0) {
        [self setIMages];
    }
    [self setpageController];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.frame = mainFrame;
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollView:) userInfo:nil repeats:YES];
}
- (void)setpageController {
    page = [[UIPageControl alloc]init];
    page.frame = CGRectMake(0, mainScroll.frame.size.height - 20 + mainScroll.frame.origin.y, mainFrame.size.width, 20) ;
    [self.view addSubview:page];
    page.numberOfPages = urlArray.count;
    page.currentPage = 0;
    page.defersCurrentPageDisplay = YES;
}
- (void)setScrollView
{
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainFrame.size.width,mainFrame.size.height)];
    [self.view addSubview:mainScroll];
    mainScroll.delegate = self;
    [mainScroll setContentSize:CGSizeMake(mainFrame.size.width * (urlArray.count + 2), 0)];
    [mainScroll setPagingEnabled:YES];
    mainScroll.showsHorizontalScrollIndicator = NO;
    mainScroll.showsVerticalScrollIndicator = NO;
    [mainScroll setContentOffset:CGPointMake(mainFrame.size.width, 0)];
}
- (void)setIMages
{
    for (int i = 0; i<urlArray.count + 2; i++)
    {
        UIScrollView *s = [[UIScrollView alloc]initWithFrame:CGRectMake(i * mainFrame.size.width, 0, mainFrame.size.width, mainFrame.size.height)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, -1, mainFrame.size.width+2, mainFrame.size.height+2)];

        if (i == 0)
        {
            [imageView sd_setImageWithURL:urlArray[urlArray.count-1]];
                    imageView.tag = urlArray.count-1;
        }else if (i == urlArray.count +1)
        {
            [imageView sd_setImageWithURL:urlArray[0]];
            imageView.tag = 0;
        }else
        {
            [imageView sd_setImageWithURL:urlArray[i-1]];
            imageView.tag = i-1;
        }
        [s addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [mainScroll addSubview:s];
    }
}
- (void)imgClick:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    if (self.delegate && [(UIViewController *)self.delegate respondsToSelector:@selector(clickImgAtIndex:)])
    {
        [self.delegate clickImgAtIndex:imgView.tag];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger x = scrollView.contentOffset.x/mainFrame.size.width;
    if (x == urlArray.count +1) {
        [scrollView setContentOffset:CGPointMake(mainFrame.size.width, 0) animated:NO];
        [page setCurrentPage:0];
    }else if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(mainFrame.size.width * urlArray.count,0) animated:NO];
        [page setCurrentPage:urlArray.count-1];
    }else {

        [page setCurrentPage:x-1];
    }
}
- (void)showIn:(UIViewController *)viewController {
    [viewController addChildViewController:self];

    [viewController.view addSubview:self.view];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
}
-(void)dealloc
{
}
-(void)autoScrollView:(id)sender
{
    NSInteger x = mainScroll.contentOffset.x/mainFrame.size.width;
    [mainScroll setContentOffset:CGPointMake((x+1)*mainFrame.size.width, 0) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
