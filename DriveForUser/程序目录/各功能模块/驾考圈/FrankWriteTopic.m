//
//  FrankWriteTopic.m
//  Drive
//
//  Created by lichao on 15/12/28.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "FrankWriteTopic.h"
#import "ZYQAssetPickerController.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface FrankWriteTopic ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>{
    UITextView *feedTextView;
    UILabel * placeHolder;
    NSMutableArray * writeImgArray;       //选择的图片
    UIButton *addBtn;
    UIView *bgView;
    UIView *selectView;
    NSString *groupValue;                //选择的分组
    NSInteger uploadPicCount;            //已上传图片数量
    NSMutableArray * addMessagePicName;  //存储上传图片名字
}

@end

@implementation FrankWriteTopic

- (void)viewDidLoad {
    [super viewDidLoad];
    [[lhColor shareColor]originalInit:self title:@"编辑" imageName:nil backButton:YES];
    writeImgArray = [[NSMutableArray alloc] init];
    addMessagePicName = [[NSMutableArray alloc] init];
    groupValue = @"";
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"0" forKey:writeMessagePicCount];
    [self initFrameView];
}

- (void)initFrameView
{
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    sendButton.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [sendButton addTarget:self action:@selector(sendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    CGFloat hight = 64;
    
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 110*widthRate)];
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];

    feedTextView = [[UITextView alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 100*widthRate)];
    feedTextView.delegate = self;
    feedTextView.font = [UIFont fontWithName:fontName size:14];
    feedTextView.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
//    feedTextView.backgroundColor = [UIColor redColor];
    [addView addSubview:feedTextView];
    
    placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth, 30*widthRate)];
    placeHolder.text = @"说点什么吧...";
    placeHolder.font = [UIFont fontWithName:fontName size:14];
    placeHolder.textColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    [addView addSubview:placeHolder];
    
    hight += 110*widthRate;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 56*widthRate)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(10*widthRate, 0, 56*widthRate, 56*widthRate);
    [addBtn setBackgroundImage:imageWithName(@"addButtonImg") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
    hight += bgView.frame.size.height;
    
    selectView = [[UIView alloc]initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, DeviceMaxHeight-hight)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [selectView addSubview:lineV];
    
    UILabel *selectType = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 20*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    selectType.text = @"选择分组";
    selectType.textColor = [lhColor colorFromHexRGB:contentTitleColorStr];
    selectType.font = [UIFont systemFontOfSize:15];
    selectType.backgroundColor = [UIColor whiteColor];
    [selectView addSubview:selectType];
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*widthRate, DeviceMaxWidth, DeviceMaxHeight)];
    typeView.backgroundColor = [lhColor colorFromHexRGB:viewColorStr];
    [selectView addSubview:typeView];
    
    CGFloat widthX = 0;
    CGFloat hightY = 0;
    for (int i=0; i<self.categoryArray.count; i++) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(10*widthRate+widthX, 10*widthRate+hightY, 100*widthRate, 35*widthRate);
        [typeBtn setTitle:[self.categoryArray[i] objectForKey:@"name"] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [typeBtn setTitleColor:[lhColor colorFromHexRGB:contentTitleColorStr] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        typeBtn.layer.cornerRadius = 3;
        typeBtn.tag = 555+i;
        typeBtn.layer.borderWidth = 0.5;
        typeBtn.layer.borderColor = [[lhColor colorFromHexRGB:contentTitleColorStr1] CGColor];
        [typeBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [typeBtn sizeToFit];
        CGRect rect = typeBtn.frame;
        rect.size.width += 10*widthRate;
        typeBtn.frame = rect;
        [typeView addSubview:typeBtn];
        
        widthX += typeBtn.frame.size.width + 10*widthRate;
        if (widthX > DeviceMaxWidth-10*widthRate){
            widthX = 0;
            hightY += 35*widthRate;
            CGRect rect = typeBtn.frame;
            rect.origin.x = widthX + 10*widthRate;
            rect.origin.y = hightY + 10*widthRate;
            typeBtn.frame = rect;
//            typeView.frame = CGRectMake(0, hight, DeviceMaxWidth, 75*widthRate+hightY);
            
            widthX += typeBtn.frame.size.width + 10*widthRate;
        }
    }
}

-(void)clickTypeBtn:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor clearColor]];
        groupValue = @"";
        
    }else{
        for (int i=0; i<8; i++) {
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:555+i];
            if (btn1.selected) {
                btn1.selected = NO;
                [btn1 setBackgroundColor:[UIColor clearColor]];
            }
        }
        btn.selected = YES;
        [btn setBackgroundColor:[lhColor colorFromHexRGB:mainColorStr]];
        NSString *str = [NSString stringWithFormat:@"%@",[self.categoryArray[btn.tag-555] objectForKey:@"number"]];
        groupValue = [NSString stringWithFormat:@"%@",str];
    }
    NSLog(@"groupValue = %@",groupValue);
}

#pragma mark -添加图片
-(void)addBtnEvent{
//    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"相册选取", nil];
//    actionSheet.tag = 2;
//    [actionSheet showInView:self.view];
    //初始没选中任何照片
   
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    [lhColor shareColor].uploadPicNumber = 9;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    if (assets.count == 0) {
        
        return;
    }
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [writeImgArray addObject:tempImg];
    }
    
    NSLog(@"%@",writeImgArray);
    
    [self showSelectPic:writeImgArray maxView:bgView];
}

//展示选中的图片
- (void)showSelectPic:(NSMutableArray *)imgArray maxView:(UIView *)maxView
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * countStr = [NSString stringWithFormat:@"%ld",(long)imgArray.count];
    [userDefault setObject:countStr forKey:writeMessagePicCount];
    [userDefault synchronize];
    
    for (UIView * view in bgView.subviews) {
        if (view != addBtn) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger cccount = imgArray.count;
    if (cccount > 9) {
        cccount = 9;
    }
    for (int i = 0; i < cccount; i++) {
        
        UIImageView * picView = [[UIImageView alloc]initWithFrame:CGRectMake(10*widthRate+61*widthRate*(i%5), 61*widthRate*(i/5), 56*widthRate, 56*widthRate)];
        picView.tag = i;
        picView.userInteractionEnabled = YES;
        picView.image = [[lhColor shareColor]croppedImage:[imgArray objectAtIndex:i]];
        [maxView addSubview:picView];
        
        UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        delBtn.frame = CGRectMake(31*widthRate, 0, 25*widthRate, 25*widthRate);
        delBtn.tag = i;
        [delBtn setBackgroundImage:imageWithName(@"fabushaidandelete.png") forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [picView addSubview:delBtn];
        if (cccount > 4) {
            if (i == 4) {
                CGRect rect = maxView.frame;
                rect.size.height = 61*widthRate+66*widthRate;
                maxView.frame = rect;
                
                CGRect rect1 = selectView.frame;
                rect1.origin.y = maxView.frame.origin.y+maxView.frame.size.height;
                selectView.frame = rect1;
            }
        } else {
            CGRect rect = maxView.frame;
            rect.size.height = 61*widthRate;
            maxView.frame = rect;
            
            CGRect rect1 = selectView.frame;
            rect1.origin.y = maxView.frame.origin.y+maxView.frame.size.height;
            selectView.frame = rect1;
        }
        
    }
    
    if (imgArray.count <= 9) {
        addBtn.hidden = NO;
        addBtn.frame = CGRectMake(10*widthRate+61*widthRate*(imgArray.count%5), 61*widthRate*(imgArray.count/5), 56*widthRate, 56*widthRate);
    }
    else{
        addBtn.hidden = YES;
    }
    
    NSLog(@"初始化完成");
}

//删除图片
- (void)delBtnEvent:(UIButton *)button_
{
    //NSLog(@"删除");
    
    [writeImgArray removeObjectAtIndex:button_.tag];
    
    [self showSelectPic:writeImgArray maxView:bgView];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 2){//头像点击
        [self takePhotoAndVidoeWithIndex:buttonIndex];
    }
}

#pragma mark -
- (void)takePhotoAndVidoeWithIndex:(NSInteger)index
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    UIImagePickerController * mpic = [[UIImagePickerController alloc]init];
    
    switch (index) {
        case 0:{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            mpic.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
            break;
        case 1:{
            mpic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
            
        default:
            break;
    }
    if (index < 2) {
        mpic.delegate = self;
        mpic.allowsEditing = YES;//是否允许编辑照片
        mpic.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];//只可看见相册中的照片
        [self presentViewController:mpic animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    
}

- (void)sendButtonEvent
{
    if ([@"" isEqualToString:feedTextView.text]) {
        [lhColor showAlertWithMessage:@"请编辑话题信息~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        
        return;
    }
    if ([@"" isEqualToString:groupValue]) {
        [lhColor showAlertWithMessage:@"请选择话题分类" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([writeImgArray count]) {
        uploadPicCount = 0;
        [self uploadPhoto];
    }else{
//        [self sendFeedBackContent:feedTextView.text withPicture:@""];
        [self sendFeedBackContent:feedTextView.text withPicture:nil];
    }
}

- (void)sendFeedBackContent:(NSString *)contentStr withPicture:(NSArray *)picStrArray
{
    
    [lhColor addActivityView123:self.view];
    NSString *pictureStr = nil;
    if ([picStrArray count]) {
        pictureStr = [picStrArray componentsJoinedByString:@"|"];
    }else{
        pictureStr = @"";
    }
    NSDictionary * dic = @{@"id":[[lhColor shareColor].userInfo objectForKey:@"id"],
                           @"content":contentStr,
                           @"category":groupValue,
                           @"city":[lhColor shareColor].nowCityStr,
                           @"picture":pictureStr};
    NSLog(@"dic = %@",dic);
    
    [FrankNetworkManager postReqeustWithURL:PATH(@"bbs/topic") params:dic successBlock:^(id returnData){
        [lhColor disAppearActivitiView:self.view];
        if ([[returnData objectForKey:@"status"]integerValue] == 1) {
            [lhColor showAlertWithMessage:@"提交成功" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.vcType == 1) {
                [self.delegate refreshTabView];
            }else if (self.vcType == 2){
                [self.topicDelegate refreshTabView];
            }
            self.vcType = 0;
        }else{
            [FrankTools requestFailAlertShow:[returnData objectForKey:@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        FLLog(@"%@",error.localizedDescription);
        [FrankTools wangluoAlertShow];
        [lhColor disAppearActivitiView:self.view];
    } showHUD:NO];
}

//上传图片
- (void)uploadPhoto
{
    /*
    UIImage * img = [writeImgArray objectAtIndex:uploadPicCount];
    NSLog(@"上传的图片 = %@",writeImgArray);
    NSData * imData = UIImageJPEGRepresentation(img, 0.5);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPhotoEvent:) name:@"uploadPhoto" object:nil];
    NSDictionary * _params = @{};
    [[lhWeb alloc]uploadPhoto:@"a/fileServer/upload?type=3" params:_params serviceName:@"imgFile" NotiName:@"uploadPhoto" imageD:imData];
     */
    NSArray *arry = @[@"1",@"2",@"3"];
    NSMutableArray *nameArray = [[NSMutableArray alloc] initWithArray:arry];
    [lhColor addActivityView:self.view];
    NSDictionary *resultDic = [lhWeb postRequestWithURL:@"a/fileServer/upload?type=3" postParems:nil picFilePath:writeImgArray picFileName:nameArray];
    NSLog(@"上传结果 = %@",resultDic);
    if ([[resultDic objectForKey:@"status"] integerValue] == 1) {
        [lhColor disAppearActivitiView:self.view];
        NSArray *array = [[resultDic objectForKey:@"data"] componentsSeparatedByString:@"|"];
//        for (int i=0; i<array.count; i++) {
//            [addMessagePicName addObject:array[i]];
//        }
        [self sendFeedBackContent:feedTextView.text withPicture:array];
    }else{
        [lhColor disAppearActivitiView:self.view];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark - 上传图片结果
- (void)uploadPhotoEvent:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
    NSLog(@"图片上传结果 %@",noti.userInfo);
    if (!noti.userInfo || [noti.userInfo class] == [[NSNull alloc]class]) {
        [lhColor disAppearActivitiView:self.view];
        [lhColor wangluoAlertShow];
        return;
    }
    if ([[noti.userInfo objectForKey:@"status"]integerValue] == 1) {
        uploadPicCount++;
        NSString * picName = [noti.userInfo objectForKey:@"data"];
        [addMessagePicName addObject:picName];
        
        if (uploadPicCount == writeImgArray.count) {//图片上传成功之后，发表留言
            [self sendFeedBackContent:feedTextView.text withPicture:@""];
        }
        else{
            [self uploadPhoto];
        }
    }
    else{
        [lhColor disAppearActivitiView:self.view];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHolder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([@"" isEqualToString:textView.text]) {
        placeHolder.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [feedTextView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [lhColor assignmentForTempVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
