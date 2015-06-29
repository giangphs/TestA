//
//  ViewController.m
//  TestA
//
//  Created by Giang on 6/29/15.
//  Copyright (c) 2015 Giang. All rights reserved.
//

#import "ViewController.h"
#import "VewTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fnTest:(id)sender {
    VewTest *vc = [[VewTest alloc] initWithNibName:@"VewTest" bundle:nil];
    
    [self presentViewController:vc animated:YES completion:^{
    }];
    
}

@end
