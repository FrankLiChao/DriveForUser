//
//  MHAsiNetworkUrl.h
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#ifndef MHProject_MHAsiNetworkUrl_h
#define MHProject_MHAsiNetworkUrl_h
///**
// *  正式环境
// */
#define webUrl @"http://api.up-driving.com:8200/"

///**
// *  测试环境
// */
//#define webUrl @"http://192.168.199.220:8000"

//高德云图链接
#define GDWebUrl @"http://yuntuapi.amap.com/"

//接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@%@",webUrl,_path]

#define GAODE(_path) [NSString stringWithFormat:@"%@%@",GDWebUrl,_path]



#endif
