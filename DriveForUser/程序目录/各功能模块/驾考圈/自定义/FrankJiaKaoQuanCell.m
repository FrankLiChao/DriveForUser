//
//  FrankJiaKaoQuanCell.m
//  Drive
//
//  Created by lichao on 15/11/3.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankJiaKaoQuanCell.h"
#import "UIImage+Cut.h"
@implementation FrankJiaKaoQuanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGFloat hight = 12*widthRate;
        
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, hight, 40*widthRate, 40*widthRate)];
//        self.titleImage.backgroundColor = [lhColor colorFromHexRGB:mainColorStr];
        [self.titleImage setImage:imageWithName(@"touxiang_car")];
        self.titleImage.layer.cornerRadius = 20*widthRate;
        self.titleImage.layer.masksToBounds = YES;
        [self addSubview:self.titleImage];
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, hight, DeviceMaxWidth-70*widthRate, 20*widthRate)];
        self.nameLable.text = @"优品学车";
        self.nameLable.font = [UIFont systemFontOfSize:15];
        self.nameLable.textColor = [lhColor colorFromHexRGB:@"221714"];
        [self addSubview:self.nameLable];
        
        self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reportBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, hight, 30*widthRate, 30*widthRate);
        [self.reportBtn setImage:imageWithName(@"reportImage") forState:UIControlStateNormal];
        [self addSubview:self.reportBtn];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(60*widthRate, hight+20*widthRate, DeviceMaxWidth-70*widthRate, 20*widthRate)];
        self.timeLable.text = @"2015年11月3日";
        self.timeLable.font = [UIFont systemFontOfSize:11];
        self.timeLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        [self addSubview:self.timeLable];
        
        hight += 50*widthRate;
        
        NSLog(@"hight = %f",hight);
        self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, DeviceMaxWidth-20*widthRate, 40*widthRate)];
//        self.contentLable.text = @"快来说点什么吧！";
        self.contentLable.font = [UIFont systemFontOfSize:15];
        self.contentLable.textColor = [lhColor colorFromHexRGB:@"221714"];
//        self.contentLable.numberOfLines = 0;
//        [self.contentLable sizeToFit];
        [self addSubview:self.contentLable];
        
        hight += self.contentLable.frame.size.height+10*widthRate;

        self.uploadImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, hight, (DeviceMaxWidth-30*widthRate)/3, 100*widthRate)];
//        [self.uploadImage1 setImage:imageWithName(@"testImage")];
//        self.uploadImage1.layer.allowsEdgeAntialiasing = YES;
//        self.uploadImage1.layer.masksToBounds = YES;
        self.uploadImage1.userInteractionEnabled = YES;
//        self.uploadImage1.image = [self.uploadImage1.image clipImageWithScaleWithsize:CGSizeMake(2*((DeviceMaxWidth-30*widthRate)/3), 2*100*widthRate)];
        [self addSubview:self.uploadImage1];
        
        self.uploadImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate+(DeviceMaxWidth-30*widthRate)/3, hight, (DeviceMaxWidth-30*widthRate)/3, 100*widthRate)];
//        self.uploadImage2.backgroundColor = [UIColor grayColor];
        self.uploadImage2.userInteractionEnabled = YES;
        [self addSubview:self.uploadImage2];
        
        self.uploadImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(20*widthRate+(DeviceMaxWidth-30*widthRate)/3*2, hight, (DeviceMaxWidth-30*widthRate)/3, 100*widthRate)];
//        self.uploadImage3.backgroundColor = [UIColor grayColor];
        self.uploadImage3.userInteractionEnabled = YES;
        [self addSubview:self.uploadImage3];
        
        self.pictureCount = [[UILabel alloc] initWithFrame:CGRectMake(290*widthRate/3-25*widthRate, 85*widthRate, 25*widthRate, 15*widthRate)];
        self.pictureCount.hidden = YES;
//        self.pictureCount.text = @"5张";
        self.pictureCount.font = [UIFont systemFontOfSize:13];
        self.pictureCount.textColor = [UIColor whiteColor];
        self.pictureCount.textAlignment = NSTextAlignmentCenter;
        self.pictureCount.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:152.0/255.0 blue:220.0/255.0 alpha:0.5];
        [self.uploadImage3 addSubview:self.pictureCount];
        
        hight += self.uploadImage1.frame.size.height+12*widthRate;
        
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 35*widthRate)];
        self.footView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.footView];
        
        self.comeLable = [[UILabel alloc] initWithFrame:CGRectMake(5*widthRate, 8*widthRate, 50*widthRate, 16*widthRate)];
        self.comeLable.text = @"考前许愿";
        self.comeLable.font = [UIFont systemFontOfSize:10];
        self.comeLable.textColor = [lhColor colorFromHexRGB:mainColorStr];
        self.comeLable.textAlignment = NSTextAlignmentCenter;
        self.comeLable.layer.cornerRadius = 7*widthRate;
        self.comeLable.layer.borderWidth = 0.5;
        self.comeLable.layer.borderColor = [[lhColor colorFromHexRGB:mainColorStr] CGColor];
        [self.footView addSubview:self.comeLable];
        
        self.addrLable = [[UILabel alloc] initWithFrame:CGRectMake(65*widthRate, 5, 50*widthRate, 20*widthRate)];
        self.addrLable.text = @"成都市";
        self.addrLable.font = [UIFont systemFontOfSize:13];
        self.addrLable.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
        [self.footView addSubview:self.addrLable];
        
        self.zanImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-110*widthRate, 2*widthRate, 25*widthRate, 25*widthRate)];
        [self.zanImage setImage:imageWithName(@"zan_No")];
        [self.footView addSubview:self.zanImage];
        
        self.countZan = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-83*widthRate, 8*widthRate, 20*widthRate, 15*widthRate)];
        self.countZan.text = @"10";
        self.countZan.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.countZan.font = [UIFont systemFontOfSize:13];
        [self.footView addSubview:self.countZan];
        
        self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zanBtn.frame = CGRectMake(DeviceMaxWidth-110*widthRate, 0*widthRate, 40*widthRate, 35*widthRate);
        [self.footView addSubview:self.zanBtn];
        
        self.commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-60*widthRate, 2*widthRate, 25*widthRate, 25*widthRate)];
        [self.commentImage setImage:imageWithName(@"message_D")];
        [self.footView addSubview:self.commentImage];
        
        self.countComment = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-33*widthRate, 8*widthRate, 20*widthRate, 15*widthRate)];
        self.countComment.text = @"10";
        self.countComment.textColor = [lhColor colorFromHexRGB:contentTitleColorStr1];
        self.countComment.font = [UIFont systemFontOfSize:13];
        [self.footView addSubview:self.countComment];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.frame = CGRectMake(DeviceMaxWidth-50*widthRate, 0*widthRate, 40*widthRate, 35*widthRate);
        self.commentBtn.selected = NO;
        [self.footView addSubview:self.commentBtn];
        
        hight += self.footView.frame.size.height;
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(5*widthRate, 35*widthRate-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
        lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
        [self.footView addSubview:lineV];
    }
    return self;
}

@end
