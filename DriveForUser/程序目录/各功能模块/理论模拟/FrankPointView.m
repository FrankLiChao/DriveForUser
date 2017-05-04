//
//  FrankPointView.m
//  Drive
//
//  Created by lichao on 15/8/5.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "FrankPointView.h"

@interface FrankPointView ()

@end

@implementation FrankPointView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    switch (_pointForIndex) {
        case 0:
            [self createStandardView];
            break;
        case 1:
            [self createDetailedView];
            break;
        case 2:
            [self createGesturesView];
            break;
        case 3:
            [self createDrunkendriving];
            break;
        case 4:
            [self createConfuseview];
            break;
        default:
            break;
    }
    
    
}

-(void)createScrollView{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}

-(void)createStandardView{
    [[lhColor shareColor]originalInit:self title:@"合格标准" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    textForLable1 = [[UILabel alloc] init];
    textForLable1.text = @"一、 考试内容\n\n①  道路交通安全法律、法规和规章;\n\n②  交通信号及其含义;\n\n③  安全行车、文明驾驶知识;\n\n④  高速公路、山区道路、桥梁、隧道、夜间、恶劣气象和复杂道路条件下的安全驾驶知识;\n\n⑤  出现爆胎、转向失控、控制失灵等紧急情况时的临危处置知识;\n\n⑥  机动车总体构造、主要安全装置常识、日常检查和维护基本知识;\n\n⑦  发生交通事故后的自救、急救等基本知识，以及常见危险物品知识。\n";
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc]initWithString:textForLable1.text];
    [title1 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 7)];
    
    textForLable1.numberOfLines = 0;
    textForLable1.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:textForLable1.text font:textForLable1.font];
    textForLable1.frame = CGRectMake(10, 10, rect.width-10, rect.height);
    textForLable1.attributedText = title1;
    [scrollView addSubview:textForLable1];
    
    UILabel *textForlabel2 = [[UILabel alloc] init];
    textForlabel2.text = @"二、 合格标准\n\n      满分为100分，成绩达到90分的为合格。\n\n      考试由申请人通过计算机闭卷答题，考试时间为45分钟。科目一共考试100道题，由计算机考试系统从考试题库中随机抽取生成。\n\n      科目一考试重在掌握科学的学习方法，反复记忆练习。\n";
    textForlabel2.numberOfLines = 0;
    textForlabel2.font = [UIFont systemFontOfSize:14.0];
    CGSize rect1 = [self sizeWithString:textForlabel2.text font:textForlabel2.font];
    textForlabel2.frame = CGRectMake(10, 15+rect.height, rect1.width-10, rect1.height);
    NSMutableAttributedString * title2 = [[NSMutableAttributedString alloc]initWithString:textForlabel2.text];
    [title2 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 7)];
    textForlabel2.attributedText = title2;
    [scrollView addSubview:textForlabel2];
    scrollView.contentSize = CGSizeMake(DeviceMaxWidth,64+10+rect.height+rect1.height);
}

-(void)createDetailedView{
    [[lhColor shareColor]originalInit:self title:@"扣分细则" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *detailed = [[UILabel alloc] init];
    detailed.text = @"一、 机动车驾驶人有下列违法行为之一，一次记12分:\n\n①  驾驶与准驾车型不符的机动车的;\n\n②  饮酒后驾驶机动车的;\n\n③  驾驶营运客车(不包括公共汽车)、校车载人超过核定人数20%以上的;\n\n④  造成交通事故后逃逸，尚不构成犯罪的;\n\n⑤  上道路行驶的机动车未悬挂机动车号牌的，或者故意遮挡、污损、不按规定安装机动车号牌的;\n\n⑥  使用伪造、变造的机动车号牌、行驶证、驾驶证、校车标牌或者使用其他机动车号牌、行驶证的;\n\n⑦  驾驶机动车在高速公路上倒车、逆行、穿越中央分隔带掉头的;\n\n⑧  驾驶营运客车在高速公路车道内停车的;\n\n⑨  驾驶中型以上载客载货汽车、校车、危险物品运输车辆在高速公路、城市快速路上行驶超过规定时速20%以上或者在高速公路、城市快速路以外的道路上行驶超过规定时速50%以上，以及驾驶其他机动车行驶超过规定时速50%以上的;\n\n⑩  连续驾驶中型以上载客汽车、危险物品运输车辆超过4小时未停车休息或者停车休息时间少于20分钟的;\n\n\n⑪  未取得校车驾驶资格驾驶校车的。\n";
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc]initWithString:detailed.text];
    [title1 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 25)];
    detailed.numberOfLines = 0;
    detailed.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:detailed.text font:detailed.font];
    detailed.frame = CGRectMake(10, 10, rect.width-10, rect.height);
    detailed.attributedText = title1;
    [scrollView addSubview:detailed];
    
    UILabel *sixPoints = [[UILabel alloc] init];
    sixPoints.text = @"二、 机动车驾驶人有下列违法行为之一，一次记6分：\n\n①  机动车驾驶证被暂扣期间驾驶机动车的；\n\n②  驾驶机动车违反道路交通信号灯通行的；\n\n③  驾驶营运客车（不包括公共汽车）、校车载人超过核定人数未达20%的，或者驾驶其他载客汽车载人超过核定人数20%以上的；\n\n④  驾驶中型以上载客载货汽车、校车、危险物品运输车辆在高速公路、城市快速路上行驶超过规定时速未达20%的；\n\n⑤  驾驶中型以上载客载货汽车、校车、危险物品运输车辆在高速公路、城市快速路以外的道路上行驶或者驾驶其他机动车行驶超过规定时速20%以上未达到50%的；\n\n⑥  驾驶货车载物超过核定载质量30%以上或者违反规定载客的；\n\n⑦  驾驶营运客车以外的机动车在高速公路车道内停车的；\n\n⑧  驾驶机动车在高速公路或者城市快速路上违法占用应急车道行驶的；\n\n⑨  低能见度气象条件下，驾驶机动车在高速公路上不按规定行驶的；\n\n⑩  驾驶机动车运载超限的不可解体的物品，未按指定的时间、路线、速度行驶或者未悬挂明显标志的；\n\n⑪  驾驶机动车载运爆炸物品、易燃易爆化学物品以及剧毒、放射性等危险物品，未按指定的时间、路线、速度行驶或者未悬挂警示标志并采取必要的安全措施的；\n\n⑫  以隐瞒、欺骗手段补领机动车驾驶证的；\n\n⑬  连续驾驶中型以上载客汽车、危险物品运输车辆以外的机动车超过4小时未停车休息或者停车休息时间少于20分钟的；\n\n⑭  驾驶机动车不按照规定避让校车的。\n";
    NSMutableAttributedString * title2 = [[NSMutableAttributedString alloc]initWithString:sixPoints.text];
    [title2 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 25)];
    sixPoints.numberOfLines = 0;
    sixPoints.font = [UIFont systemFontOfSize:14.0];
    CGSize rect1 = [self sizeWithString:sixPoints.text font:sixPoints.font];
    sixPoints.frame = CGRectMake(10, 15+rect.height, rect1.width-10, rect1.height);
    sixPoints.attributedText = title2;
    [scrollView addSubview:sixPoints];
    
    UILabel *threePoints = [[UILabel alloc] init];
    threePoints.text = @"三、 机动车驾驶人有下列违法行为之一，一次记3分：\n\n①  驾驶营运客车（不包括公共汽车）、校车以外的载客汽车载人超过核定人数未达20%的；\n\n②  驾驶中型以上载客载货汽车、危险物品运输车辆在高速公路、城市快速路以外的道路上行驶或者驾驶其他机动车行驶超过规定时速未达20%的；\n\n③  驾驶货车载物超过核定载质量未达30%的；\n\n④  驾驶机动车在高速公路上行驶低于规定最低时速的；\n\n⑤  驾驶禁止驶入高速公路的机动车驶入高速公路的；\n\n⑥  驾驶机动车在高速公路或者城市快速路上不按规定车道行驶的；\n\n⑦  驾驶机动车行经人行横道，不按规定减速、停车、避让行人的；\n\n⑧  驾驶机动车违反禁令标志、禁止标线指示的；\n\n⑨  驾驶机动车不按规定超车、让行的，或者逆向行驶的；\n\n⑩  驾驶机动车违反规定牵引挂车的；\n\n⑪  在道路上车辆发生故障、事故停车后，不按规定使用灯光和设置警告标志的；\n\n⑫  上道路行驶的机动车未按规定定期进行安全技术检验的。\n\n";
    NSMutableAttributedString * title3 = [[NSMutableAttributedString alloc]initWithString:threePoints.text];
    [title3 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 25)];
    threePoints.numberOfLines = 0;
    threePoints.font = [UIFont systemFontOfSize:14.0];
    CGSize rect2 = [self sizeWithString:threePoints.text font:threePoints.font];
    threePoints.frame = CGRectMake(10, 15+rect.height+rect1.height, rect2.width-10, rect2.height);
    threePoints.attributedText = title3;
    [scrollView addSubview:threePoints];
    
    UILabel *twoPoints = [[UILabel alloc] init];
    twoPoints.text = @"四、机动车驾驶人有下列违法行为之一，一次记2分：\n\n①  驾驶机动车行经交叉路口不按规定行车或者停车的；\n\n②  驾驶机动车有拨打、接听手持电话等妨碍安全驾驶的行为的；\n\n③  驾驶二轮摩托车，不戴安全头盔的；\n\n④  驾驶机动车在高速公路或者城市快速路上行驶时，驾驶人未按规定系安全带的；\n\n⑤  驾驶机动车遇前方机动车停车排队或者缓慢行驶时，借道超车或者占用对面车道、穿插等候车辆的；\n\n⑥  不按照规定为校车配备安全设备，或者不按照规定对校车进行安全维护的；\n\n⑦  驾驶校车运载学生，不按照规定放置校车标牌、开启校车标志灯，或者不按照经审核确定的线路行驶的；\n\n⑧  校车上下学生，不按照规定在校车停靠站点停靠的；\n\n⑨  校车未运载学生上道路行驶，使用校车标牌、校车标志灯和停车指示标志的；\n\n⑩  驾驶校车上道路行驶前，未对校车车况是否符合安全技术要求进行检查，或者驾驶存在安全隐患的校车上道路行驶的；\n\n⑪  在校车载有学生时给车辆加油，或者在校车发动机引擎熄灭前离开驾驶座位的。\n";
    NSMutableAttributedString * title4 = [[NSMutableAttributedString alloc]initWithString:twoPoints.text];
    [title4 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 25)];
    twoPoints.numberOfLines = 0;
    twoPoints.font = [UIFont systemFontOfSize:14.0];
    CGSize rect3 = [self sizeWithString:twoPoints.text font:twoPoints.font];
    twoPoints.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height, rect3.width-10, rect3.height);
    twoPoints.attributedText = title4;
    [scrollView addSubview:twoPoints];
    
    UILabel *onePoint = [[UILabel alloc] init];
    onePoint.text = @"五、 机动车驾驶人有下列违法行为之一，一次记1分：\n\n①  驾驶机动车不按规定使用灯光的；\n\n②  驾驶机动车不按规定会车的；\n\n③  驾驶机动车载货长度、宽度、高度超过规定的；\n\n④  上道路行驶的机动车未放置检验合格标志、保险标志，未随车携带行驶证、机动车驾驶证的。\n\n";
    NSMutableAttributedString * title5 = [[NSMutableAttributedString alloc]initWithString:onePoint.text];
    [title5 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 25)];
    onePoint.numberOfLines = 0;
    onePoint.font = [UIFont systemFontOfSize:14.0];
    CGSize rect4 = [self sizeWithString:onePoint.text font:onePoint.font];
    onePoint.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height, rect4.width-10, rect4.height);
    onePoint.attributedText = title5;
    [scrollView addSubview:onePoint];
    scrollView.contentSize = CGSizeMake(DeviceMaxWidth,64+15+rect.height+rect1.height+rect2.height+rect3.height+rect4.height);
}

-(void)createGesturesView{
    [[lhColor shareColor]originalInit:self title:@"手势口诀" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *gestures = [[UILabel alloc] init];
    gestures.text = @"一、 八种交通警察手势信号：\n\n①  停止和靠边停车——手向上\n\n②  直行——双臂直\n\n③  左转——右手指向上\n\n④  右转——左手指向上\n\n⑤  变道——右手平动\n\n⑥  减速慢行——右手斜动\n\n⑦  左待转——左手斜动\n\n";
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc]initWithString:gestures.text];
    [title1 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 15)];
    gestures.numberOfLines = 0;
    gestures.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:gestures.text font:gestures.font];
    gestures.frame = CGRectMake(10, 10, DeviceMaxWidth-10, rect.height);
    gestures.attributedText = title1;
    [scrollView addSubview:gestures];
    
    UILabel *gesture1 = [[UILabel alloc] init];
    gesture1.text = @"二、 其它手势信号：\n\n①  左手过头勿前行---停车信号\n\n②  右手摆动靠边停---靠边停车\n\n③  两手平伸右手摆\n\n④  警察叔叔让直行---直行信号\n\n⑤  掌心向前你别动\n\n⑥  哪手摆动向哪行---左、右转弯信号\n\n⑦  左手侧摆须待转---左转弯待转信号\n\n⑧  右手横摆道变更---变道信号\n\n⑨  变道安全很重要\n\n⑩  右手下摆是慢行---慢行信号\n";
    NSMutableAttributedString * title2 = [[NSMutableAttributedString alloc]initWithString:gesture1.text];
    [title2 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 15)];
    gesture1.numberOfLines = 0;
    gesture1.font = [UIFont systemFontOfSize:14.0];
    CGSize rect1 = [self sizeWithString:gesture1.text font:gesture1.font];
    gesture1.frame = CGRectMake(10, rect.height, DeviceMaxWidth-10, rect1.height);
    gesture1.attributedText = title2;
    [scrollView addSubview:gesture1];
    scrollView.contentSize = CGSizeMake(DeviceMaxWidth,64+10+rect.height+rect1.height);
}

-(void)createDrunkendriving{
    [[lhColor shareColor]originalInit:self title:@"酒驾要点" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *drunken = [[UILabel alloc] init];
    drunken.text = @"    最新处罚条文：\n\n    酒后驾驶分两种：酒精含量达到20mg/100ml但不足80mg/100ml，属于饮酒驾驶；酒精含量达到或超过80mg/100ml，属于醉酒驾驶。目前，饮酒驾驶属于违法行为，醉酒驾驶属于犯罪行为。\n\n    醉酒驾驶机动车辆，吊销驾照，5年内不得重新获取驾照，经过判决后处以拘役，并处罚金；醉酒驾驶营运机动车辆，吊销驾照，10年内不得重新获取驾照，终生不得驾驶营运车辆，经过判决后处以拘役，并处罚金。\n\n    醉酒驾驶机动车辆，吊销驾照，5年内不得重新获取驾照，经过判决后处以拘役，并处罚金；醉酒驾驶运营机动车辆，吊销驾照，10年内不得重新获取驾照，终生不得驾驶运营车辆，经过判决后处以拘役，并处罚金。\n";
    drunken.numberOfLines = 0;
    drunken.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:drunken.text font:drunken.font];
    drunken.frame = CGRectMake(10, 10, DeviceMaxWidth-20, rect.height);
    [scrollView addSubview:drunken];
    scrollView.contentSize = CGSizeMake(DeviceMaxWidth,64+rect.height);
}

-(void)createConfuseview{
    [[lhColor shareColor]originalInit:self title:@"易混淆知识点" imageName:nil backButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *confuse = [[UILabel alloc] init];
    confuse.text = @"一、 实习驾驶员： \n\n①   可以：实习驾驶员不得单独驾车上高速，须有3年驾龄的驾驶员陪同才能上高速。\n\n②   不准：牵引车辆；驾驶特种和危险品车辆；单独驾驶大客车和挂车。\n";
    UIFont * font = [UIFont boldSystemFontOfSize:15];
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc]initWithString:confuse.text];
    [title addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 15)];
    confuse.numberOfLines = 0;
    confuse.font = [UIFont systemFontOfSize:14.0];
    CGSize rect = [self sizeWithString:confuse.text font:confuse.font];
    confuse.frame = CGRectMake(10, 10, DeviceMaxWidth-10, rect.height);
    confuse.attributedText = title;
    [scrollView addSubview:confuse];
    
    UILabel *confuse1 = [[UILabel alloc] init];
    confuse1.text = @"二、 鸣喇叭：\n\n①   可以：鸣三次，鸣半秒钟。行车中遇到畜力车时，尽量少鸣喇叭。\n\n②   不准：郊外高音喇叭禁止，晚上23时到凌晨5时禁止。当经过不允许鸣喇叭的路段时，注意安全，禁止鸣喇叭。行进没有禁止鸣喇叭路段时，驾驶人应该尽可能少鸣喇叭。\n\n";
    NSMutableAttributedString * title1 = [[NSMutableAttributedString alloc]initWithString:confuse1.text];
    [title1 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse1.numberOfLines = 0;
    confuse1.font = [UIFont systemFontOfSize:14.0];
    CGSize rect1 = [self sizeWithString:confuse1.text font:confuse1.font];
    confuse1.frame = CGRectMake(10, 15+rect.height, rect1.width-10, rect1.height);
    confuse1.attributedText = title1;
    [scrollView addSubview:confuse1];
    
    UILabel *confuse2 = [[UILabel alloc] init];
    confuse2.text = @"三、 灯光：\n\n①   左转向灯：向左转弯、向左变道、起步、驶离停车地点、调头时。\n\n②   右转向灯：向右转弯、向右变道、靠边停车时。\n\n③   夜间行车路灯照明良好开近光灯。\n\n④   夜间无路灯照明时间时开远光灯。\n\n⑤   雾天行驶时开雾灯和报警闪光灯。\n\n⑥   进入环形路口不要开转向灯光，出环形路口时开右转向灯。\n\n⑦   夜间需要超车时应变换远近光灯。\n\n⑧   夜间临时停车时开示廓灯，后尾灯。\n";
    NSMutableAttributedString * title2 = [[NSMutableAttributedString alloc]initWithString:confuse2.text];
    [title2 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse2.numberOfLines = 0;
    confuse2.font = [UIFont systemFontOfSize:14.0];
    CGSize rect2 = [self sizeWithString:confuse2.text font:confuse2.font];
    confuse2.frame = CGRectMake(10, 15+rect.height+rect1.height, rect2.width-10, rect2.height);
    confuse2.attributedText = title2;
    [scrollView addSubview:confuse2];
    
    UILabel *confuse3 = [[UILabel alloc] init];
    confuse3.text = @"四、 让车：\n\n①   机动车于非机动车在窄桥上会车减速靠右通过。\n\n②   右转弯让左转弯的车先。\n\n③   下坡车让上坡车。\n\n④   非公交车让公交车先\n\n⑤   环型路口进口让出口。\n\n⑥   有障碍让无障碍。\n\n⑦   有让路条件让无路条件。\n\n";
    NSMutableAttributedString * title3 = [[NSMutableAttributedString alloc]initWithString:confuse3.text];
    [title3 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse3.numberOfLines = 0;
    confuse3.font = [UIFont systemFontOfSize:14.0];
    CGSize rect3 = [self sizeWithString:confuse3.text font:confuse3.font];
    confuse3.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height, rect3.width-10, rect3.height);
    confuse3.attributedText = title3;
    [scrollView addSubview:confuse3];
    
    UILabel *confuse4 = [[UILabel alloc] init];
    confuse4.text = @"五、 未划分标线车道：\n\n①   机动车在中间行驶。\n\n②   路幅宽度14米以上非机动车两边3.5米。\n\n③   14—10米机动车中间7米。\n\n④   10—6米非机动车两边1.5米。\n\n⑤   小于6米的机动车和非机动车靠右顺序行驶。\n\n";
    NSMutableAttributedString * title4 = [[NSMutableAttributedString alloc]initWithString:confuse4.text];
    [title4 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse4.numberOfLines = 0;
    confuse4.font = [UIFont systemFontOfSize:14.0];
    CGSize rect4 = [self sizeWithString:confuse4.text font:confuse4.font];
    confuse4.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height, rect4.width-10, rect4.height);
    confuse4.attributedText = title4;
    [scrollView addSubview:confuse4];
    
    UILabel *confuse5 = [[UILabel alloc] init];
    confuse5.text = @"六、 支干路区分：\n\n①   干路：国道，多车道，划车道分界线，通公交车道。\n\n";
    NSMutableAttributedString * title5 = [[NSMutableAttributedString alloc]initWithString:confuse5.text];
    [title5 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse5.numberOfLines = 0;
    confuse5.font = [UIFont systemFontOfSize:14.0];
    CGSize rect5 = [self sizeWithString:confuse5.text font:confuse5.font];
    confuse5.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height+rect4.height, rect5.width-10, rect5.height);
    confuse5.attributedText = title5;
    [scrollView addSubview:confuse5];
    
    UILabel *confuse6 = [[UILabel alloc] init];
    confuse6.text = @"七、 车道：\n\n①   三条车道：第一条为超车道，专供超车用。第二条为小型车道，专供小型客车。第三条为大型车道：专供其他车辆通行。\n\n②   高架：第一条为快车道，车速为70—80。第二条为慢车道，车速为50—80，低于70公里改在慢速车道上行驶。\n\n③   高速公路：第一条为超车道，第二条为行车道，第三条为紧急停车带。机动车在高速公路上行驶，最低时速为60公里。设计最低为70公里。高速公路上二车之间安全车距离为100米。\n\n④   高架和高速：不准停车、调头、逆向行驶、上下客。\n";
    NSMutableAttributedString * title6 = [[NSMutableAttributedString alloc]initWithString:confuse6.text];
    [title6 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse6.numberOfLines = 0;
    confuse6.font = [UIFont systemFontOfSize:14.0];
    CGSize rect6 = [self sizeWithString:confuse6.text font:confuse6.font];
    confuse6.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height+rect4.height+rect5.height, rect6.width-10, rect6.height);
    confuse6.attributedText = title6;
    [scrollView addSubview:confuse6];
    
    UILabel *confuse7 = [[UILabel alloc] init];
    confuse7.text = @"八、 交通标线：\n\n①   中心虚线：可以跨线超车或转弯。\n\n②   中心单实线：（黄色）不准压线行驶。\n\n③   中心虚实线：（黄色）禁止实线侧越线超车或向左转弯。\n\n④   中心双实线：（黄色）严格禁止车辆跨线超车或压线行驶。\n\n⑤   停车线：与中心线相垂直的条白色实线。\n\n⑥   东道分界线：（白色）分隔同向行驶的车辆。\n\n⑦   中心圈：区分车辆大小转弯，从中心圈左侧左转弯，不可压线。\n";
    NSMutableAttributedString * title7 = [[NSMutableAttributedString alloc]initWithString:confuse7.text];
    [title7 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse7.numberOfLines = 0;
    confuse7.font = [UIFont systemFontOfSize:14.0];
    CGSize rect7 = [self sizeWithString:confuse7.text font:confuse7.font];
    confuse7.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height+rect4.height+rect5.height+rect6.height, rect7.width-10, rect7.height);
    confuse7.attributedText = title7;
    [scrollView addSubview:confuse7];
    
    UILabel *confuse8 = [[UILabel alloc] init];
    confuse8.text = @"九、 驾驶人规定：\n\n①   实习驾驶人：正式驾驶证的第一年。\n\n②   机动车驾驶证有效期为：6年10年或长期。\n\n③   调换驾驶证的时间为90天。\n\n④   超过一年没有换证的注销机动车驾驶证。\n\n⑤   驾驶证遗失，补发驾驶证的时间为1天。\n\n⑥   申请中型客车，大型货车，城市公交车等，身高为155厘米，眼睛视力5.0以上，年龄在21—50周岁。\n\n⑦   学小型汽车，轻便摩托车年龄为18—70岁，学二轮摩托车年龄为18—60岁。\n\n";
    NSMutableAttributedString * title8 = [[NSMutableAttributedString alloc]initWithString:confuse8.text];
    [title8 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 10)];
    confuse8.numberOfLines = 0;
    confuse8.font = [UIFont systemFontOfSize:14.0];
    CGSize rect8 = [self sizeWithString:confuse8.text font:confuse8.font];
    confuse8.frame = CGRectMake(10, 15+rect.height+rect1.height+rect2.height+rect3.height+rect4.height+rect5.height+rect6.height+rect7.height, rect8.width-10, rect8.height);
    confuse8.attributedText = title8;
    [scrollView addSubview:confuse8];
    
    scrollView.contentSize = CGSizeMake(DeviceMaxWidth,64+rect.height+rect1.height+rect2.height+rect3.height+rect4.height+rect5.height+rect6.height+rect7.height+rect8.height);
}

//①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
