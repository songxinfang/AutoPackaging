//
//  AgreementViewController.m
//  DoctorBuestionBank
//
//  Created by  on 2016/11/7.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController () <UIWebViewDelegate>

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarBackGroundImage];
    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    webView.delegate = self;
    webView.backgroundColor = XYWYColor(250, 250, 250);
    [self.view addSubview:webView];
    
    [webView loadHTMLString:@"1、一切移动客户端用户在下载并浏览《护士执业资格考试app》时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本app相关声明和用户服务协议的约束。<br><br>2、《护士执业资格考试app》的内容并不代表《护士执业资格考试app》之意见及观点，也不意味着本网赞同其观点或证实其内容的真实性。<br><br>3、《护士执业资格考试app》转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。《护士执业资格考试app》不提供任何保证，并不承担任何法律责任。<br><br>4、《护士执业资格考试app》所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。<br><br>5、《护士执业资格考试app》不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由《护士执业资格考试app》实际控制的任何网页上的内容，《护士执业资格考试app》不承担任何责任。<br><br>6、用户明确并同意其使用《护士执业资格考试app》网络服务所存在的风险将完全由其本人承担；因其使用《护士执业资格考试app》网络服务而产生的一切后果也由其本人承担，《护士执业资格考试app》对此不承担任何责任。<br><br>7、除《护士执业资格考试app》注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，《护士执业资格考试app》概不负责，亦不承担任何法律责任。<br><br>8、对于因不可抗力或因黑客攻击、通讯线路中断等《护士执业资格考试app》不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用《护士执业资格考试app》，《护士执业资格考试app》不承担任何责任，但将尽力减少因此给用户造成的损失或影响。<br><br>9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。<br><br>10、本app相关声明版权及其修改权、更新权和最终解释权均属《护士执业资格考试app》所有。" baseURL:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.fontSize='14px'"];

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333'"];

}


@end
