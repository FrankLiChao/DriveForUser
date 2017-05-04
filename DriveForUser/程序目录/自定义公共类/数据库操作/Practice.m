//
//  Practice.m
//  SQLiteTest
//
//  Created by bosheng on 15/7/24.
//  Copyright (c) 2015年 liuhuan. All rights reserved.
//

#import "Practice.h"

@implementation Practice

- (id)initWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord
{
    if (self == [super init]) {
        self.testID = testID;
        self.chapter = chapter;
        self.testSubject = testSubject;
        self.answerA = answerA;
        self.answerB = answerB;
        self.answerC = answerC;
        self.answerD = answerD;
        self.testAnswer = testAnswer;
        self.imageName = imageName;
        self.testAnalysis = testAnalysis;
        self.userAns = userAns;
        self.collect= collect;
        self.answerRecord = answerRecord;
    }
    return self;
}

- (id)initWithTestID:(NSInteger)testID withChapter:(NSInteger)chapter withTestSubject:(NSString *)testSubject withAnswerA:(NSString *)answerA withAnswerB:(NSString *)answerB withAnswerC:(NSString *)answerC withAnswerD:(NSString *)answerD withTestAnswer:(NSInteger)testAnswer withQuestionType:(NSInteger)questionType withLinkUrl:(NSString *)linkUrl withImageName:(NSString *)imageName withTestAnalysis:(NSString *)testAnalysis withUserAns:(NSInteger)userAns withCollect:(NSInteger)collect withAnswerRecord:(NSInteger)answerRecord
{
    if (self == [super init]) {
        self.testID = testID;
        self.chapter = chapter;
        self.testSubject = testSubject;
        self.answerA = answerA;
        self.answerB = answerB;
        self.answerC = answerC;
        self.answerD = answerD;
        self.testAnswer = testAnswer;
        self.imageName = imageName;
        self.testAnalysis = testAnalysis;
        self.userAns = userAns;
        self.collect= collect;
        self.questionType = questionType;
        self.linkUrl = linkUrl;
        self.answerRecord = answerRecord;
    }
    return self;
}

@end
