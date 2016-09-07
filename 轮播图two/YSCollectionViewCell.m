//
//  YSCollectionViewCell.m
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import "YSCollectionViewCell.h"
#import "HMObjcSugar.h"

@interface YSCollectionViewCell ()

@end

@implementation YSCollectionViewCell {
    UIImageView * _imageView;
}
- (void)setUrl:(NSURL *)url{
    _url = url;
    NSData * data = [NSData dataWithContentsOfURL:_url];
    UIImage * image = [UIImage imageWithData:data];
    _imageView.image = image;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigBig:) name:@"zys" object:nil];
}


- (void)bigBig:(NSNotification*)info {
        NSDictionary * dict = (NSDictionary *)info.userInfo;
        NSString * dic = dict[@"offset"];
        CGFloat off = dic.floatValue;
//        NSLog(@"%f",off);
        _imageView.hm_viewSize = CGSizeMake(375, 200 - off- 1);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end
