//
//  HCBaseUserInfoCell.m
//  Project
//
//  Created by 朱宗汉 on 16/1/11.
//  Copyright © 2016年 com.xxx. All rights reserved.
//
#import "HCBaseUserInfoCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "HCPromisedDetailInfo.h"

@interface HCBaseUserInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeholderTitleArr;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *headerIMGBtn;

@end

@implementation HCBaseUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = RGB(46, 46, 46);
        self.textLabel.font = DefaultFontSize;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(dismissDatePicker)])
    {
        [self.delegate dismissDatePicker];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        _detailInfo.ObjectXName = textField.text;
    }else if (textField.tag == 2)
    {
        _detailInfo.ObjectSex = textField.text;
    }else if (textField.tag == 3)
    {
        _detailInfo.ObjectBirthDay = textField.text;
    }else if (textField.tag == 4)
    {
        _detailInfo.ObjectHomeAddress = textField.text;
    }else if (textField.tag == 5)
    {
        _detailInfo.ObjectSchool = textField.text;
    }else if (textField.tag == 6)
    {
        _detailInfo.ObjectIdNo = textField.text;
    }else if (textField.tag == 7)
    {
        _detailInfo.ObjectCareer = textField.text;
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.titleLabel.text = self.titleArr[indexPath.row];
    
    if (indexPath.row == 0)
    {
        [self.contentView addSubview: self.headerIMGBtn];
    }
    else if (indexPath.row != 0)
    {
        NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:self.placeholderTitleArr[indexPath.row - 1] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        self.textField.attributedPlaceholder = attriString;
    }
    
//    self.textField.enabled = _isEdit;
    if (indexPath.row == 1)
    {
        self.textField.text = _detailInfo.ObjectXName;
    }else if (indexPath.row == 2)
    {
        self.textField.text = _detailInfo.ObjectSex;
    }else if (indexPath.row == 3)
    {
        self.textField.text = _detailInfo.ObjectBirthDay;
    }else if (indexPath.row == 4)
    {
        self.textField.text = _detailInfo.ObjectHomeAddress;
    }else if (indexPath.row == 5)
    {
        self.textField.text = _detailInfo.ObjectSchool;
    }else if (indexPath.row == 6)
    {
        self.textField.text = _detailInfo.ObjectIdNo;
    }else if (indexPath.row == 7)
    {
        self.textField.text = _detailInfo.ObjectCareer;
        
    }
    
    if (indexPath.row == 0 || indexPath.row == 3)
    {
        self.textField.enabled = NO;
    }
    self.textField.delegate = self;
    self.textField.tag = indexPath.row;
    
}

#pragma mark --- privous Method

-(void)handleheaderIMG:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(addUserHeaderIMG:)])
    {
        [self.delegate addUserHeaderIMG:button];
    }
}

#pragma mark --  Setter Or Getter

-(UIButton *)headerIMGBtn
{
    if (!_headerIMGBtn)
    {
        _headerIMGBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 2, 80, 80)];
        [_headerIMGBtn setBackgroundImage:OrigIMG(@"Head-Portraits") forState:UIControlStateNormal];
        [_headerIMGBtn addTarget:self action:@selector(handleheaderIMG:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerIMGBtn;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 2, SCREEN_WIDTH-100, 40)];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = [UIColor blackColor];
    }
    return _textField;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGB(46, 46, 46);
    }
    return _titleLabel;
}

- (NSArray *)placeholderTitleArr
{
    if (!_placeholderTitleArr)
    {
        _placeholderTitleArr = @[@"请输入姓名",
                                 @"请选择性别",
                                 @"请输入生日",
                                 @"请输入住址",
                                 @"请输入学校名称",
                                 @"请输入身份证号",
                                 @"请输入职业"];
    }
    return _placeholderTitleArr;
}

- (NSArray *)titleArr
{
    if (!_titleArr)
    {
        _titleArr = @[@"头像",
                      @"姓名",
                      @"性别",
                      @"生日",
                      @"住址",
                      @"学校",
                      @"身份证",
                      @"职业"];
    }
    return _titleArr;
}

@end