//
//  VewTest.m
//  TestA
//
//  Created by Giang on 6/29/15.
//  Copyright (c) 2015 Giang. All rights reserved.
//

#import "VewTest.h"
#import "UIImageView+WebCache.h"

@interface VewTest ()
{
    NSMutableArray *arrMutPartners;
   NSArray *arrPartners;
    
}
@end

@implementation VewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrPartners = [@[@"http://nehealthinsuranceinfo.gov/img/icon_small-business.jpg",
                     @"https://www.gtplanet.net/wp-content/uploads/2012/04/google-chrome-gtplanet.jpg",
                     @"http://media.idownloadblog.com/wp-content/uploads/2013/04/Twitter-2.2-Mac-app-icon-small.png",
                     @"https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Small_SVG_house_icon.svg/300px-Small_SVG_house_icon.svg.png" ] copy];

    arrMutPartners = [NSMutableArray new];
    
    [self fnGetImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*) fnResize :(UIImage*)img
{
    float actualHeight = img.size.height;
    float actualWidth = img.size.width;
    
    float imgRatio = actualWidth/actualHeight;

    float fixHeight = 80;
    
    imgRatio = fixHeight / actualHeight;
    actualWidth = imgRatio * actualWidth;
    actualHeight = fixHeight;

            
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [img drawInRect:rect];
    UIImage *returnImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImg;
}

-(void) fnGetImages
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    //Download partners
    if (arrPartners.count > 0) {
        
        
        __block int iCount = (int) arrPartners.count;
        
        for (NSString*strPath in arrPartners) {
            NSURL *url  = nil;
            url = [NSURL URLWithString: strPath];
            
            [manager downloadImageWithURL:url
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    
                                    iCount -= 1;
                                    
                                    if (image) {
                                        UIImage *rsized = [self fnResize:image];
                                        [arrMutPartners addObject:@{ @"image":rsized,
                                                                     @"size": [NSNumber numberWithFloat:rsized.size.width]
                                                                     }];                                    }
                                    

                                    
                                    if (iCount == 0) {
                                        NSLog(@"DONE");
                                        [self fnCalcPopview];
                                    }

                                }];
            

            
        }
    }

}

-(void) fnCalcPopview
{
    NSLog(@"%@", arrMutPartners[0]);
}

@end
