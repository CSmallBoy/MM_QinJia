//
//  SCSwipeTableViewCell.m
//  SCSwipeTableViewCell
//
//  Created by Sunc on 15/12/17.
//  Copyright © 2015年 Sunc. All rights reserved.
//

#import "SCSwipeTableViewCell.h"

#define SC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface SCSwipeTableViewCell()<UIGestureRecognizerDelegate>{
    UITapGestureRecognizer *tap;
}

@property (nonatomic, retain)UIView  *cellContentView;
@property (nonatomic, retain)UIPanGestureRecognizer *panGersture;
@property (nonatomic, assign)CGFloat judgeWidth;
@property (nonatomic, assign)CGFloat rightfinalWidth;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign,readwrite)BOOL isRightBtnShow;
@property (nonatomic, assign)BOOL otherCellIsOpen;
@property (nonatomic, assign)BOOL isHiding;
@property (nonatomic, assign)BOOL isShowing;
@end

@implementation SCSwipeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     withBtns:(NSArray *)arr
          tableView:(UITableView *)tableView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightBtnArr = [NSArray arrayWithArray:arr];
        self.superTableView = tableView;
        [self prepareForCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//set default select style
    }
    return self;
}

- (void)prepareForCell{
    [self setBtns];
    [self setScrollView];
    [self addObserverEvent];
    [self addGesture];
    [self addNotify];
    [_SCContentView addSubview:[self makeUICell]];
}
#pragma mark prepareForReuser
- (void)prepareForReuse
{
    [self hideBtn];
    [super prepareForReuse];
}

#pragma mark initCell

- (void)setBtns{
    if (_rightBtnArr.count>0) {
        [self processBtns];
    }
    else{
        return;
    }
}
//cell 上的子视图
- (UIView*)makeUICell{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 49, 49)];
    image.image = IMG(@"1");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"已同意" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(SCREEN_WIDTH *0.7 -180, 12.5, SCREEN_WIDTH, 30)];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 12.5, SCREEN_WIDTH*0.3, 30)];
    label.text = @"家庭名字";
    [view addSubview:label];
    [view addSubview:image];
    [view addSubview:button];
    
    
    return view;
}
- (void)buttonClick1:(UIButton*)button{
    NSIndexPath *indexPath = [_superTableView indexPathForCell:(UITableViewCell*)button.superview.superview.superview.superview];
   
    

    [self makeAlertView];
    
    
    
    NSLog(@"触发 button %ld ",indexPath.row);
}
//创建弹出的view视图
- (UIView *)makeAlertView{
    
    UIView *view_grond = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.15, SCREEN_HEIGHT *0.3, SCREEN_WIDTH *0.7, 120)];
   // view_grond.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view_grond.bounds.size.width, 30)];
    label.text = @"请选择与管理员的关系";
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, view_grond.bounds.size.width-30, 30)];
    label2.layer.borderWidth = 1.0;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(label2.bounds.size.width-15, 0, 15, 30)];
    [button setBackgroundColor:[UIColor redColor]];
    for (int i = 0 ; i < 2; i ++) {
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setFrame:CGRectMake(15+140*i, 80, 100, 30)];
        [button2 setBackgroundColor:[UIColor orangeColor]];
        [view_grond addSubview:button2];
    }
    [label2 addSubview:button];
    [view_grond addSubview:label2];
    [view_grond addSubview:label];
    
    UIView *view_all = [[UIView alloc]initWithFrame:self.superview.bounds];
    view_all.backgroundColor = [UIColor grayColor];
    //view_all.alpha = 0.8;
    [view_all addSubview:view_grond];
    view_all.userInteractionEnabled = NO;
    [self.superview.superview addSubview:view_all];
    return view_grond;
}
- (void)processBtns{
    CGFloat lastWidth = 0;
    int i = 0;
    NSIndexPath *indexPath = [_superTableView indexPathForCell:self];
     self.cellHeight = [_superTableView rectForRowAtIndexPath:indexPath].size.height;
    
    for (UIButton *temBtn in _rightBtnArr)
    {
        temBtn.tag = i;
        CGRect temRect = temBtn.frame;
        temRect.origin.x = SC_SCREEN_WIDTH - temRect.size.width - lastWidth;
        temBtn.frame = temRect;
        lastWidth = lastWidth + temBtn.frame.size.width;
        if (!_judgeWidth) {
            _judgeWidth = lastWidth;
        }
        if (_cellHeight != temBtn.frame.size.height) {
            CGRect frame = temBtn.frame;
            frame.size.height = _cellHeight;
            temBtn.frame = frame;
        }
        [temBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:temBtn];
        i++;

    }
    _rightfinalWidth = lastWidth;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setScrollView{
    _SCContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SC_SCREEN_WIDTH, _cellHeight)];
    _SCContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_SCContentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_isRightBtnShow) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
    }
    else{
        [self hideBtn];
    }
}

#pragma mark events,gesture and observe

- (void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotify:)
                                                 name:@"SC_CELL_SHOULDCLOSE"
                                               object:nil];
}

- (void)handleNotify:(NSNotification *)notify{
    if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"closeCell"]) {
        [self hideBtn];
        _otherCellIsOpen = NO;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsOpen"]){
        _otherCellIsOpen = YES;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsClose"])
    {
        _otherCellIsOpen = NO;
    }
}

- (void)addObserverEvent{
    [_superTableView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldpoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newpoint = [[change objectForKey:@"new"] CGPointValue];
        if (oldpoint.y!=newpoint.y) {
            NSLog(@"---sueperTabelViewMoves---");
            if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
                [self hideBtn];
            }
        }
    }
}
//添加手势
- (void)addGesture{
    _panGersture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    _panGersture.delegate = self;
    [self.SCContentView addGestureRecognizer:_panGersture];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.SCContentView addGestureRecognizer:tap];

}
//tap手势方法
-(void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"%lf",_SCContentView.frame.origin.x );
    if (_SCContentView.frame.origin.x == -180)
    {
        
        [self hideBtn];
        
    }
    else
    {
        //跳转 传值
        NSLog(@"跳转");
    }
    
}
- (void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    if (_isShowing||_isHiding) {
        return;
    }
    CGPoint translation = [_panGersture translationInView:self];
    CGPoint location = [_panGersture locationInView:self];
    NSLog(@"translation----(%f)----loaction(%f)",translation.x,location.y);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if (fabs(translation.x)<fabs(translation.y)) {
                _superTableView.scrollEnabled = YES;
                return;
            }else{
                _superTableView.scrollEnabled = NO;
            }
            if (_otherCellIsOpen&&!(_SCContentView.frame.origin.x == -_judgeWidth)) {
                return;
            }
            //contentoffse changed
            if (translation.x<0) {
                //SCContentView is moving towards left
                if (_SCContentView.frame.origin.x == -_judgeWidth) {
                    //close cell
                    [self hideBtn];
                }
                else if (_SCContentView.frame.origin.x > -_judgeWidth){
                    //open cell
                    [self moveSCContentView:translation.x];
                }
            }
            else if (translation.x>0){
                //SCContentView is moving towards right
                [self hideBtn];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _superTableView.scrollEnabled = YES;
            if (_otherCellIsOpen&&!(_SCContentView.frame.origin.x == -_judgeWidth)) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
                return;
            }
            //end pan
            [self SCContentViewStop];
            break;
            
        case UIGestureRecognizerStateCancelled:
            _superTableView.scrollEnabled = YES;
            //cancell
            [self SCContentViewStop];
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)moveSCContentView:(CGFloat)offset{
    CGRect temRect = _SCContentView.frame;
    temRect.origin.x = (temRect.origin.x + offset);//adjust touch offset with your finger movement
    if (temRect.origin.x+(SC_SCREEN_WIDTH)/2.0<0) {
        temRect.origin.x = -SC_SCREEN_WIDTH/2.0;
    }
    if (temRect.origin.x>SC_SCREEN_WIDTH/2.0) {
        temRect.origin.x = SC_SCREEN_WIDTH/2.0;
    }
    _SCContentView.frame = temRect;
}

- (void)SCContentViewStop{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        //btn is shown
        if (_SCContentView.frame.origin.x + _judgeWidth<0) {
            [self showBtn];
        }
        else
        {
            [self hideBtn];
        }
    }
    else{
        if (_SCContentView.frame.origin.x+10>0) {
            [self hideBtn];
        }
        else{
            [self showBtn];
        }
    }
}

#pragma mark showBtn hideBtn

- (void)showBtn{
    if (!(_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isShowing) {
            [self cellWillShow];
            _isShowing = YES;
        }
    }
    _superTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = -_rightfinalWidth;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (!_isRightBtnShow) {
            [self cellDidShow];
            _isShowing = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsOpen"}];
        _superTableView.scrollEnabled = YES;
    }];
}

- (void)hideBtn{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = 0;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (_isRightBtnShow) {
            [self cellDidHide];
            _isHiding = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsClose"}];
        _superTableView.userInteractionEnabled = YES;
    }];
}

#pragma delegate

- (void)cellWillHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillHide)]) {
        [_delegate cellOptionBtnWillHide];
    }
}

- (void)cellWillShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillShow)]) {
        [_delegate cellOptionBtnWillShow];
    }
}

- (void)cellDidShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidShow)]) {
        [_delegate cellOptionBtnDidShow];
    }
}

- (void)cellDidHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidHide)]) {
        [_delegate cellOptionBtnDidHide];
    }
}

- (void)cellBtnClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    if ([_delegate respondsToSelector:@selector(SCSwipeTableViewCelldidSelectBtnWithTag:andIndexPath:)]) {
        [_delegate SCSwipeTableViewCelldidSelectBtnWithTag:sender.tag andIndexPath:indexPath];
    }
    [self hideBtn];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dealloc{
    [_superTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SC_CELL_SHOULDCLOSE" object:nil];
}
@end
