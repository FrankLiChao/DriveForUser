//
//  lhColor.h
//  WSTechApp
//
//  Created by 刘欢 on 14-3-28.
//  Copyright (c) 2014年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MMLocationManager.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

//#import <RongIMKit/RongIMKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void (^SuccessBlock)(NSString *userId);
//typedef void (^ErrorBlock)(RCConnectErrorCode status);
typedef void (^TokenErrorBlock)();

typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationCityBlock)(NSString * city);
typedef void(^CompletionBlock)(NSDictionary *resultDic);

//地图大头针类型
typedef NS_ENUM(NSInteger, annotationStyle){
    CAR_ANNOTATION = 1,
    MINE_ANNOTATIN,
    SCHOOL_ANNOTATION
};

//支付类型
typedef NS_ENUM(NSInteger, payStyle){
    BUY_GOODS = 1,
    CHONGZHIYUE
};

//请求类型
typedef NS_ENUM(NSInteger, requestStyle){
    OUR_REQUEST = 1,
    GAODE_REQUEST,
    DUANXIN_REQUEST
};

//用户角色
typedef NS_ENUM(NSInteger, userStyle){
    USER_NORMAL = 1,
    USER_DRIVER,
};

//理论模拟中页面跳转类型
typedef NS_ENUM(NSInteger, jumpType){
    ORDER_PRACTICE = 1,     //顺序练习
    RANDOM_PRACTICE,        //随机练习
    SPECIFIC_PRACTICE,      //专项练习
    PROBLEM_SOLVE,          //难题攻克
    FALLIBLE_ANSWERS,       //易错题集
    SIMULATION_TEST,        //模拟考试
    TEST_HISTORY,           //考试记录
    GRADE_RANKING,          //成绩排名
    TEST_POINT,             //考试要点
    ANSWER_SKILLS,          //答题技巧
    WRONG_QUESTION,         //我的错题
    COLLECT_QUESTION,       //我的收藏
};

@interface lhColor : NSObject<UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    BOOL isLocationing;
}

@property (nonatomic,strong)MPMoviePlayerViewController *movie;

@property (nonatomic,strong)CLLocationManager   * locationManaer;
@property (nonatomic,strong)NSDictionary        * apnsDic;//接受到的推送消息
@property (nonatomic,strong)NSString            * deviceID;
@property (nonatomic,assign)BOOL                isOnLine;//已登录，在线
@property (nonatomic,strong)NSMutableDictionary * userInfo;//用户信息
@property (nonatomic,strong)NSString * userName;//用户信息
@property (nonatomic,strong)NSString * idCard;//用户信息
@property (nonatomic,strong)NSString * phone;//用户信息
@property (nonatomic,assign)BOOL isBind;//用户是否绑定
@property (nonatomic,strong)NSMutableDictionary * headPic;//图片前缀
@property (nonatomic,strong)NSDictionary * versionInfo;//版本信息
@property (nonatomic,assign)BOOL isEnableCheck;//可检测更新
@property (nonatomic,strong)NSDictionary *versionDic;  //服务器版本号
@property (nonatomic,strong)NSString * realToken;//当前token
@property (nonatomic,strong)UINavigationController * tempNVC;//当前rootNVC

//@property (nonatomic,strong)NSString * GDSignStr;               //高德签名串
@property (nonatomic,strong)NSString * nowCityStr;              //当前城市
@property (nonatomic,assign)CLLocationCoordinate2D nowLocation; //当前位置
@property (nonatomic,strong)NSString *mapId;                    //高德的mapID
@property (nonatomic,strong)NSString *fileWebUrl;               //返回的文件服务器域名
@property (nonatomic,assign)NSInteger type;                     //跳转到我的消息页面
@property (nonatomic,strong)UIWindow *delegateWindow;

@property (nonatomic,assign)BOOL noShowKaiChang;                //不显示开场图片
@property (nonatomic,assign)NSInteger uploadPicNumber;          //上传图片的总数
//点击推送跳转到相应页面
@property (nonatomic,assign)BOOL pushToNoticeView;
@property (nonatomic,strong)UIViewController * NowViewC;        //当前的

//支付存储数据
@property (nonatomic,assign)payStyle payS;
@property (nonatomic,strong)UIViewController * tempViewC;
@property (nonatomic,strong)NSDictionary * tempOrderDi;


+ (instancetype)shareColor;//单例

+ (NSDictionary *)headPicDic;//获取图片前缀信息

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;//获取颜色

//正在连接
+ (void)addActivityView:(UIView *)view;
+ (void)addActivityView123:(UIView *)view;
+ (void)disAppearActivitiView:(UIView *)view;

//正在加载数据
+ (void)addActivityView1OnlyActivityView:(UIView *)view;
+ (void)disAppearActivitiViewOnlyActivityView:(UIView *)view;


- (void)originalInit:(UIViewController *)temp title:(NSString *)str imageName:(NSString *)imageStr backButton:(BOOL)isBack;//初始化导航栏及组件
- (void)originalInitView:(UIView *)temp title:(NSString *)str imageName:(NSString *)imageStr backButton:(BOOL)isBack;

+ (void)mergeTitle:(NSString *)titleStr;
+ (void)assignmentForTempVC:(UIViewController *)temp;

//根据经验获取等级值
+ (NSInteger)levelWithExperience:(CGFloat)exp;

//根据一个之前时间，判断距离现在的时间
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

//裁剪一张图片
- (UIImage *)croppedImageToRect:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height;
- (UIImage *)croppedImage:(UIImage *)image;

//比黑色浅一点的颜色
+ (UIColor *)lessBlackColor;

//定位当前位置
- (void)locationAddress:(LocationBlock)locaiontBlock;
- (void)locationCity:(LocationCityBlock)locationCity;

#pragma mark - 签名算法
+ (NSString *)signStrGaoDe:(NSDictionary *)dic;

+ (NSString *)signStrOur:(NSDictionary *)dic;

#pragma mark - 点赞或评论之后发推送
- (void)zanSendPushWithUserCode:(NSString *)userCode withAlert:(NSString *)alert;

#pragma mark - 存储照片
//获取图片名字
- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name;
- (UIImage *)readImageWithNameOther:(NSString *)name;
- (NSString *)imageStr:(NSString *)iStr;
- (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSURL *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;
+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView;
+ (void)checkImageWithName:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView withPlaceHolder:(UIImage *)placeImage;
+ (void)checkImageWithNameCut:(NSString *)name withUrlStr:(NSString *)urlStr withImgView:(UIImageView *)tempImgView withPlaceHolder:(UIImage *)placeImage withSize:(CGSize)size;
+ (void)checkImageWithImageView:(UIImageView *)tempImg withImage:(NSString *)tempImgName withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;

- (void)removeAllImage;
- (BOOL)isImageWithName:(NSString *)name;
- (void)saveImages:(UIImage *)tempImg withName:(NSString *)name;
- (UIImage *)readImageWithName:(NSString *)name;
- (void)removeImageFile:(NSString *)name;

- (void)saveLunBoImg:(UIImage *)img withI:(int)i;
- (UIImage *)readImageWithNameLunBo:(NSString *)name;
- (void)removeLunBo;

#pragma mark-将数字转成字符串
- (NSString *)stringWithFloat:(CGFloat)floatNumber;

+ (NSArray *)arrayWithConStrI:(NSString *)conStr;
//将内容字符串转成数组
+ (NSArray *)arrayWithConStr:(NSString *)conStr;

//将图片字符串转成数组message
+ (NSArray *)arrayWithPicStr:(NSString *)picStr;

//food
+ (NSArray *)arrayWithPicStrFood:(NSString *)picStr;

//拆分规格字符串
+ (NSArray *)arrayWithGuiGeStr:(NSString *)guigeStr;

/**
 *滚动显示
 */
+ (void)moveTowardleft:(UIView *)view offet:(CGFloat)offet;


+ (NSInteger)nowDay;

+ (void)wangluoAlertShow;
+ (void)requestFailAlertShow:(NSNotification *)noti;

/**
 *商品搜索框
 */
//- (void)addSouSuoField:(UIView *)superView withRect:(CGRect)rect withPlaceHolder:(NSString *)placeHolder withW:(NSInteger)hh;
//- (void)cancekSouSuo;

/**
 *商品打折显示原价
 */
+ (void)showOldPriceLabel:(UIView *)nowLabel nowPrice:(CGFloat)nowPrice oldPrice:(CGFloat)oldPrice;


/**
 *sizeWithFont替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font;

/**
 *sizeWithFont: constrainedToSize: lineBreakMode: 替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *drawAtPoint:
 forWidth:
 withFont:
 fontSize:
 lineBreakMode:
 baselineAdjustment:替换
 */
+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;

/**
 *drawInRect:(CGRect)rect withFont:替换
 */
+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font;


/**
 *支付宝支付
 */
- (void)payInAliyPayWithDic:(NSDictionary *)payDic
               withOrderDic:(NSDictionary *)di
                   callback:(CompletionBlock)completionBlock;
/**
 *微信支付
 */
#pragma mark - 微信支付
- (void)wxPayWithPayDic:(NSDictionary *)payDic OrderDic:(NSDictionary *)orderDic;

/**
 *分享
 */
+ (void)fxViewAppear:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr;

/**
 *分享提示显示
 */
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih;

/**
 *放大或缩小图片到自己想要的尺寸
 *
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


/**
 *数字处理，10000以下显示为原数字，超过10000则显示为多少万
 */
+ (NSString *)numberStringWithNumber:(NSString *)number;

/**
 *是否登录检测
 */
+ (BOOL)loginIsOrNo;

/**
 *截取屏幕
 */
//获得屏幕图像
- (UIImage *)imageFromView:(UIView *)theView;

/**
 *添加购物车和首页图标
 */
//+ (void)addShopCarIconAndMainIconToView:(UIViewController *)VC;
////购物车中商品数量
//+ (NSString *)shopCarNumStr;

/**
 *没有数据时提醒
 */
+ (void)removeNullLabelWithSuperView:(UIView *)superView;
+ (void)addANullLabelWithSuperView:(UIView *)superView withFrame:(CGRect)rect withText:(NSString *)str;

/**
 *手机号验证
 */
- (BOOL)isValidateMobile:(NSString *)mobile;
#pragma 正则匹配用户身份证号15或18位
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *刷新用户信息
 */
- (void)refreshPersonInfo;

/**
 *拨打电话
 */
- (void)detailPhone:(NSString *)phone;

/**
 *请求签名生成
 */
+ (NSString *)signStr:(NSDictionary *)dic;

/**
 *字典转json
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *向高德云图更新数据
 */
- (void)updateLocation:(CLLocationCoordinate2D)coord;

/**
 *获取位置
 */
- (void)updateLocation;

/**
 *发送给微信好友
 */
+ (void)sendMessageToWeiXinSession;

/**
 *根据定位城市，获取显示城市
 */
- (NSString *)city:(NSString *)cityStr;

+ (CLLocationCoordinate2D)coordWithLocationStr:(NSString *)locationS;



- (UIView *)playVedio:(NSString *)name;


@end
