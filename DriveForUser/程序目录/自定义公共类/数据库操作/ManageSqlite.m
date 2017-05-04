//
//  ManageSqlite.m
//  SQLiteTest
//
//  Created by 刘欢 on 15/5/28.
//  Copyright (c) 2015年 liuhuan. All rights reserved.
//

#import "ManageSqlite.h"
#import "Practice.h"

#define FILE_NAME1 @"practiceTopic.sqlite"
#define TABLE_NAME1 "PracticeTopic"

#define FILE_NAME4 @"practiceTopic4.sqlite"
#define TABLE_NAME4 "PracticeTopic4"

static sqlite3 * dbPointer = nil;//数据库指针，类似单例
static sqlite3 * dbPointer4 = nil;

@implementation ManageSqlite

+ (sqlite3 *)openDB
{
    if (dbPointer) {//如果数据库已经打开，返回数据库指针

        return dbPointer;
    }
    //沙盒中sql文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"sqlite路径： %@",docPath);
    
    NSString *sqlFilePath = [docPath stringByAppendingPathComponent:FILE_NAME1];
    
    //原始sql文件路径
//    NSString *originFilePath = [[NSBundle mainBundle]pathForResource:@"sqliteTest" ofType:@"sqlite"];

    NSFileManager *fm = [NSFileManager defaultManager];
    
loop:
    if ([fm fileExistsAtPath:sqlFilePath] == NO) {//如果数据库不存在,先创建再打开，再建表
        NSError *error = nil;
        if ([fm createFileAtPath:sqlFilePath contents:nil attributes:[NSMutableDictionary dictionary]]) {
            NSLog(@"创建数据库成功");
            
            sqlite3_open([sqlFilePath UTF8String], &dbPointer);//打开数据库，并且设置其指针
            
            //创建表
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %s (TestID INTEGER PRIMARY KEY AUTOINCREMENT, Chapter INTEGER ,TestSubject TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, TestAnswer INTEGER, ImageName TEXT, TestAnalysis TEXT, UserAns INTEGER, Collect INTEGER)",TABLE_NAME1];
            [self execSql:sqlCreateTable];
            
        }
        else{
            NSLog(@"创建数据库时出现了错误：%@",[error localizedDescription]);
            
            goto loop;
        }
    }
    else{//数据库存在，直接打开
        
        sqlite3_open([sqlFilePath UTF8String], &dbPointer);//打开数据库，并且设置其指针

    }
    
    return dbPointer;
}

+ (void)closeDB
{
    if (dbPointer) {
        
        sqlite3_close(dbPointer);//关闭数据库
        dbPointer = nil;
    }
}

+(sqlite3 *)openDB4{
    if (dbPointer4) {//如果数据库已经打开，返回数据库指针
        
        return dbPointer4;
    }
    //沙盒中sql文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"sqlite路径： %@",docPath);
    
    NSString *sqlFilePath = [docPath stringByAppendingPathComponent:FILE_NAME4];
    
    //原始sql文件路径
    //    NSString *originFilePath = [[NSBundle mainBundle]pathForResource:@"sqliteTest" ofType:@"sqlite"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
loop:
    if ([fm fileExistsAtPath:sqlFilePath] == NO) {//如果数据库不存在,先创建再打开，再建表
        NSError *error = nil;
        if ([fm createFileAtPath:sqlFilePath contents:nil attributes:[NSMutableDictionary dictionary]]) {
            NSLog(@"创建数据库成功");
            
            sqlite3_open([sqlFilePath UTF8String], &dbPointer4);//打开数据库，并且设置其指针
            
            //创建表
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %s (TestID INTEGER PRIMARY KEY AUTOINCREMENT, Chapter INTEGER ,TestSubject TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, TestAnswer INTEGER, QuestionType INTEGER, LinkUrl TEXT, ImageName TEXT, TestAnalysis TEXT, UserAns INTEGER, Collect INTEGER)",TABLE_NAME4];
            [self execSql4:sqlCreateTable];
            
        }
        else{
            NSLog(@"创建数据库时出现了错误：%@",[error localizedDescription]);
            
            goto loop;
        }
    }
    else{//数据库存在，直接打开
        
        sqlite3_open([sqlFilePath UTF8String], &dbPointer4);//打开数据库，并且设置其指针
        
    }
    
    return dbPointer4;
}

//执行非查询的sql语句
+(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dbPointer, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dbPointer);
        NSLog(@"数据库操作数据失败!");
    }
}

+(void)execSql4:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dbPointer4, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dbPointer4);
        NSLog(@"数据库操作数据失败!");
    }
}

+ (void)closeDB4
{
    if (dbPointer4) {
        
        sqlite3_close(dbPointer4);//关闭数据库
        dbPointer4 = nil;
    }
}

#pragma mark - 数据库操作
//查看表中有多少条信息
+(int)count
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
//    NSString * aa = [NSString stringWithFormat:@"select count(*) from %@",TABLE_NAME];
    char * b = malloc(50);
    sprintf(b,"select count(*) from %s",TABLE_NAME1);
    int result = sqlite3_prepare_v2(db, b, -1, &stmt, nil);
    
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        if(SQLITE_ROW == sqlite3_step(stmt))//判断表中是否有数据
        {
            int count = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);//结束sql
            return count;
        }
    }
    else
    {
        NSLog(@"count failed with result:%d",result);
    }
    sqlite3_finalize(stmt);
    
    return 0;
}

//查看表中的章节数
+(int)chapterCount{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "select Chapter from PracticeTopic ORDER BY Chapter DESC", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int chapter = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
            return chapter;
        }
    }
    else{
        NSLog(@"count failed with result:%d",result);
    }
    sqlite3_finalize(stmt);
    return 0;
}

#pragma mark - 新增记录
//添加新记录
+(int)addPracticeTopicWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord
{
 
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "insert into PracticeTopic(TestID,Chapter,TestSubject,AnswerA,AnswerB,AnswerC,AnswerD,TestAnswer,ImageName,TestAnalysis,UserAns,Collect) values(?,?,?,?,?,?,?,?,?,?,?,?)", -1, &stmt, nil);
    
    if (testSubject == NULL) {
        testSubject = @"";
    }
    if (answerA == NULL) {
        answerA = @"";
    }
    if (answerB == NULL) {
        answerB = @"";
    }
    if (answerC == NULL) {
        answerC = @"";
    }
    if (answerD == NULL) {
        answerD = @"";
    }
    if (imageName == NULL) {
        imageName = @"";
    }
    if (testAnalysis == NULL) {
        testAnalysis = @"";
    }
    
    sqlite3_bind_int(stmt, 1, (int)testID);
    sqlite3_bind_int(stmt,2, (int)chapter);
    sqlite3_bind_text(stmt,3, [testSubject UTF8String], -1, nil);
    sqlite3_bind_text(stmt,4, [answerA UTF8String], -1, nil);
    sqlite3_bind_text(stmt,5, [answerB UTF8String], -1, nil);
    sqlite3_bind_text(stmt,6, [answerC UTF8String], -1, nil);
    sqlite3_bind_text(stmt,7, [answerD UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 8, (int)testAnswer);
    sqlite3_bind_text(stmt,9, [imageName UTF8String], -1, nil);
    sqlite3_bind_text(stmt,10, [testAnalysis UTF8String], -1, nil);
    sqlite3_bind_int(stmt,11,(int)userAns);
    sqlite3_bind_int(stmt,12,(int)collect);

    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

+(int)addPracticeTopicWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withquestionType:(NSInteger)questionType withlinkUrl:(NSString *)linkUrl withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord
{
    if ((int)questionType == 2) {
        NSString *subject = [testSubject stringByReplacingOccurrencesOfString:@"（本题正式考试时为多选题，本站已处理成单选，将题目选项放置在题目文本中）" withString:@""];
        subject = [subject stringByReplacingOccurrencesOfString:@"①" withString:@"#"];
        subject = [subject stringByReplacingOccurrencesOfString:@"②" withString:@"#"];
        subject = [subject stringByReplacingOccurrencesOfString:@"③" withString:@"#"];
        subject = [subject stringByReplacingOccurrencesOfString:@"④" withString:@"#"];
        testSubject = subject;
    }else{
        imageName = [imageName lastPathComponent];
    }
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "insert into PracticeTopic4(TestID,Chapter,TestSubject,AnswerA,AnswerB,AnswerC,AnswerD,TestAnswer,QuestionType,LinkUrl,ImageName,TestAnalysis,UserAns,Collect) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", -1, &stmt, nil);
    
    if (testSubject == NULL) {
        testSubject = @"";
    }
    if (answerA == NULL) {
        answerA = @"";
    }
    if (answerB == NULL) {
        answerB = @"";
    }
    if (answerC == NULL) {
        answerC = @"";
    }
    if (answerD == NULL) {
        answerD = @"";
    }
    if (imageName == NULL) {
        imageName = @"";
    }
    if (testAnalysis == NULL) {
        testAnalysis = @"";
    }
    if (linkUrl == NULL) {
        linkUrl = @"";
    }
    
    sqlite3_bind_int(stmt, 1, (int)testID);
    sqlite3_bind_int(stmt,2, (int)chapter);
    sqlite3_bind_text(stmt,3, [testSubject UTF8String], -1, nil);
    sqlite3_bind_text(stmt,4, [answerA UTF8String], -1, nil);
    sqlite3_bind_text(stmt,5, [answerB UTF8String], -1, nil);
    sqlite3_bind_text(stmt,6, [answerC UTF8String], -1, nil);
    sqlite3_bind_text(stmt,7, [answerD UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 8, (int)testAnswer);
    sqlite3_bind_int(stmt, 9, (int)questionType);
    sqlite3_bind_text(stmt,10, [linkUrl UTF8String], -1, nil);
    sqlite3_bind_text(stmt,11, [imageName UTF8String], -1, nil);
    sqlite3_bind_text(stmt,12, [testAnalysis UTF8String], -1, nil);
    sqlite3_bind_int(stmt,13,(int)userAns);
    sqlite3_bind_int(stmt,14,(int)collect);
//    sqlite3_bind_int(stmt,15,(int)answerRecord);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

#pragma mark - 获取所有信息
//获取表中所有信息
+ (NSMutableArray *)findAll
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic", -1, &stmt, nil);
    //    int result1 = sqlite3_prepare_v2(db, "", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        //创建一个数组，存放所有的学生
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

//获取科目四数据表的所有信息
+ (NSMutableArray *)findDb4All
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4", -1, &stmt, nil);
    //    int result1 = sqlite3_prepare_v2(db, "", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        //创建一个数组，存放所有的学生
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
            const unsigned char *linkUrl1 = sqlite3_column_text(stmt, 9);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = [NSString stringWithUTF8String:(const char *)linkUrl1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

//获取科目一表中对应章节的数据
+(NSMutableArray *)findDataFormChapter:(int)chapter
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where Chapter = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,chapter);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

//获取科目四表中对应章节的数据
+(NSMutableArray *)findData4FormChapter:(int)chapter
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where Chapter = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,chapter);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
            const unsigned char *linkUrl1 = sqlite3_column_text(stmt, 9);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = [NSString stringWithUTF8String:(const char *)linkUrl1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

//获取科目一表的某条数据是否收藏
+(NSInteger)findCollectRecord:(NSInteger)index
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where testID = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,(int)index);
        int collect = 0;
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            collect = sqlite3_column_int(stmt, 11);
        }
        sqlite3_finalize(stmt);//结束sql
        return collect;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return 0;
    }
}

//获取科目四表的某条数据是否收藏
+(NSInteger)findCollectRecord4:(NSInteger)index
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where testID = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,(int)index);
        int collect = 0;
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            collect = sqlite3_column_int(stmt, 13);
        }
        sqlite3_finalize(stmt);//结束sql
        return collect;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return 0;
    }
}

+(Practice *)findRecordByID:(NSInteger)testID{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where testID = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,(int)testID);
        Practice * practice = nil;
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            practice = [[Practice alloc]initWithTestID:testID withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
        }
        sqlite3_finalize(stmt);//结束sql
        return practice;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return nil;
    }
}

+(Practice *)findRecordByID4:(NSInteger)testID{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where testID = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,(int)testID);
        Practice * practice = nil;
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = @"";
            NSInteger answerRecord = 0;
            
            practice = [[Practice alloc]initWithTestID:testID withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
        }
        sqlite3_finalize(stmt);//结束sql
        return practice;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return nil;
    }
}

+(NSMutableArray *)findRandomData{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic ORDER BY RANDOM() limit 100", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+(NSMutableArray *)findRandomData4
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 ORDER BY RANDOM() limit 100", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
//            const unsigned char *linkUrl1 = sqlite3_column_text(stmt, 9);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = @"";
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+(NSMutableArray *)findWrongRecord{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where userAns = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,2);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }

}

+(NSMutableArray *)findWrongRecord4{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where userAns = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,2);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
//            const unsigned char *linkUrl1 = sqlite3_column_text(stmt, 9);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = @"";
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
    
}


+(NSMutableArray *)findTrueRecord
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where userAns = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,1);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+(NSMutableArray *)findTrueRecord4
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where userAns = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,1);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = @"";
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+(NSMutableArray *)findCollectRecord{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic where collect = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,1);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+(NSMutableArray *)findCollectRecord4{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    sqlite3_stmt *stmt = nil;
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select * from PracticeTopic4 where collect = ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_int(stmt,1,1);
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要学生表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            int questionType = sqlite3_column_int(stmt, 8);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSString * linkUrl = @"";
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        return studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        return [NSMutableArray array];
    }
}

+ (BOOL)isStudentExistWithName:(NSString *)aName
{
    sqlite3 *db = [ManageSqlite openDB];
    sqlite3_stmt *stmt = nil;
    
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(db, "select count(*) from PracticeTopic where name like ?", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        sqlite3_bind_text(stmt, 1, [aName UTF8String], -1, nil);
        
        if(SQLITE_ROW == sqlite3_step(stmt))//判断学生表中是否有数据
        {
            int count = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);//结束sql
            BOOL isExist = count > 0 ? YES : NO;
            return isExist;
        }
    }
    else
    {
        NSLog(@"count failed with result:%d",result);
    }
    sqlite3_finalize(stmt);
    
    return NO;
}

#pragma mark - 更新数据
//更新（修改）科目一数据
+ (int)updateAccordingTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "update PracticeTopic set Chapter = ?,TestSubject = ?,AnswerA = ?,AnswerB = ?,AnswerC = ?,AnswerD = ?,TestAnswer = ?,ImageName = ?,TestAnalysis = ?,UserAns = ?,Collect = ? where TestID=?", -1, &stmt, nil);
    
    if (testSubject == NULL) {
        testSubject = @"";
    }
    if (answerA == NULL) {
        answerA = @"";
    }
    if (answerB == NULL) {
        answerB = @"";
    }
    if (answerC == NULL) {
        answerC = @"";
    }
    if (answerD == NULL) {
        answerD = @"";
    }
    if (imageName == NULL) {
        imageName = @"";
    }
    if (testAnalysis == NULL) {
        testAnalysis = @"";
    }
    
    sqlite3_bind_int(stmt,1, (int)chapter);
    sqlite3_bind_text(stmt,2, [testSubject UTF8String], -1, nil);
    sqlite3_bind_text(stmt,3, [answerA UTF8String], -1, nil);
    sqlite3_bind_text(stmt,4, [answerB UTF8String], -1, nil);
    sqlite3_bind_text(stmt,5, [answerC UTF8String], -1, nil);
    sqlite3_bind_text(stmt,6, [answerD UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 7, (int)testAnswer);
    sqlite3_bind_text(stmt,8, [imageName UTF8String], -1, nil);
    sqlite3_bind_text(stmt,9, [testAnalysis UTF8String], -1, nil);
    sqlite3_bind_int(stmt,10,(int)userAns);
    sqlite3_bind_int(stmt,11,(int)collect);
    sqlite3_bind_int(stmt,12, (int)testID);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}



//科目一用户回答更新
+(int)updateAccordingTestID:(NSInteger)testID withUserAns:(NSInteger)userAns
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "update PracticeTopic set UserAns = ? where TestID=?", -1, &stmt, nil);
    
    sqlite3_bind_int(stmt,1,(int)userAns);
    sqlite3_bind_int(stmt,2, (int)testID);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

//科目四用户回答更新
+(int)updateAccordingTestID4:(NSInteger)testID withUserAns:(NSInteger)userAns
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "update PracticeTopic4 set UserAns = ? where TestID=?", -1, &stmt, nil);
    
    sqlite3_bind_int(stmt,1,(int)userAns);
    sqlite3_bind_int(stmt,2, (int)testID);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

//更新科目一的收藏
+ (int)updateAccordingTestID:(NSInteger)testID withCollect:(NSInteger)collect
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "update PracticeTopic set Collect = ? where TestID=?", -1, &stmt, nil);
    
    sqlite3_bind_int(stmt,1,(int)collect);
    sqlite3_bind_int(stmt,2, (int)testID);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

//更新科目四的收藏
+ (int)updateAccordingTestID4:(NSInteger)testID withCollect:(NSInteger)collect
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB4];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "update PracticeTopic4 set Collect = ? where TestID=?", -1, &stmt, nil);
    
    sqlite3_bind_int(stmt,1,(int)collect);
    sqlite3_bind_int(stmt,2, (int)testID);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}


#pragma mark - 删除数据
//删除数据
+ (int)deleteWithID:(NSInteger)theID
{
    //打开数据库
    sqlite3 *db = [ManageSqlite openDB];
    
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare_v2(db, "delete from PracticeTopic where ID=?", -1, &stmt, nil);
    sqlite3_bind_int(stmt, 1, (int)theID);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    return result;
}

#pragma mark - access数据库操作
//读取本地数据库中的数据，并存储到沙盒sqlite数据库中
+ (void)readAccessDataBaseAndSaveToSqlite
{
    NSString *originFilePath = [[NSBundle mainBundle]pathForResource:@"DTSS_DB" ofType:@""];
    
    //打开数据库
    sqlite3 *database;
    if (sqlite3_open([originFilePath UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"open database faid !");
    }
    
    NSMutableArray * dataArray = [NSMutableArray array];
    
    sqlite3_stmt *stmt = nil;
    
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(database, "SELECT * FROM test1", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        //创建一个数组，存放所有的数据
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 9);
            int userAns = sqlite3_column_int(stmt, 10);
            int collect = sqlite3_column_int(stmt, 11);
            
            NSString * testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            NSString * answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            NSString * answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            NSString * answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            NSString * answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            NSString * imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            NSString * testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            NSInteger answerRecord = 0;
            
            Practice * practice = [[Practice alloc]initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        sqlite3_close(database);
        
        dataArray = studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        sqlite3_close(database);
    }

    for (int i = 0; i < dataArray.count; i++) {
        Practice * practice = (Practice *)[dataArray objectAtIndex:i];
        
        [ManageSqlite addPracticeTopicWithTestID:practice.testID withChapter:practice.chapter withTestSubject:practice.testSubject withAnswerA:practice.answerA withAnswerB:practice.answerB withAnswerC:practice.answerC withAnswerD:practice.answerD withTestAnswer:practice.testAnswer withImageName:practice.imageName withTestAnalysis:practice.testAnalysis withUserAns:practice.userAns withCollect:practice.collect withAnswerRecord:practice.answerRecord];
    }

    [ManageSqlite closeDB];
    
    NSLog(@"完成。。。。");
    
}

+ (void)readDbDataBaseAndSaveToSqlite{
    NSString *originFilePath = [[NSBundle mainBundle]pathForResource:@"kemu4" ofType:@""];
    
    //打开数据库
    sqlite3 *database;
    if (sqlite3_open([originFilePath UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0,@"open database faid !");
    }
    
    NSMutableArray * dataArray = [NSMutableArray array];
    
    sqlite3_stmt *stmt = nil;
    
    //编译sql语句，编译成功的话才能继续进行
    int result = sqlite3_prepare_v2(database, "SELECT * FROM Part4", -1, &stmt, nil);
    if(result == SQLITE_OK)//说明sql语句写的无误
    {
        //创建一个数组，存放所有的数据
        NSMutableArray *studentArray=[[NSMutableArray alloc] init];
        while(SQLITE_ROW == sqlite3_step(stmt))//只要表中有数据
        {
            //注意列是从0开始的。
            int testId = sqlite3_column_int(stmt, 0);
            int chapter = sqlite3_column_int(stmt, 1);
            const unsigned char *testSubject1 = sqlite3_column_text(stmt, 2);
            const unsigned char *answerA1 = sqlite3_column_text(stmt, 3);
            const unsigned char *answerB1 = sqlite3_column_text(stmt, 4);
            const unsigned char *answerC1 = sqlite3_column_text(stmt, 5);
            const unsigned char *answerD1 = sqlite3_column_text(stmt, 6);
            int testAnswer = sqlite3_column_int(stmt, 7);
            const unsigned char *imageName1 = sqlite3_column_text(stmt, 8);
            int questionType = sqlite3_column_int(stmt, 9);
            const unsigned char *linkUrl1 = sqlite3_column_text(stmt, 10);
            const unsigned char *testAnalysis1 = sqlite3_column_text(stmt, 11);
            int userAns = sqlite3_column_int(stmt, 12);
            int collect = sqlite3_column_int(stmt, 13);
            
            NSString * testSubject = nil;
            NSString * answerA = nil;
            NSString * answerB = nil;
            NSString * imageName = nil;
            NSString * answerC = nil;
            NSString * answerD = nil;
            NSString * testAnalysis = nil;
            NSString * linkUrl = nil;
            NSInteger answerRecord = 0;
            if (testSubject1 != NULL) {
                testSubject = [NSString stringWithUTF8String:(const char *)testSubject1];
            }else{
                testSubject = @"";
            }
            if (answerA1 != NULL) {
                answerA = [NSString stringWithUTF8String:(const char *)answerA1];
            }else{
                answerA = @"";
            }
            if (answerB1 != NULL) {
                answerB = [NSString stringWithUTF8String:(const char *)answerB1];
            }else{
                answerB = @"";
            }
            if (imageName1 != NULL) {
                imageName = [NSString stringWithUTF8String:(const char *)imageName1];
            }else{
                imageName = @"";
            }
            if (answerC1 != NULL) {
                answerC = [NSString stringWithUTF8String:(const char *)answerC1];
            }else{
                answerC = nil;
            }
            if (answerD1 != nil) {
                 answerD = [NSString stringWithUTF8String:(const char *)answerD1];
            }else{
                answerD = nil;
            }
            if (testAnalysis1 != NULL) {
                testAnalysis = [NSString stringWithUTF8String:(const char *)testAnalysis1];
            }else{
                testAnalysis = @"";
            }
            if (linkUrl1 != NULL) {
                linkUrl = [NSString stringWithUTF8String:(const char *)linkUrl1];
            }else{
                linkUrl = @"";
            }
            Practice * practice = [[Practice alloc] initWithTestID:testId withChapter:chapter withTestSubject:testSubject withAnswerA:answerA withAnswerB:answerB withAnswerC:answerC withAnswerD:answerD withTestAnswer:testAnswer withQuestionType:questionType withLinkUrl:linkUrl withImageName:imageName withTestAnalysis:testAnalysis withUserAns:userAns withCollect:collect withAnswerRecord:answerRecord];
            
            [studentArray addObject:practice];
        }
        sqlite3_finalize(stmt);//结束sql
        sqlite3_close(database);
        
        dataArray = studentArray;
    }
    else
    {
        NSLog(@"find all failed with result:%d",result);
        sqlite3_finalize(stmt);//结束sql
        sqlite3_close(database);
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        Practice * practice = (Practice *)[dataArray objectAtIndex:i];
        
        [ManageSqlite addPracticeTopicWithTestID:practice.testID withChapter:practice.chapter withTestSubject:practice.testSubject withAnswerA:practice.answerA withAnswerB:practice.answerB withAnswerC:practice.answerC withAnswerD:practice.answerD withTestAnswer:practice.testAnswer withquestionType:practice.questionType withlinkUrl:practice.linkUrl withImageName:practice.imageName withTestAnalysis:practice.testAnalysis withUserAns:practice.userAns withCollect:practice.collect withAnswerRecord:practice.answerRecord];
    }
    
    [ManageSqlite closeDB4];
}

@end
