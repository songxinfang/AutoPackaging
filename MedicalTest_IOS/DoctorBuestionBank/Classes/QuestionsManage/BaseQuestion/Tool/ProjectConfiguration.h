//
//  ProjectConfiguration.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#ifndef ProjectConfiguration_h
#define ProjectConfiguration_h


typedef NS_ENUM(NSInteger, CollectionViewStatus) {
    
    CollectionViewNone,
    CollectionViewHeader,
    CollectionViewFooter
    
};


#define FootViewHeight 76

#define HomeRowrowSpace 16
#define HomeCellLineSpace 16

#define HomeCellWidth (([UIScreen mainScreen].bounds.size.width -  HomeCellLineSpace *5)/4.0)

#define HomeCellHeight (( [UIScreen mainScreen].bounds.size.width -  HomeCellLineSpace *5)/4.0 *43/36 + 10 + HomeCellLineSpace)


typedef NS_ENUM(NSInteger, QuestionResultType) {
    QuestionResultNone , // 未设置
    QuestionResultPractice, // 练习
    QuestionResultExamination, // 考试

    MyPracticeWrongOrRecord ,  //  我的练习 我的错题

    ExaminationWrongReview , // 考试错题回顾
    PracticeWrongReview   //  练习错题回顾

   

};




// 最后一次生成的练习试卷的名称
#define UserDefaultsLastExaminationKey  @"UserDefaultsLastExaminationKey"

#define NSNotificationCentersliding  @"NSNotificationCentersliding"




/*****************************************************************************/
/*****************************************************************************/
/*****************************************************************************/



// 配置友盟统计的key

// 展开答案
#define TongJiToolshowAnswer  @"OpenAnswer"
//收起答案
#define TongJiToolcloseAnswer  @"PackAnswer"



// 收藏
#define TongJiToolCollection  @"Collect"

//取消收藏
#define TongJiToolcancelCollection  @"CancelCollect"

// 答题分享
#define TongJiToolShareResultQuestion  @"ProcessShare"



// 结果分享
#define TongJiToolShareQuestion  @"ResultShare"

// 答题
#define TongJiToolUserSelect @"Answer"


// 点击确定
#define TongJiToolClcikMakeSure @"ClickDo"

// 点击下一页
#define TongJiToolClcikNextBtn @"SwitchClickPrevious"

// 点击上一页
#define TongJiToolClcikPreBtn @"SwitchClickNext"

// 右滑
#define TongJiToolAllSlideToNext  @"SwitchSlidNext"
// 左滑
#define TongJiToolAllSlideToPre  @"SwitchSlidPrevious"


// 选择全部
#define TongJiToolChooseAll  @"ChapterSelectedAllClick"
// 取消选择全部
#define TongJiToolCancelChooseAll  @"ChapterCancelSelectedAllClick"

// 专业务实
#define TongJiToolClickZhuanYeWuShi  @"ProfessionalClick"

// 实践能力
#define TongJiToolClickShijianNeli  @"PracticalAbilityClick"


// 练习
#define TongJiToolClickPractice  @"ItemPractice"

// 随堂测试
#define TongJiToolClickExamination  @"PracticeTest"


// 首页

#define TongJiToolHome  @"HomePage"

// 错题复习

#define TongJiToolWrongReview  @"WrongReview"

// 练习纪录
#define TongJiToolPracticeRecord  @"PracticeRecord"

// 测验纪录
#define TongJiToolTestRecord  @"TestRecord"

// 考试纪录
#define TongJiToolExamRecord  @"ExamRecord"

// 我的收藏
#define TongJiToolMyCollection  @"MyCollection"

// 我的分享
#define TongJiToolMyShare  @"MyShare"

// 设置
#define TongJiToolClickSeting  @"Seting"




#endif /* ProjectConfiguration_h */
