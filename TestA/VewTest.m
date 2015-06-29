//
//  VewTest.m
//  TestA
//
//  Created by Giang on 6/29/15.
//  Copyright (c) 2015 Giang. All rights reserved.
//

#import "VewTest.h"
#import "UIImageView+WebCache.h"

#import "MyCollectionCell.h"
#import "FBLikeLayout.h"
@interface VewTest ()<UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrMutPartners;
   NSArray *arrPartners;
    
}

@property (nonatomic, strong)   IBOutlet  UICollectionView  *myCollectionView;

@end

@implementation VewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrPartners = [@[@"http://nehealthinsuranceinfo.gov/img/icon_small-business.jpg",
                     @"https://www.gtplanet.net/wp-content/uploads/2012/04/google-chrome-gtplanet.jpg",
                     @"http://media.idownloadblog.com/wp-content/uploads/2013/04/Twitter-2.2-Mac-app-icon-small.png",
                     @"https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Small_SVG_house_icon.svg/300px-Small_SVG_house_icon.svg.png",@"http://xmedia-nguoiduatin.cdn.vccloud.vn/249/2015/6/20/mai-phuong-thuy-hoa-hau-trieu-do-cua-thuong-truong.jpg",@"http://res.vtc.vn/media/vtcnews/2014/08/23/Mai_Phuong_Thuy_02.jpg",@"http://nehealthinsuranceinfo.gov/img/icon_small-business.jpg"] copy];

    arrMutPartners = [NSMutableArray new];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionCell"];
    [self.myCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    [self fnGetImages];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    //Whatever you do here when the reloadData finished
    float newHeight = self.myCollectionView.collectionViewLayout.collectionViewContentSize.height;
    
    CGRect rect= self.myCollectionView.frame;
    rect.size.height=newHeight;
    self.myCollectionView.frame=rect;
    NSLog(@">>> %f", newHeight);
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
                                        UIImage *rsized = image;
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
    
    [self.myCollectionView reloadData];
}




-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(![self.myCollectionView.collectionViewLayout isKindOfClass:[FBLikeLayout class]]){
        FBLikeLayout *layout = [FBLikeLayout new];
        layout.minimumInteritemSpacing = 4;
        layout.singleCellWidth = (MIN(self.myCollectionView.bounds.size.width, self.myCollectionView.bounds.size.height)-self.myCollectionView.contentInset.left-self.myCollectionView.contentInset.right-8)/3.0;
        layout.maxCellSpace = 3;
        layout.forceCellWidthForMinimumInteritemSpacing = YES;
        layout.fullImagePercentageOfOccurrency = 100;
        self.myCollectionView.collectionViewLayout = layout;
        
        [self.myCollectionView reloadData];
    } else {
        //[self.collectionView.collectionViewLayout invalidateLayout];
    }
}
#pragma mark - UICollectionView
//--------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrMutPartners.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"MyCollectionCell";
    
    MyCollectionCell *cell = (MyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    NSDictionary *dic = arrMutPartners[indexPath.row];
    
    cell.imgBrand.image = dic[@"image"];
    
    return cell;
}
//------------------------------------------------------------------------------------------------------------------------

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//------------------------------------------------------------------------------------------------------------------------

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
//------------------------------------------------------------------------------------------------------------------------

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = arrMutPartners[indexPath.row];
    
    UIImage *data = dic[@"image"];

    
    NSLog(@"size %@", NSStringFromCGSize(data.size));
    return data.size;
    
}
@end
