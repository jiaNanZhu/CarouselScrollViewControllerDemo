//
//  ViewController.h
//  CellTEst
//
//  Created by YB on 16/2/15.
//  Copyright © 2016年 YB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CarouselControllerDelegate
- (void)clickImgAtIndex:(NSInteger)index;
@end
@interface CarouselController:UIViewController
@property (nonatomic,strong) id<CarouselControllerDelegate>delegate;
- (instancetype)initWithUrlArray:(NSArray *)url andFrame:(CGRect)frame;
- (void)showIn:(UIViewController *)viewController;
@end

