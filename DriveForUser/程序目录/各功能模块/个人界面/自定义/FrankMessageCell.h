//
//  FrankMessageCell.h
//  Drive
//
//  Created by lichao on 15/10/26.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankMessageCell : UITableViewCell

@property(nonatomic,strong)UILabel *bgLab;              //消息边框
@property(nonatomic,strong)UILabel *tLab;               //消息标题
@property (nonatomic,strong)UILabel *titleTime;         //消息时间
@property(nonatomic,strong)UIImageView  *hdImage;       //标题图片
@property(nonatomic,strong)UILabel      *contentLab;    //消息内容

@end
