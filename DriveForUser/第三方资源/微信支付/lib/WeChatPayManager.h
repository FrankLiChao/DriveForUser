//
//  WeChatPayManager.h
//  SDKSample
//
//  Created by 刘欢 on 15/6/23.
//
//

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
//#import "WXApi.h
#import "WeChatPayManager.h"

//// 账号帐户资料
//// 更改商户把相关参数后可测试
//#define APP_ID          @"wxfa35210bb48caf88"        //APPID
//#define APP_SECRET      @"5ae209795c24c06d7438014607066617"                          //appsecret,看起来好像没用
////商户号，填写商户对应参数
//#define MCH_ID          @"1247173101"
////商户API密钥，填写相应参数
//#define PARTNER_ID      @"luzhouxuanfengwoniuruanjiankaifa"
////支付结果回调页面
//#define NOTIFY_URL      @"http://114.215.184.109:12080/ads/alipay/recharge_notify_url.jsp"
//#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

@interface WeChatPayManager : NSObject

//预支付网关url地址
@property (nonatomic,strong) NSString* payUrl;

//debug信息
@property (nonatomic,strong) NSMutableString *debugInfo;
@property (nonatomic,assign) NSInteger lastErrCode;//返回的错误码

//商户关键信息
@property (nonatomic,strong) NSString *appId,*mchId,*spKey;


//初始化函数
-(id)initWithAppID:(NSString*)appID
mchID:(NSString*)mchID
spKey:(NSString*)key;

//获取当前的debug信息
-(NSString *) getDebugInfo;

//获取预支付订单信息（核心是一个prepayID）
//- (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name
//price:(NSString*)price
//device:(NSString*)device;
- (NSMutableDictionary*)getPrepayWithPayDic:(NSDictionary *)payDic
                               withOrderDic:(NSDictionary *)orderDic;

@end
