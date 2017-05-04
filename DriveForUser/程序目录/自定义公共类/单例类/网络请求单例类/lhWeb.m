//
//  lhWeb.m
//  KTVProject
//
//  Created by 刘欢 on 14-5-27.
//  Copyright (c) 2014年 liuhuan. All rights reserved.
//

#import "lhWeb.h"
#import "lhMyConnection.h"
//#import "XMLParser.h"
//#import "TreeNode.h"

#define TIME_OUT_INTERVAL 30

@implementation lhWeb
{
    NSString * nowName;
    
    NSMutableDictionary * MData;
    NSMutableDictionary * DData;
}

+ (NSDictionary *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                     picFilePath: (NSMutableArray *)picFilePath
                     picFileName: (NSMutableArray *)picFileName
{
    
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    //遍历数组，添加多张图片
    for (int i = 0; i < picFilePath.count; i ++) {
        NSData* data;
//        UIImage *image=[UIImage imageWithContentsOfFile:[picFilePath objectAtIndex:i]];
        UIImage *image = [picFilePath objectAtIndex:i];
        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 0.5);
//        }
        data = UIImageJPEGRepresentation(image, 0.5);
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",i+1],[NSString stringWithFormat:@"image%d.png",i+1]];
        
        [fileTitle appendString:end];
        
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
        [fileTitle appendString:end];
        
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [myRequestData1 appendData:data];
        
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //添加其他参数
    for(int i=0;i<[keys count];i++)
    {
        
        NSMutableString *body=[[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        
        [body appendString:end];
        
        [body appendString:end];
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        
        [body appendString:end];
        
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    NSLog(@"%@",[lhColor shareColor].fileWebUrl);
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[lhColor shareColor].fileWebUrl,url]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponese = nil;
//    NSError *error = [[NSError alloc] init];
    NSError *error = nil;
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200 && [urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        /*
        if (jsonobj == nil || (id)jsonobj == [NSNull null] || [[jsonobj objectForKey:@"flag"] intValue] == 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [Singleton sharedSingleton].shopId = [[jsonobj objectForKey:@"shopId"]stringValue];
                [alert show];
            });
        }
         */
        return resultDic;
    }
    else if (error) {
        NSLog(@"%@",error);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传图片失败，请检查你的网络." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
        
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传图片失败，请检查你的网络." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
}

#pragma mark - 请求
- (void)HTTPPOSTNormalRequestForURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(NSString *)method name:(NSString *)name type:(requestStyle)rs
{
    [lhColor shareColor].noShowKaiChang = YES;
    if (!self.mutableDic) {
        self.mutableDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        MData = [NSMutableDictionary dictionaryWithCapacity:10];
        DData = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    nowName = @"1";
    //拼接URL
    if ([name isEqualToString:@"sendMessage"]) {
        urlString = urlString;
    }
    else{
        urlString = [rs==GAODE_REQUEST?GDWebUrl:webUrl stringByAppendingFormat:@"%@",urlString];
    }
    parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    NSLog(@"请求链接  ---- %@",urlString);
    if (rs == GAODE_REQUEST) {
        if ([@"GET" isEqualToString:method]) {
//            NSLog(@"该请求是GET请求");
        }
        else{
//            [parameters setObject:[lhColor signStrGaoDe:parameters] forKey:@"sign"];
        }
        
    }
    else if(rs == OUR_REQUEST){
        if ([@"GET" isEqualToString:method]) {
//            NSLog(@"该请求是GET请求");
        }
        else{
            [parameters setObject:OurRequestSignStr forKey:@"appKey"];
            [parameters setObject:[lhColor signStrOur:parameters] forKey:@"sign"];
            [parameters removeObjectForKey:@"appKey"];
        }
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT_INTERVAL];

    NSString *HTTPBodyString = [self HTTPBodyWithParameters:parameters];
    [URLRequest setHTTPBody:[HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [URLRequest setHTTPMethod:method];
    
    lhMyConnection * myConnection = [[lhMyConnection alloc]initWithRequest:URLRequest delegate:self];
    myConnection.name = name;
    [myConnection start];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}

- (void)uploadPhoto:(NSString *)method params:(NSDictionary *)_params serviceName:(NSString *)name NotiName:(NSString *)nName imageD:(NSData *)imageData
{
    [lhColor shareColor].noShowKaiChang = YES;
    
    nowName = nName;
    NSString * url = [NSString stringWithFormat:@"%@%@",[lhColor shareColor].fileWebUrl,method];
    NSLog(@"上传头像 %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    //    UIImage * imageToPost = imageWithName(@"beauty.jpg");
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSMutableData *body = [NSMutableData data];
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // add image data
    
    //    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData){
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    
    [request setHTTPBody:body];
    
    // set the content-length
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
//    lhMyConnection * myConnection = [[lhMyConnection alloc]initWithRequest:request delegate:self];
//    myConnection.name = nName;
//    [myConnection start];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//生成请求body
- (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString * tempStr = [[NSString stringWithFormat:@"%@=%@",key,value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
            
            [parametersArray addObject:tempStr];
        }
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

#pragma mark - NSUrlConnectionDelegate
//开始响应
- (void)connection:(lhMyConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([nowName isEqualToString:@"uploadPhoto"]) {
        if (appData) {
            appData  = nil;
        }
        appData = [NSMutableData data];
    }
    else{
        [self.mutableDic setObject:[NSMutableData data] forKey:connection.name];
    }

}

//得到数据
- (void)connection:(lhMyConnection *)connection didReceiveData:(NSData *)data
{
    if ([nowName isEqualToString:@"uploadPhoto"]) {
        [appData appendData:data];
    }
    else{
        [[self.mutableDic objectForKey:connection.name]appendData:data];
    }
}

//完成请求
- (void)connectionDidFinishLoading:(lhMyConnection *)connection
{
 
    [lhColor shareColor].noShowKaiChang = NO;
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    if ([nowName isEqualToString:@"uploadPhoto"]) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:appData options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:nowName object:nil userInfo:dataDic];
    }
    else if ([connection.name isEqualToString:@"sendMessage"]) {
        
//        XMLParser * parser = [[XMLParser alloc]init];
//        TreeNode * node = [parser parseXMLData:appData];
//        [node dump];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:nowName object:nil userInfo:@{@"result":@"1"}];
    }
    else{
//        NSMutableData * data = [NSMutableData dataWithData:[self.mutableDic objectForKey:connection.name]];
        if ([NSMutableData dataWithData:[self.mutableDic objectForKey:connection.name]]) {
            [DData setObject:[NSMutableData dataWithData:[self.mutableDic objectForKey:connection.name]] forKey:connection.name];
        }
//        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:[DData objectForKey:connection.name] options:NSJSONReadingMutableLeaves error:nil];
        if ([NSJSONSerialization JSONObjectWithData:[DData objectForKey:connection.name] options:NSJSONReadingMutableLeaves error:nil]) {
            [MData setObject:[NSJSONSerialization JSONObjectWithData:[DData objectForKey:connection.name] options:NSJSONReadingMutableLeaves error:nil] forKey:connection.name];
        }
        
        [self.mutableDic removeObjectForKey:connection.name];
        [[NSNotificationCenter defaultCenter]postNotificationName:connection.name object:nil userInfo:[MData objectForKey:connection.name]];
        [DData removeObjectForKey:connection.name];
        [MData removeObjectForKey:connection.name];
    }
}

//请求失败
- (void)connection:(lhMyConnection *)connection didFailWithError:(NSError *)error
{
    [lhColor shareColor].noShowKaiChang = NO;
    //NSLog(@"请求失败 ");
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    if (![nowName isEqualToString:@"uploadPhoto"]) {
        [self.mutableDic removeObjectForKey:connection.name];
        [[NSNotificationCenter defaultCenter]postNotificationName:connection.name object:nil userInfo:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:nowName object:nil userInfo:nil];
    }
}

@end
