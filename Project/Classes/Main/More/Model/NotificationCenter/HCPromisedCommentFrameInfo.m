//
//  HCPromisedCommentFrameInfo.m
//  Project
//
//  Created by 朱宗汉 on 16/2/1.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "HCPromisedCommentFrameInfo.h"
#import "HCPromisedCommentInfo.h"




@implementation HCPromisedCommentFrameInfo

-(void)setCommentInfo:(HCPromisedCommentInfo *)commentInfo
{
    _commentInfo = commentInfo;
    _headBtnFrame = CGRectMake(10,5, 50, 50);
    _nickLabelFrame = CGRectMake(70, 15, 200, 25);
    _timeLabelFrame = CGRectMake(70,35, 100, 20);
    _backLabelFrame = CGRectMake(SCREEN_WIDTH-70, 15, 60, 25);
    
    NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",commentInfo.nickName,commentInfo.toNickName,commentInfo.content];
    
    CGRect commentRect  = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor grayColor]} context:nil];
    
    _commentLabelFrame = CGRectMake(70,50, SCREEN_WIDTH-120, commentRect.size.height);
    _button1Frame =  CGRectMake(70 , CGRectGetMaxY(_commentLabelFrame) + 10 , 50, 50);
    _button2Frame = CGRectMake(130,CGRectGetMaxY(_commentLabelFrame)+10,50 ,50);
    _button3Frame = CGRectMake(190,CGRectGetMaxY(_commentLabelFrame) + 10,50,50);
    
    _readTextFildFrame = CGRectMake(10, CGRectGetMaxY(_button3Frame)+5, SCREEN_WIDTH-20, 20);
    
    if (commentInfo.toId) {
         _cellHeight = CGRectGetMaxY(_button3Frame) +10;
    }
    else
    {
       _cellHeight =CGRectGetMaxY(_readTextFildFrame) +10;
    }
}

@end
