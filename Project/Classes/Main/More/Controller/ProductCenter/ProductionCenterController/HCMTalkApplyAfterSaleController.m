//
//  HCMTalkApplyAfterSaleController.m
//  Project
//
//  Created by 朱宗汉 on 16/3/17.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "HCMTalkApplyAfterSaleController.h"
#import "HCMtalkReturnReason.h"
#import "HCMtalkAuditingController.h"

#import "HCMtalkMyOrderInfo.h"

@interface HCMTalkApplyAfterSaleController (){
    NSInteger num1;
}

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) HCMtalkMyOrderInfo *info;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIView *smallView;

@end

@implementation HCMTalkApplyAfterSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
//----------------------------申请售后--------------------------------
    self.title = @"申请售后";
    [self setupBackItem];
    num1 = 1;
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.footerView];
  
}


#pragma mark ---- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else if (indexPath.section == 1)
    {
        return 44;
    }
    else if (indexPath.section == 2)
    {
        if ( indexPath.row == 0) {
            return 44;
        }
        else
        {
            return 80;
        }
        
    }
    else
    {
        return 120;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        
        UIImageView * bigIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        bigIV.image = IMG(@"1");
        [cell addSubview:bigIV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, SCREEN_WIDTH-120, 40)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:@"套餐A M-talk二维码标签10张+M-talk烫印机1个" ];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 2)];
        
        label.attributedText = attStr;
        label.numberOfLines = 0;
        [cell addSubview:label];
        
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(120,CGRectGetMaxY(label.frame) +5, 50, 20)];
        numLabel.text = @"X1";
        numLabel.textColor = [UIColor blackColor];
        [cell addSubview:numLabel];
        
        UILabel *priceLabe = [[UILabel alloc]initWithFrame:CGRectMake(120,CGRectGetMaxY(numLabel.frame)+5, 80, 30)];
        priceLabe.textColor = [UIColor blackColor];
        priceLabe.text = self.info.price;
        [cell addSubview:priceLabe];
        return cell;

    }
    else if (indexPath.section == 1)
    {
        if (indexPath.section == 1&&indexPath.row == 0)
        {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"退货选择  M-Talk烫印机"];
            [attStr addAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, 4)];
            cell.textLabel.attributedText = attStr;
            
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 35, 20)];
            self.smallView  =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115, 11, 105, 20)];
            

            self.smallView.layer.borderWidth = 1;
            self.smallView.layer.borderColor = kHCBackgroundColor.CGColor;
            ViewRadius(self.smallView, 5);

            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setTitle:@"-" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button1.layer.borderWidth = 1;
            [button1 addTarget:self action:@selector(minusNum) forControlEvents:UIControlEventTouchUpInside];
            button1.frame = CGRectMake(0, 0, 35, 20);
        
            
            self.label.text =[NSString stringWithFormat:@"%ld",num1];
            self.label.textColor = [UIColor blackColor];
            self.label.textAlignment = NSTextAlignmentCenter;

            UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button3 setTitle:@"+" forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button3.layer.borderWidth =1;
            button3.frame = CGRectMake(70, 0, 35, 20);
            
            [self.smallView addSubview:button1];
            [self.smallView  addSubview:self.label];
            [self.smallView  addSubview:button3];
            
            [cell addSubview:self.smallView ];
           
            
        }
        else
        {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"退货款 8.9元"];
            [attStr addAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, 4)];
            
            cell.textLabel.attributedText = attStr;
   
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"退货原因";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 6, 80, 30)];
            label.text = @"不能烫印标签";
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 60)];
            textView.text = @"原因描述:";
            textView.textColor = [UIColor blackColor];
            [cell addSubview:textView];
        }
 
    }
    else
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        titleLabel.text = @"上传图片";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 40, 50, 50);
        [button setBackgroundImage:IMG(@"Add-Images") forState:UIControlStateNormal];
        [cell addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100,SCREEN_WIDTH-20, 10)];
        label.textColor = [UIColor grayColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = @"最多上传三张图片，每张不得超过5M，支持JPG、BMP、PNG";
        [cell addSubview:label];
    
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2&& indexPath.row == 0) {
        
        HCMtalkReturnReason *reasonVC = [[HCMtalkReturnReason alloc]init];
        [self.navigationController pushViewController:reasonVC animated:YES];
    }
}


#pragma mark --- private mothod

-(void)toAuditVC
{
    HCMtalkAuditingController *auditVC = [[HCMtalkAuditingController alloc]init];
    [self.navigationController pushViewController:auditVC animated:YES];

}


-(void)minusNum
{
    NSInteger num = [self.label.text integerValue];
    num = num + 1;
    self.label.text = [NSString stringWithFormat:@"%ld",num];
}

#pragma mark ---setter or getter

- (HCMtalkMyOrderInfo *)info
{
    if(!_info){
        _info = [[HCMtalkMyOrderInfo alloc]init];
        _info.title = @"套餐A M-talk二维码标签10张+M-talk烫印机1个";
        _info.price = @"￥9.9元";

    }
    return _info;
}


- (UITableView *)myTableView
{
    if(!_myTableView){
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.backgroundColor = kHCBackgroundColor;
        
    }
    return _myTableView;
}



- (UIView *)footerView
{
    if(!_footerView){
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 50)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        imageView.image = IMG(@"answer");
        [button addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 60, 30)];
        label.textColor = OrangeColor;
        label.text = @"联系客服";
        label.adjustsFontSizeToFitWidth= YES;
        
        [button addSubview:imageView];
        [button addSubview:label];
        
        [_footerView addSubview:button];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(110, 0,SCREEN_WIDTH-110 , 50);
        [rightBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.backgroundColor = OrangeColor;
        [rightBtn addTarget:self action:@selector(toAuditVC) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:rightBtn];
    }
    return _footerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
