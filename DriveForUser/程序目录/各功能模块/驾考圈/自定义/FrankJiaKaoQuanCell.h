//
//  FrankJiaKaoQuanCell.h
//  Drive
//
//  Created by lichao on 15/11/3.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrankJiaKaoQuanCell : UITableViewCell

@property (nonatomic,strong)UIImageView *titleImage;        //用户头像
@property (nonatomic,strong)UILabel *nameLable;             //用户昵称
@property (nonatomic,strong)UILabel *timeLable;             //发表时间
@property (nonatomic,strong)UILabel *comeLable;             //发表出处
@property (nonatomic,strong)UILabel *addrLable;             //发表地点
//@property (nonatomic,strong)UIImageView *reportImageV;      //用户举报按钮图片
@property (nonatomic,strong)UIButton *reportBtn;            //用户举报按钮

@property (nonatomic,assign)NSInteger containImage;         //0：表示没有图片 1：表示有图片
@property (nonatomic,strong)UILabel *contentLable;          //发表内容
@property (nonatomic,strong)UIImageView *uploadImage1;      //用户上传的图片
@property (nonatomic,strong)UIImageView *uploadImage2;      //用户上传的图片
@property (nonatomic,strong)UIImageView *uploadImage3;      //用户上传的图片
@property (nonatomic,strong)UILabel *pictureCount;          //显示图片的张数

@property (nonatomic,strong)UIView *footView;                //评论下面的View
@property (nonatomic,strong)UIImageView *zanImage;          //点赞图标
@property (nonatomic,strong)UILabel *countZan;              //点赞数
@property (nonatomic,strong)UIButton *zanBtn;               //响应点赞事件
@property (nonatomic,strong)UIImageView *commentImage;      //评论图标
@property (nonatomic,strong)UILabel *countComment;          //评论数
@property (nonatomic,strong)UIButton *commentBtn;           //响应评论事件

@end
