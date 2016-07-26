//
//  MainVC.m
//  tagitICE
//
//  Created by suhas on 05/07/16.
//  Copyright © 2016 Sands Technologies. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, self.view.bounds.size.width, app.statusBarFrame.size.height)];
    statusBarView.backgroundColor = [UIColor blackColor];

    /*******************************
     *     Initializing menus
     *******************************/
    self.leftMenu = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    
    //    self.rightMenu = [[RightMenuTVC alloc] initWithNibName:@"RightMenuTVC" bundle:nil];
    /*******************************
     *     End Initializing menus
     *******************************/
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){20,15};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
}


- (BOOL)deepnessForLeftMenu
{
    return YES;
}

//- (CGFloat)maxDarknessWhileRightMenu
//{
//    return 0.5f;
//}
-(CGFloat)maxDarknessWhileLeftMenu
{
    return 0.56f;
}
@end
