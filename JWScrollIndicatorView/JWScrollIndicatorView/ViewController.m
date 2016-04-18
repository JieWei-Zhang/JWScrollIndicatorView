//
//  ViewController.m
//  JWScrollIndicatorView
//
//  Created by Vinhome on 16/4/15.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Indicator.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.tableView.contentInset=UIEdgeInsetsMake(-20, 0, 0, 0);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.tableView.indicator) {
        [_tableView registerILSIndicator];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(<#NSString * _Nonnull format, ...#>)
//    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
//        [self infoPanelDidScroll:scrollView atPoint:CGPointMake(indicator.center.x,scrollView.contentSize.height-1)];
//    } else {
//        [self infoPanelDidScroll:scrollView atPoint:indicator.center];
//        
//       // NSLog(@"_________%f________%f",indicator.center.x,indicator.center.y);
//    }
    
    
    CGRect f = [self.tableView convertRect:scrollView.indicator.slider.frame fromView:self.tableView.indicator];
   //  NSLog(@"_________%f________%f",f.origin.x+25/2,f.origin.y+25/2);
    
   [self infoPanelDidScroll:scrollView atPoint:CGPointMake(f.origin.x+40/2,f.origin.y+40/2)];
  //  scrollView.contentSize.height-[UIScreen mainScreen].bounds.size.height;
    
  //  NSLog(@"_____%f_____%d____%f",scrollView.contentOffset.y,44*50,[UIScreen mainScreen].bounds.size.height);
    
    
//    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height) {
//        [self infoPanelDidScroll:self.tableView atPoint:CGPointMake(scrollView.contentOffset.x,self.tableView.contentSize.height-1)];
//    } else {
//        [self infoPanelDidScroll:self.tableView atPoint:CGPointMake(scrollView.indicator.center.x,self.tableView.indicator.slider.center.y)];
//        
//       // NSLog(@"_________%f________%f",self.tableView.indicator.center.x,self.tableView.indicator.center.y);
//    }
}
-(void)infoPanelDidScroll:(UIScrollView*)scrollView atPoint:(CGPoint)point {
    
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"_________%ld",(long)indexPath.row);
    
    [self.tableView.indicator.slider.sliderIcon  setTitle:[NSString  stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateNormal];
}
//-(void)infoPanelDidScroll:(UIScrollView *)scrollView atPoint:(CGPoint)point {
//    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
//    
//    NSLog(@"_________%ld",(long)indexPath.row);
//}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
@end
