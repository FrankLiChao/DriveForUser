//
//  FrankCommentCell.h
//  Drive
//
//  Created by lichao on 15/12/29.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankCommentCell : UITableViewCell

@property (nonatomic,strong)UIImageView *hdImageV;  //评论者头像
@property (nonatomic,strong)UILabel  *name;         //评论者昵称
@property (nonatomic,strong)UILabel *time;          //评论时间
@property (nonatomic,strong)UILabel *content;       //评论的类容

@end
