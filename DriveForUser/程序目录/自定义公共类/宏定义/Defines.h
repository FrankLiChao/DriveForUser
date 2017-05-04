//
//  Defines.h
//  AdsProduct
//
//  Created by 刘欢 on 15-2-10.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#ifndef AdsProduct_Defines_h
#define AdsProduct_Defines_h

//URL连接定义

//#define webUrlForFile @"http://www.up-oil.com:83/" //文件
//#define webUrl @"http://www.up-oil.com:84/"

//#define webUrl @"http://192.168.199.220:8000/"
//#define webUrl @"http://api.up-driving.com:8200/"
//#define webUrlForFile @"http://192.168.199.220:8089/"
//#define webUrlForFile @"http://up-driving.com:82/"

//#define GDWebUrl @"http://yuntuapi.amap.com/"
#define GDMapDriverTableId @"564bf631e4b0747d8d7740eb"
#define GDMapSchoolTableId @"55a3483ae4b0a8cc8c576a68"
#define GDMapKey @"070b165d71a951f5a28d538f70291dbc"
//高德的签名
#define GDSignStr @"a596f2582270cede2d34eaded0004375"
//后台的固定签名
#define OurRequestSignStr @"0581d9c5e04218f5bc5eed0bcde1cc89cc8d1798"

#define ourServicePhone @"400-005-8905"

#define showCountM 15
#define placeHolderImg @"defaultHead"
#define schoolDefaultImage @"lunboPic4.jpg"
#define DefaultCoordnate CLLocationCoordinate2DMake(30.6573361400,104.0657531337) //地图默认定位点

#define partnerIDbo @"2088021290256670"
#define seller_emailbo @"bosheng@bs-innotech.com"
#define private_keybo @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALysbtfuSrPQ5ZAvs9R6Psw0trcD15VR+1LsSxZK8LwnKroYLHN4K2JXJeZ1lCiV1thaJ7Lh98o7EZye1Lf0fAlShqwEpXKQ+jMp8CZB8RsYSiI1CIy0C4qV7n4RL9QztVmkZiAwCZ3HVv4eD/YUzUopTNjlveiweJTZcf9S8Or7AgMBAAECgYAMlKrndxpAF0PXc3bYSjZ5w2ITngv4BvltNBhlqiWXRj1RH1+Ha5HpAsqiLWDtu+ARmSFgijTNpVatTOH+Si0jDH6juyPshk31kVA/l+DcTP8fCq4rc/6G86DYvLXJTdT83GlCl/1z4TYFB5G1R9vZmUf0OWfI+lVnTsuU2oA6MQJBAPab/zqv0+VfB5QDgEIhh/kmu6S8WMWRwwxSTALBbLOcf0fLzdnd0r3GIZvAQEKSN+tJjKfud1NiN/AUTl08jDUCQQDD26o5ZrODCiFvY4PlxjDypoDR1nJemfGW+n1q9X3mmN73XgqPV/iTHtkiqeAkaZ3VaboPadcrvVcosuORs6BvAkEAyj6nM4cNXVfxDBdO8W00aUW1r+VzXBwtfQZlJgFhV2/qBoSC/sDn2xEJcQVa7f2idIjuHK76F10+iNruZZKJXQJACc1kp5rMQTKwmbKRV16j9IEA0X+6GaH6xWOkA0ZmFrRv9FFwldwBRNu2YlW+MhRXIec4uKzDaB0Bz7ekTBaBYQJAMuAIMoTWL4dgdSV8KtHFkNMM//juQLxqNohxsiOweRZPALyFeVyt0J7sWLLNmu/oeL6nFERYlOmlB7OyYn5sew=="


//IOS判断
#define IOS6 ([[UIDevice currentDevice].systemVersion intValue] > 5 ? YES : NO)

#define IOS7 ([[UIDevice currentDevice].systemVersion intValue] >= 7 ? YES : NO)

#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

//设备判断
#define iPhone4 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone5 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//字体
//ArialMT
//MicrosoftYaHei
#define fontName @"ArialMT"

#define fontSizeTitle 18
#define fontSizeMiddle 15
#define fontSizeMiddleMin 13
#define fontSizeMin 11

#define titleColorStr @"ffffff"
#define contentTitleColorStr @"666666"
#define contentTitleColorStr1 @"999999"
#define glineColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define lineColorStr @"e77e23"
#define blackForShow @"221714"
//@"e77e23"
//#define mainColorStr @"3598dc"
#define mainColorStr @"1da1f2"
#define blueColorStr @"5D9CD4"
#define viewColorStr @"EBEBEB"
#define buttonColorStr @"aaaaaa"
#define otherColorStr @"f47265"
#define maxPageCount 15

#define tableDefSepLineColor [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1] //表格线条颜色

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320

//初始化图片
#define imageWithName(name) [UIImage imageNamed:name]

//存储文件宏定义
#define runCount @"runCountFile"
#define saveLocalTokenFile @"saveLocalTokenFile"//token
#define saveHeadPicfile @"saveHeadPicfile"
#define saveMainNewsArrayFile @"saveMainNewsArrayFile"
#define mainViewlunboPicFile @"mainViewlunboPicFile"
#define saveLoginInfoFile @"saveLoginInfoFile"
#define autoLoginTimeFile @"autoLoginTimeFile"
#define writeMessagePicCount @"writeMessagePicCountFile"
#define uploadPictureCount @"uploadPictureCount" //驾考圈发布图片个数
#define saveLocalTokenFile @"saveLocalTokenFile"//接收消息
#define saveAllMessageFile @"saveAllMessageFile"//存储已收到消息的条数，用于实现新的消息标示
#define saveLocalCityName @"saveLocalCityName"
#define saveStudyProgress @"saveStudyProgress"

#define TheOneDeviceToken @"apple_NO"/*<未打开通知的token*/

#define WeiXinAppID @"wx82324aa647703a57"
#define MCH_ID @"1264324401"
#define API_KEY @"nf893ufnjksnf983urfnwekfj340894u"

#endif
