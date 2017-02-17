//
//  ViewController.m
//  ScrollPage
//
//  Created by Dzy on 17/02/2017.
//  Copyright © 2017 Dzy. All rights reserved.
//

#import "ViewController.h"
#import "ViewFlowLayout.h"
#import "ViewCell.h"

#define SWID [UIScreen mainScreen].bounds.size.width
#define SHEI [UIScreen mainScreen].bounds.size.height

static NSString *const cellID = @"ViewCell";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *SpageView;
@property (weak, nonatomic) IBOutlet UIPageControl *PageView;

@property (nonatomic ) NSMutableArray *data;
@property (nonatomic ) NSInteger page;
@property (nonatomic ) NSInteger dataCount;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    self.PageView.numberOfPages = self.data.count;

    if (self.data.count == 2) {
        self.dataCount = 2;
        [self.data addObject:self.data.firstObject];
        [self.data addObject:self.data[1]];
        [self.SpageView reloadData];
    }

    if (self.data.count>1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.SpageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    self.page = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int i = scrollView.contentOffset.x / 375;
    
    if (i > 1) {
        
        [self.data addObject:self.data.firstObject];
        [self.data removeObjectAtIndex:0];
        self.page ++;
        if (self.page >= self.data.count) {
            self.page = 0;
        }
        
        if (self.dataCount) {
            if (self.page > 1) {
                self.page = 0;
            }
        }
        
    }else if(i < 1){
        
        [self.data insertObject:self.data.lastObject atIndex:0];
        [self.data removeLastObject];
        
        if (self.page == 0) {
            self.page = self.data.count;
        }
        self.page -- ;
        
        if (self.dataCount) {
            if (self.page < 0 ||self.page == 3) {
                self.page = 1;
            }else {
                self.page = 0;
            }
        }
        
    }
    
    self.PageView.currentPage = self.page;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.SpageView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self.SpageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    NSLog(@"%d   %ld",i,(long)indexPath.item);

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.data.count == 1) {
        self.SpageView.scrollEnabled = NO;
    }
    return self.data.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.theTitle.text = [NSString stringWithFormat:@"%@",self.data[indexPath.item]];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
