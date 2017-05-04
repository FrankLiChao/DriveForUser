//
//  lhWeb.h
//  KTVProject
//
//  Created by 刘欢 on 14-5-27.
//  Copyright (c) 2014年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lhWeb : NSObject
{
    NSMutableData * appData;//请求的数据
}

@property (nonatomic,strong)NSMutableDictionary * mutableDic;

- (void)HTTPPOSTNormalRequestForURL:(NSString *)urlString parameters:(NSDictionary *)parameters method:(NSString *)method name:(NSString *)name type:(requestStyle)rs;

- (void)uploadPhoto:(NSString *)method params:(NSDictionary *)_params serviceName:(NSString *)name NotiName:(NSString *)nName imageD:(NSData *)imageData;//上传头像

+ (NSDictionary *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                     picFilePath: (NSMutableArray *)picFilePath
                     picFileName: (NSMutableArray *)picFileName;
@end
