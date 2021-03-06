//
//  HCCustomTagContactTableViewCell.h
//  Project
//
//  Created by 朱宗汉 on 15/12/18.
//  Copyright © 2015年 com.xxx. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HCCustomTagContactTableViewCellDelegate <NSObject>

@optional
-(void)dismissDatePicker0;
@end

@interface HCCustomTagContactTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSMutableArray *contactArr;

@property (nonatomic, weak) id<HCCustomTagContactTableViewCellDelegate>delegate;
@end
