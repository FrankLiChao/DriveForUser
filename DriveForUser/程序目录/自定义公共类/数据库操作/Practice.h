//
//  Practice.h
//  SQLiteTest
//
//  Created by bosheng on 15/7/24.
//  Copyright (c) 2015年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Practice : NSObject

@property (nonatomic,assign) NSInteger testID;
@property (nonatomic,assign) NSInteger chapter;
@property (nonatomic,retain) NSString * testSubject;
@property (nonatomic,retain) NSString * answerA;
@property (nonatomic,retain) NSString * answerB;
@property (nonatomic,retain) NSString * answerC;
@property (nonatomic,retain) NSString * answerD;
@property (nonatomic,assign) NSInteger testAnswer;
@property (nonatomic,retain) NSString * imageName;
@property (nonatomic,retain) NSString * testAnalysis;
@property (nonatomic,assign) NSInteger userAns;
@property (nonatomic,assign) NSInteger collect;
@property (nonatomic,assign)NSInteger questionType;
@property (nonatomic,retain)NSString * linkUrl;
@property (nonatomic,assign)NSInteger answerRecord;

- (id)initWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord;

- (id)initWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord;
@end
