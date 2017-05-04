//
//  MHAsiNetworkDefine.h
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#ifndef MHProject_FrankNetworkDefine_h
#define MHProject_FrankNetworkDefine_h

/**
 *  请求类型
 */
typedef enum {
    FrankNetWorkGET = 1,   /**< GET请求 */
    FrankNetWorkPOST       /**< POST请求 */
} FrankNetWorkType;

/**
 *  网络请求超时的时间
 */
#define AFN_API_TIME_OUT 20


#if NS_BLOCKS_AVAILABLE
/**
 *  请求开始的回调（下载时用到）
 */
typedef void (^FrankStartBlock)(void);

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^FrankSuccessBlock)(NSDictionary *returnData);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^FrankFailureBlock)(NSError *error);

#endif

#endif
