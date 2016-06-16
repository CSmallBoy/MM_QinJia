//
//  ContactListViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ContactListViewController.h"
#import "HCGradeManagerViewController.h"
#import "MyFriendsApi.h"
#import "ChineseString.h"
//#import "EaseChineseToPinyin.h"
#import "ChatViewController.h"
#import "RobotListViewController.h"
#import "ChatroomListViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"
//获取用户信息的网络请求
#import "NHCChatUserInfoApi.h"
//用户信息模型

#import "HCEaseUserInfo.h"

#import "EditNicknameViewController.h"
@implementation EMBuddy (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    NSLog(@"%@",[[UserProfileManager sharedInstance] getNickNameWithUsername:self.username]);
    NSLog(@"%@",self.username);
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.username];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate>
{
    NSIndexPath *_currentLongPressIndex;
    
    NSMutableArray *friendsArr;
    
}
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic, strong) NSMutableArray *imageNameArr;

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;
//用户信息数据
@property (strong, nonatomic) NSMutableArray *UserDataSource;

@property (strong, nonatomic) NSMutableDictionary *dict_mutab;
@property (strong, nonatomic) NSMutableDictionary *dict_mutab_nick;
@property (strong, nonatomic) HCEaseUserInfo *model_info;
@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    _dict_mutab = [NSMutableDictionary dictionary];
    _dict_mutab_nick = [NSMutableDictionary dictionary];
    self.UserDataSource = [NSMutableArray array];
    friendsArr = [[NSMutableArray alloc]init];
    _imageNameArr = [[NSMutableArray alloc]init];
    [self searchController];
    
    [self reloadDataSource];
    
    // 获取当前用户在Parse服务器上的好友数据（头像、昵称），储存到内存中或者本地沙盒中
    [[UserProfileManager sharedInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource saveToLoacal:YES completion:NULL];
    
    self.showRefreshFooter = NO;
    self.showRefreshHeader = NO;
    
    
    
    //好友search
    //    self.tableView.tableHeaderView = self.searchBar;
    [self tableViewDidTriggerHeaderRefresh];
    
    
    [self getMyFriends];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)getMyFriends
{
    MyFriendsApi *api = [[MyFriendsApi alloc]init];
    [api startRequest:^(HCRequestStatus requestStatus, NSString *message, id responseObject) {
        
        NSLog(@"%@",responseObject);
        friendsArr =responseObject[@"Data"][@"rows"];
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i< friendsArr.count; i++) {
            
            NSString *nickName = [friendsArr[i] objectForKey:@"nickName"];
            [arr addObject:nickName];
            
        }
        self.indexArray = [ChineseString IndexArray:arr];
        self.letterResultArr = [ChineseString LetterSortArray:arr];
        NSLog(@"%@",self.letterResultArr);
//        if (self.letterResultArr.count !=0 &&friendsArr.count !=0) {
//            
//            for (int i =0; i< self.letterResultArr.count; i++) {
//                
//                
//                NSArray *array = self.letterResultArr[i];
//                for (int k = 0; k<array.count; k++) {
//                    
//                    NSMutableArray *a = [[NSMutableArray alloc]init];
//                    for (int j=0; j<friendsArr.count; j++) {
//                        
//                        if ([array[k] isEqualToString:[friendsArr[j] objectForKey:@"nickName"]]) {
//                            
//                            [a addObject:friendsArr[i]];
//                        }
//                        
//                    }
//                    [_imageNameArr addObject:a];
//                }
//                
//            }
//            
//        }
        
        
        
        for (int i =0; i< self.letterResultArr.count; i++) {
            
            NSArray *arr = self.letterResultArr[i];
             NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int j = 0; j<arr.count; j++) {
                
                NSLog(@"%@",arr[j]);
                //[_imageNameArr addObject:arr[j]];
                
               
                for (int k = 0; k<friendsArr.count; k++) {
                    
                    NSString *nickName = [friendsArr[k]objectForKey:@"nickName"];
                    if ([nickName isEqualToString:arr[j]]) {
                        
                        NSLog(@"%@",nickName);
                        [array addObject:friendsArr[k]];
                    }
                    
                }
                
               
            }
             [_imageNameArr addObject:array];//
        }
        
        NSLog(@"------------%@",_imageNameArr);
        
    }];
    
    
}


#pragma mark - getter

- (NSArray *)rightItems
{
    if (_rightItems == nil)
    {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}


- (UISearchBar *)searchBar
{
    if (_searchBar == nil)
    {
        _searchBar = [[EMSearchBar alloc]  initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search ");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    return _searchBar;
}
//搜索
- (EMSearchDisplayController *)searchController
{
    __block NSDictionary *dict_all;
    __block NSMutableArray *arr = [NSMutableArray array];
    if (_searchController == nil)
    {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak ContactListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            ViewRadius(cell.imageView, 17);
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath)
         {
             return 50;
         }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath)
         {
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
             
             EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
             NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
             NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
             if (loginUsername && loginUsername.length > 0) {
                 if ([loginUsername isEqualToString:buddy.username])
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                     [alertView show];
                     return;
                 }
             }
             
             [weakSelf.searchController.searchBar endEditing:YES];
             ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:buddy.username
                                                                                 conversationType:eConversationTypeChat];
             //搜索结果的展示
             chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:dict_all[@"nickName"]];
             chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:arr[indexPath.row][@"nickName"]];
             
             chatVC.hidesBottomBarWhenPushed = YES;
             [weakSelf.navigationController pushViewController:chatVC animated:YES];
         }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count] +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    NSLog(@"%@",self.letterResultArr);
    
    return [[self.letterResultArr objectAtIndex:section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
        else if (indexPath.row == 1) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.group", @"Group");
            return cell;
        }
        
    }
    else{//下面分组的
        
        //        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        //        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
        //        model.avatarImage = [readUserInfo getReadDicMessage][model.buddy.username];
        //        model.nickname = [readUserInfo getReadDicMessageNickname][model.buddy.username];
        //        cell.model = model;
        //        cell.indexPath = indexPath;
        //        cell.delegate = self;
        
        //        cell.titleLabel.text = [friendsArr[indexPath.row] objectForKey:@"nickName"];
        //
        //        //[cell.avatarView.imageView sd_setImageWithURL:[friendsArr[indexPath.row] objectForKey:@"imageName"] placeholderImage:nil];
        //        [cell.avatarView.imageView sd_setImageWithURL:[readUserInfo url:[friendsArr[indexPath.row] objectForKey:@"imageName"]:kkUser]];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        //给self.view添加一个手势监测；
        
        [cell.avatarView addGestureRecognizer:singleRecognizer];
        
        cell.titleLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
        
        NSDictionary *imageArr = [[self.imageNameArr objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
        //  [cell.avatarView.imageView sd_setImageWithURL:[readUserInfo url:[friendsArr[indexPath.row] objectForKey:@"imageName"]:kkUser]];
        
        NSLog(@"%@--------哈哈哈哈哈哈哈哈%@",self.imageNameArr,self.letterResultArr)
        [cell.avatarView.imageView sd_setImageWithURL:[readUserInfo url:[imageArr objectForKey:@"imageName"] :kkUser]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    
    HCGradeManagerViewController *vc = [[HCGradeManagerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    //[label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    label.text = [self.indexArray objectAtIndex:section -1];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            [ApplyViewController shareController].hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
        }
        else if (row == 1)
        {
            if (_groupController == nil) {
                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            }
            else{
                [_groupController reloadDataSource];
            }
            _groupController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_groupController animated:YES];
        }
        else if (row == 2)
        {
            ChatroomListViewController *controller = [[ChatroomListViewController alloc] initWithStyle:UITableViewStylePlain];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (row == 3) {
            RobotListViewController *robot = [[RobotListViewController alloc] init];
            robot.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:robot animated:YES];
        }
    }
    else{
        // EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        NSDictionary *nameArr = [[self.imageNameArr objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            
            if (![loginUsername compare:[nameArr objectForKey:@"chatName"]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        
        NSString *name = [nameArr objectForKey:@"chatName"];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:name conversationType:eConversationTypeChat];
        chatController.title = name.length > 0 ? [nameArr objectForKey:@"nickName"] : name;
        chatController.hidesBottomBarWhenPushed = YES;
        
        
        
        //        NHCChatUserInfoApi *api = [[NHCChatUserInfoApi alloc]init];
        //        api.chatName = [model.buddy.username stringByReplacingOccurrencesOfString:@"cn" withString:@"CN"];
        //        [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSDictionary *dict) {
        //            UIImageView *image = [[UIImageView alloc]init];
        //            [image sd_setImageWithURL:[readUserInfo url:dict[@"imageName"] :kkUser]];
        //            chatController.imageUserPh = image.image;
        //        }];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([model.buddy.username isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:model.buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.buddy.username deleteMessages:YES append2Chat:YES];
            
            [tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView  endUpdates];
        }
        else{
            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.description]];
            [tableView reloadData];
        }
    }
}

#pragma mark - UISearchBarDelegate   搜索的代理方法

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}



#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - action
//添加联系人
- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    addController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private data
//私有数据
- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username])
        {
            //            //////////////////////////////////////////////////////////////这个地方是好友信息
            //            NHCChatUserInfoApi * api = [[NHCChatUserInfoApi alloc]init];
            //            api.chatName = [buddy.username stringByReplacingOccurrencesOfString:@"cn" withString:@"CN"];
            //            [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSDictionary *dict) {
            //
            //            }];
            
            [contactsSource addObject:buddy];
        }
    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (EMBuddy *buddy in contactsSource) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model) {
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username];
            NHCChatUserInfoApi * api = [[NHCChatUserInfoApi alloc]init];
            api.chatName = [model.buddy.username stringByReplacingOccurrencesOfString:@"cn" withString:@"CN"];
            [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSDictionary *dict) {
                model.nickname = dict[@"nickName"];
                UIImageView *image = [[UIImageView alloc]init];
                [image sd_setImageWithURL:[readUserInfo url:dict[@"imageName"] :kkUser]];
                model.avatarImage = image.image;
            }];
            
            
            
            //显示好友信息
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username]];
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - EaseUserCellDelegate

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        __weak typeof(self) weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncBlockBuddy:model.buddy.username relationship:eRelationshipFrom withCompletion:^(NSString *username, EMError *error){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideHud];
            if (!error)
            {
                //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            }
            else
            {
                [strongSelf showHint:error.description];
            }
        } onQueue:nil];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - data
//获取  数据

- (void)tableViewDidTriggerHeaderRefresh
{
    //    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak ContactListViewController *weakSelf = self;
    [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error == nil) {
                [self.contactsSource removeAllObjects];
                [self.contactsSource addObjectsFromArray:buddyList];
                NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
                NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
                if (loginUsername && loginUsername.length > 0) {
                    EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
                    [self.contactsSource addObject:loginBuddy];
                }
                [weakSelf _sortDataArray:self.contactsSource];
            }
            else{
                //[weakSelf showHint:NSLocalizedString(@"loadDataFailed", @"Load data failed.")];
            }
            
            [weakSelf tableViewDidFinishTriggerHeader:YES reload:YES];
        });
    } onQueue:nil];
}

#pragma mark - public
//获取数据
- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    //好友列表
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    //屏蔽名单
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    [self.UserDataSource removeAllObjects];
    _dict_mutab = [NSMutableDictionary dictionary];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username])
        {
            
            if (IsEmpty([readUserInfo getReadDicMessage])) {
                
                NHCChatUserInfoApi * api = [[NHCChatUserInfoApi alloc]init];
                api.chatName = [buddy.username stringByReplacingOccurrencesOfString:@"cn" withString:@"CN"];
                [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSDictionary *dict) {
                    HCEaseUserInfo * model= [[HCEaseUserInfo alloc]init];
                    model.nickName = dict[@"nickName"];
                    model.userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[readUserInfo url:dict[@"imageName"] :kkUser]]];
                    if (IsEmpty(model.userImage)) {
                        model.userImage = IMG(@"1");
                    }
                    //头像
                    [_dict_mutab setObject:model.userImage forKey:buddy.username];
                    [readUserInfo DicdeleteMessage];
                    [readUserInfo creatDicMessage:_dict_mutab];
                    //昵称
                    [_dict_mutab_nick setObject:model.nickName forKey:buddy.username];
                    [readUserInfo DicdeleteMessageNickname];
                    [readUserInfo creatDicMessageNickname:_dict_mutab_nick];
                    [self.UserDataSource addObject:model];
                }];
            }else{
                NSDictionary * dict_nickname= [readUserInfo getReadDicMessageNickname];
                NSDictionary * dict_image= [readUserInfo getReadDicMessage];
                NSLog(@"%@",dict_nickname.allKeys);
                NSLog(@"%@",dict_nickname.allValues);
                
                NSArray *arr = dict_nickname.allKeys;
                if ([arr containsObject:buddy.username]) {
                    NSLog(@"被包含了");
                }else{
                    NHCChatUserInfoApi * api = [[NHCChatUserInfoApi alloc]init];
                    api.chatName = [buddy.username stringByReplacingOccurrencesOfString:@"cn" withString:@"CN"];
                    [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSDictionary *dict) {
                        HCEaseUserInfo * model= [[HCEaseUserInfo alloc]init];
                        model.nickName = dict[@"nickName"];
                        model.userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[readUserInfo url:dict[@"imageName"] :kkUser]]];
                        if (IsEmpty(model.userImage)) {
                            model.userImage = IMG(@"1");
                        }
                        //头像
                        _dict_mutab = [NSMutableDictionary dictionaryWithDictionary:dict_image];
                        [_dict_mutab setObject:model.userImage forKey:buddy.username];
                        [readUserInfo DicdeleteMessageNickname];
                        [readUserInfo DicdeleteMessage];
                        [readUserInfo creatDicMessage:_dict_mutab];
                        //昵称
                        _dict_mutab_nick = [NSMutableDictionary dictionaryWithDictionary:dict_nickname];
                        [_dict_mutab_nick setObject:model.nickName forKey:buddy.username];
                        [readUserInfo creatDicMessageNickname:_dict_mutab_nick];
                        [self.UserDataSource addObject:model];
                    }];
                }
                
                
                
                
            }
            
            [self.contactsSource addObject:buddy];
        }
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [self.contactsSource addObject:loginBuddy];
    }
    [self _sortDataArray:self.contactsSource];
    [self.tableView reloadData];
    
}
//加载申请视图
- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}
//加载群组
- (void)reloadGroupView
{
    [self reloadApplyView];
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}
//添加好友
- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    addController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - EMChatManagerBuddyDelegate
- (void)didUpdateBlockedList:(NSArray *)blockedList
{
    [self reloadDataSource];
    
}

@end
