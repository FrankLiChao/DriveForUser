//
//  ManageSqlite.h
//  SQLiteTest
//
//  Created by 刘欢 on 15/5/28.
//  Copyright (c) 2015年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class Practice;

@interface ManageSqlite : NSObject


/**
 *关闭科目一数据库
 */
+ (void)closeDB;

/**
 *关闭科目四数据库
 */
+ (void)closeDB4;

/**
 *获取表中所有信息
 */
+(NSMutableArray *)findAll;

/**
 *获取表中所有信息
 */
+ (NSMutableArray *)findDb4All;

/**
 *获取科目一表中所有对应章节的信息
 */
+(NSMutableArray *)findDataFormChapter:(int)chapter;

/**
 *获取科目四表中所有对应章节的信息
 */
+(NSMutableArray *)findData4FormChapter:(int)chapter;

/**
 *随机获取科目一表中100条数据
 */
+(NSMutableArray *)findRandomData;

/**
 *随机获取科目四表中100条数据
 */
+(NSMutableArray *)findRandomData4;

/**
 *获取科目一表中的错题的总记录
 */
+(NSMutableArray *)findWrongRecord;

/**
 *获取科目四表中的错题的总记录
 */
+(NSMutableArray *)findWrongRecord4;

/**
 *获取科目一表中的正确题的zo记录
 */
+(NSMutableArray *)findTrueRecord;

/**
 *获取科目四表中的正确题的总记录
 */
+(NSMutableArray *)findTrueRecord4;

/**
 *获取科目一表中的收藏的总记录
 */
+(NSMutableArray *)findCollectRecord;

/**
 *获取科目四表中的收藏的总记录
 */
+(NSMutableArray *)findCollectRecord4;

/**
 *获取科目一表中的某条数据是否收藏
 */
+(NSInteger)findCollectRecord:(NSInteger)index;

/**
 *获取科目四表中的某条数据是否收藏
 */
+(NSInteger)findCollectRecord4:(NSInteger)index;

/**
 *判断名字是否正确
 */
+(BOOL)isStudentExistWithName:(NSString *)aName;

/**
 *查看表中有多少条信息
 */
+(int)count;

/**
 *获取表中的章节数
 */
+(int)chapterCount;

/**
 *根据testID号获取科目一表中的相关数据
 */
+(Practice *)findRecordByID:(NSInteger)testID;

/**
 *根据testID号获取科目四表中的相关数据
 */
+(Practice *)findRecordByID4:(NSInteger)testID;


/**
 *科目一添加新的信息 返回值用来标识是否成功
 */
+(int)addPracticeTopicWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord;

/**
 *科目四添加新的信息 返回值用来标识是否成功
 */
+(int)addPracticeTopicWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withquestionType:(NSInteger)questionType withlinkUrl:(NSString *)linkUrl withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord;


/**
 *更新数据
 */
//更新科目一全部信息
+(int)updateAccordingTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect;

//更新科目一的一个元素
+(int)updateAccordingTestID:(NSInteger)testID withUserAns:(NSInteger)userAns;//更新用户回答
+(int)updateAccordingTestID:(NSInteger)testID withCollect:(NSInteger)collect;//更新收藏

//更新科目四的一个元素
+(int)updateAccordingTestID4:(NSInteger)testID withUserAns:(NSInteger)userAns;//更新用户回答
+(int)updateAccordingTestID4:(NSInteger)testID withCollect:(NSInteger)collect;//更新收藏


/**
 *删除
 */
+(int)deleteWithID:(NSInteger) theID;


/**
 * 读取项目中科目一数据库中的数据，并存储到沙盒sqlite数据库中
 */
+ (void)readAccessDataBaseAndSaveToSqlite;

/**
 * 读取项目中科目四数据库中的数据，并存储到沙盒sqlite数据库中
 */
+ (void)readDbDataBaseAndSaveToSqlite;

@end
