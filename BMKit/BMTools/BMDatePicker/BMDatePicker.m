//
//  BMDatePicker.m
//  BMDatePicker
//
//  Created by DennisDeng on 2017/8/24.
//  Copyright © 2017年 DennisDeng. All rights reserved.
//

#import "BMDatePicker.h"
#import "NSDate+BMCategory.h"
#import "UIView+BMSize.h"

#define Picker_MaxYear     2099
#define Picker_MinYear     1

@interface BMDatePicker ()
<
    UIPickerViewDelegate,
    UIPickerViewDataSource
>
{
    // 日期数据存储
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_chineseMonthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;

    // 性别数据
    NSMutableArray *_sexArray;

    // 记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;

    NSInteger sexIndex;

    NSInteger preIndex;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UILabel *formateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;


@property (nonatomic, strong) NSMutableArray *pickerLabelArray;

@property (nonatomic, strong) NSDate *pickerDate;
@property (nonatomic, strong) NSString *formatDate;

@property (nonatomic, strong) NSString *pickerSex;


- (IBAction)doneClick:(id)sender;

@end


@implementation BMDatePicker

- (instancetype)initWithPickerStyle:(BMPickerStyle)pickerStyle completeBlock:(BMDatePickerDoneBlock)completeBlock
{
    if (pickerStyle == PickerStyle_Sex)
    {
        return [self initWithPickerSex:nil completeBlock:completeBlock];
    }
    else
    {
        return [self initWithPickerStyle:pickerStyle scrollToDate:[NSDate date] completeBlock:completeBlock];
    }
}

- (instancetype)initWithPickerSex:(NSString *)sex completeBlock:(BMDatePickerDoneBlock)completeBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    self.pickerStyle = PickerStyle_Sex;
    self.completeBlock = completeBlock;
    
    [self defaultConfig];
    
    [self setupUI];
    
    [self scrollToSex:sex animated:YES];
    
    return self;
}

- (instancetype)initWithPickerStyle:(BMPickerStyle)pickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(BMDatePickerDoneBlock)completeBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];

    self.pickerStyle = pickerStyle;
    self.completeBlock = completeBlock;
    
    if (!scrollToDate)
    {
        scrollToDate = [NSDate date];
    }
    
    [self defaultConfig];
    
    [self setupUI];
    
    [self scrollToDate:scrollToDate animated:YES];
    
    return self;
}

- (void)defaultConfig
{
    // 设置年月日时分数据
    _yearArray = [[NSMutableArray alloc] initWithCapacity:0];
    _monthArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dayArray = [[NSMutableArray alloc] initWithCapacity:0];
    _hourArray = [[NSMutableArray alloc] initWithCapacity:0];
    _minuteArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _chineseMonthArray = [[NSMutableArray alloc] initWithArray:@[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"]];
    
    _sexArray = [[NSMutableArray alloc] initWithArray:@[@"男", @"女"]];

    _showDoneBtn = YES;
    
    for (NSInteger i=0; i<60; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%02ld", (long)i];
        
        if (0<i && i<=12)
        {
            [_monthArray addObject:num];
        }
        if (i<24)
        {
            [_hourArray addObject:num];
        }
        [_minuteArray addObject:num];
    }
    
    for (NSInteger i=Picker_MinYear; i<=Picker_MaxYear; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%ld", (long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    self.maxLimitDate = [NSDate bm_dateFromString:@"2099-12-31 23:59" withFormat:@"yyyy-MM-dd HH:mm"];
    //最小限制
    self.minLimitDate = [NSDate bm_dateFromString:@"0001-01-01 00:00" withFormat:@"yyyy-MM-dd HH:mm"];
}

- (void)setupUI
{
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    self.picker.backgroundColor = [UIColor clearColor];
    //self.picker.hidden = YES;
    
    self.bm_width = UI_SCREEN_WIDTH - 20;
    self.backgroundColor = [UIColor whiteColor];
    
    self.formateColor = RGBColor(233, 233, 233, 0.8);
    
    self.yearColor = RGBColor(233, 233, 233, 0.8);
    
    self.pickerLabelColor = RGBColor(247, 133, 51, 1);
    self.pickerItemColor = [UIColor blackColor];
    self.pickerCurrentItemColor = [UIColor blueColor];
    
    self.doneBtn.layer.cornerRadius = 10;
    self.doneBtn.layer.masksToBounds = YES;
    
    self.doneBtnBgColor = RGBColor(247, 133, 51, 1);
    self.doneBtnTextColor = [UIColor whiteColor];

    _showChineseMonth = NO;
    
    _showYearLabel = YES;
    _showFormateLabel = YES;
    
    //[self.picker reloadAllComponents];
}


#pragma mark -
#pragma mark setter

- (void)setPickerStyle:(BMPickerStyle)pickerStyle
{
    _pickerStyle = pickerStyle;
    
    // 不设置nil
    self.pickerLabelTitleArray = @[];
    
    if (!self.formate)
    {
        switch (pickerStyle)
        {
            case PickerStyle_YearMonthDayHourMinute:
                self.formate = @"MM-dd HH:mm";
                break;
            case PickerStyle_MonthDayHourMinute:
                self.formate = @"MM-dd HH:mm";
                break;
            case PickerStyle_Year:
                self.formate = @"yyyy";
                break;
            case PickerStyle_YearMonthDay:
                self.formate = @"yyyy-MM-dd";
                break;
            case PickerStyle_MonthDayYear:
                self.formate = @"MM-dd-yyyy";
                break;
            case PickerStyle_MonthDay:
                self.formate = @"MM-dd";
                break;
            case PickerStyle_HourMinute:
                self.formate = @"HH:mm";
                break;
                
            default:
                self.formate = @"yyyy-MM-dd HH:mm";
                break;
        }
    }
}

- (void)setShowFormateLabel:(BOOL)showFormateLabel
{
    _showFormateLabel = showFormateLabel;
    
    self.formateLabel.hidden = !showFormateLabel;
}

- (void)setFormateColor:(UIColor *)formateColor
{
    _formateColor = formateColor;
    self.formateLabel.textColor = formateColor;
}

- (void)setFormate:(NSString *)formate
{
    if (!formate)
    {
        switch (self.pickerStyle)
        {
            case PickerStyle_YearMonthDayHourMinute:
                //_formate = @"yyyy-MM-dd HH:mm";
                formate = @"MM-dd HH:mm";
                break;
            case PickerStyle_MonthDayHourMinute:
                formate = @"yyyy-MM-dd HH:mm";
                break;
            case PickerStyle_Year:
                formate = @"yyyy";
                break;
            case PickerStyle_YearMonthDay:
                formate = @"yyyy-MM-dd";
                break;
            case PickerStyle_MonthDayYear:
                self.formate = @"MM-dd-yyyy";
                break;
            case PickerStyle_MonthDay:
                formate = @"MM-dd";
                break;
            case PickerStyle_HourMinute:
                formate = @"HH:mm";
                break;
                
            default:
                formate = @"yyyy-MM-dd HH:mm";
                break;
        }
    }
    
    _formate = formate;
    
    if (self.pickerDate)
    {
        self.formateLabel.text = [NSDate bm_stringFromDate:self.pickerDate formatter:formate];
    }
}

- (void)setShowYearLabel:(BOOL)showYearLabel
{
    _showYearLabel = showYearLabel;
    
    self.yearLabel.hidden = !showYearLabel;
}

- (void)setYearColor:(UIColor *)yearColor
{
    _yearColor = yearColor;
    self.yearLabel.textColor = yearColor;
}

- (void)setPickerLabelColor:(UIColor *)pickerLabelColor
{
    _pickerLabelColor = pickerLabelColor;
    
    for (UILabel *label in self.pickerLabelArray)
    {
        label.textColor = pickerLabelColor;
    }
}

- (void)setPickerLabelTitleArray:(NSArray *)titleArray
{
    _pickerLabelTitleArray = titleArray;
    
    if (titleArray == nil)
    {
        return;
    }
    
    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            if (titleArray.count == 5)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"年",@"月",@"日",@"时",@"分"];
            }
            break;
        case PickerStyle_MonthDayHourMinute:
            if (titleArray.count == 4)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"月",@"日",@"时",@"分"];
            }
            break;
        case PickerStyle_Year:
            if (titleArray.count == 1)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"年"];
            }
            break;
        case PickerStyle_YearMonthDay:
            if (titleArray.count == 3)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"年",@"月",@"日"];
            }
            break;
        case PickerStyle_MonthDayYear:
            if (titleArray.count == 3)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"月",@"日",@"年"];
            }
            break;
        case PickerStyle_MonthDay:
            if (titleArray.count == 2)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"月",@"日"];
            }
            break;
        case PickerStyle_HourMinute:
            if (titleArray.count == 2)
            {
                return;
            }
            else
            {
                _pickerLabelTitleArray = @[@"时",@"分"];
            }
            break;
        default:
            return;
    }
}

- (void)setPickerItemColor:(UIColor *)pickerItemColor
{
    _pickerItemColor = pickerItemColor;
    
    [self.picker reloadAllComponents];
}

- (void)setPickerCurrentItemColor:(UIColor *)pickerCurrentItemColor
{
    _pickerCurrentItemColor = pickerCurrentItemColor;
    
    [self.picker reloadAllComponents];
}

- (void)setShowDoneBtn:(BOOL)showDoneBtn
{
    if (_showDoneBtn == showDoneBtn)
    {
        return;
    }
    
    _showDoneBtn = showDoneBtn;
    
    if (_showDoneBtn)
    {
        self.pickerBgView.bm_height = 210.0f;
    }
    else
    {
        self.pickerBgView.bm_height = 260.0f;
    }
    
    self.doneBtn.hidden = !_showDoneBtn;
}

- (void)setDoneBtnBgColor:(UIColor *)doneBtnBgColor
{
    _doneBtnBgColor = doneBtnBgColor;
    self.doneBtn.backgroundColor = doneBtnBgColor;
}

- (void)setDoneBtnTextColor:(UIColor *)doneBtnTextColor
{
    _doneBtnTextColor = doneBtnTextColor;
    [self.doneBtn setTitleColor:doneBtnTextColor forState:UIControlStateNormal];
}

- (void)setShowChineseMonth:(BOOL)showChineseMonth
{
    _showChineseMonth = showChineseMonth;
    
    [self.picker reloadAllComponents];
}

- (void)setMaxLimitDate:(NSDate *)maxLimitDate
{
    NSDate *date = [NSDate bm_dateFromString:@"2099-12-31 23:59" withFormat:@"yyyy-MM-dd HH:mm"];
    if ([maxLimitDate bm_isLaterThanDate:date])
    {
        _maxLimitDate = date;
    }
    else if ([maxLimitDate bm_isEarlierThanDate:self.minLimitDate])
    {
        _maxLimitDate = self.minLimitDate;
    }
    else
    {
        _maxLimitDate = maxLimitDate;
    }
}

- (void)setMinLimitDate:(NSDate *)minLimitDate
{
    NSDate *date = [NSDate bm_dateFromString:@"0001-01-01 00:00" withFormat:@"yyyy-MM-dd HH:mm"];
    
    if ([minLimitDate bm_isEarlierThanDate:date])
    {
        _minLimitDate = date;
    }
    else if ([minLimitDate bm_isLaterThanDate:self.maxLimitDate])
    {
        _minLimitDate = self.maxLimitDate;
    }
    else
    {
        _minLimitDate = minLimitDate;
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    [self addPickLabelWithNames:self.pickerLabelTitleArray];

    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            //[self addPickLabelWithNames:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case PickerStyle_MonthDayHourMinute:
            //[self addPickLabelWithNames:@[@"月",@"日",@"时",@"分"]];
            return 4;
        case PickerStyle_Year:
            //[self addPickLabelWithNames:@[@"年"]];
            return 1;
        case PickerStyle_YearMonthDay:
            //[self addPickLabelWithNames:@[@"年",@"月",@"日"]];
            return 3;
        case PickerStyle_MonthDayYear:
            return 3;
        case PickerStyle_MonthDay:
            //[self addPickLabelWithNames:@[@"月",@"日"]];
            return 2;
        case PickerStyle_HourMinute:
            //[self addPickLabelWithNames:@[@"时",@"分"]];
            return 2;
        case PickerStyle_Sex:
            return 1;
        default:
            return 0;
    }
}

- (void)addPickLabelWithNames:(NSArray *)nameArray
{
    for (UIView *subView in self.picker.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        CGFloat labelX = self.picker.bm_width/(nameArray.count*2)+18+self.picker.bm_width/nameArray.count*i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, (self.picker.bm_height-16)*0.5, 16, 16)];
        label.text = nameArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  self.pickerLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.picker addSubview:label];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *numberArray = [self getNumberOfRowsInComponent];
    return [numberArray[component] integerValue];
}

- (NSArray *)getNumberOfRowsInComponent
{
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = Picker_MaxYear - Picker_MinYear;
    
    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            return @[@(yearNum), @(monthNum), @(dayNum), @(hourNum), @(minuteNUm)];
        case PickerStyle_MonthDayHourMinute:
            return @[@(monthNum*timeInterval), @(dayNum), @(hourNum), @(minuteNUm)];
        case PickerStyle_Year:
            return @[@(yearNum)];
        case PickerStyle_YearMonthDay:
            return @[@(yearNum), @(monthNum), @(dayNum)];
        case PickerStyle_MonthDayYear:
            return @[@(monthNum), @(dayNum), @(yearNum)];
        case PickerStyle_MonthDay:
            return @[@(monthNum*timeInterval), @(dayNum), @(hourNum)];
        case PickerStyle_HourMinute:
            return @[@(hourNum), @(minuteNUm)];
        case PickerStyle_Sex:
            return @[@(2)];
        default:
            return @[];
    }
}


#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel)
    {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    
    BOOL selected = NO;
    
    NSString *title = @"";
    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            switch (component)
            {
                case 0:
                    title = _yearArray[row];
                    if (row == yearIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 1:
                    if (self.showChineseMonth)
                    {
                        title = _chineseMonthArray[row];
                    }
                    else
                    {
                        title = _monthArray[row];
                    }
                    if (row == monthIndex)
                    {
                        selected = YES;
                    }
                break;
                case 2:
                    title = _dayArray[row];
                    if (row == dayIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 3:
                    title = _hourArray[row];
                    if (row == hourIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 4:
                    title = _minuteArray[row];
                    if (row == minuteIndex)
                    {
                        selected = YES;
                    }
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_Year:
            switch (component)
        {
            case 0:
                title = _yearArray[row];
                if (row == yearIndex)
                {
                    selected = YES;
                }
                break;
            default:
                break;
        }
            break;
        case PickerStyle_YearMonthDay:
            switch (component)
            {
                case 0:
                    title = _yearArray[row];
                    if (row == yearIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 1:
                    if (self.showChineseMonth)
                    {
                        title = _chineseMonthArray[row];
                    }
                    else
                    {
                        title = _monthArray[row];
                    }
                    if (row == monthIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 2:
                    title = _dayArray[row];
                    if (row == dayIndex)
                    {
                        selected = YES;
                    }
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_MonthDayYear:
            switch (component)
        {
            case 0:
                if (self.showChineseMonth)
                {
                    title = _chineseMonthArray[row];
                }
                else
                {
                    title = _monthArray[row];
                }
                if (row == monthIndex)
                {
                    selected = YES;
                }
                break;
            case 1:
                title = _dayArray[row];
                if (row == dayIndex)
                {
                    selected = YES;
                }
                break;
            case 2:
                title = _yearArray[row];
                if (row == yearIndex)
                {
                    selected = YES;
                }
                break;
            default:
                break;
        }
            break;
        case PickerStyle_MonthDayHourMinute:
            switch (component)
            {
                case 0:
                    if (self.showChineseMonth)
                    {
                        title = _chineseMonthArray[row%12];
                    }
                    else
                    {
                        title = _monthArray[row%12];
                    }
                    if (row%12 == monthIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 1:
                    title = _dayArray[row];
                    if (row == dayIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 2:
                    title = _hourArray[row];
                    if (row == hourIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 3:
                    title = _minuteArray[row];
                    if (row == minuteIndex)
                    {
                        selected = YES;
                    }
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_MonthDay:
            switch (component)
            {
                case 0:
                    if (self.showChineseMonth)
                    {
                        title = _chineseMonthArray[row%12];
                    }
                    else
                    {
                        title = _monthArray[row%12];
                    }
                    if (row%12 == monthIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 1:
                    title = _dayArray[row];
                    if (row == dayIndex)
                    {
                        selected = YES;
                    }
                    break;
                 default:
                    break;
            }
            break;
        case PickerStyle_HourMinute:
            switch (component)
            {
                case 0:
                    title = _hourArray[row];
                    if (row == hourIndex)
                    {
                        selected = YES;
                    }
                    break;
                case 1:
                    title = _minuteArray[row];
                    if (row == minuteIndex)
                    {
                        selected = YES;
                    }
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_Sex:
            title = _sexArray[row];
            if (row == sexIndex)
            {
                selected = YES;
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    if (selected)
    {
        customLabel.textColor = self.pickerCurrentItemColor;
    }
    else
    {
        customLabel.textColor = self.pickerItemColor;
    }
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            switch (component)
            {
                case 0:
                    yearIndex = row;
                    self.yearLabel.text =_yearArray[yearIndex];
                    
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 1:
                    monthIndex = row;
                    
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 2:
                    dayIndex = row;
                    break;
                case 3:
                    hourIndex = row;
                    break;
                case 4:
                    minuteIndex = row;
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_Year:
            switch (component)
        {
            case 0:
                yearIndex = row;
                self.yearLabel.text =_yearArray[yearIndex];
                break;
            default:
                break;
        }
            break;
        case PickerStyle_YearMonthDay:
            switch (component)
            {
                case 0:
                    yearIndex = row;
                    self.yearLabel.text =_yearArray[yearIndex];
                    
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 1:
                    monthIndex = row;
                    
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 2:
                    dayIndex = row;
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_MonthDayYear:
            switch (component)
        {
            case 0:
                monthIndex = row;
                
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (dayIndex >= _dayArray.count)
                {
                    dayIndex = _dayArray.count-1;
                }
                break;
            case 1:
                dayIndex = row;
                break;
            case 2:
                yearIndex = row;
                self.yearLabel.text =_yearArray[yearIndex];
                
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (dayIndex >= _dayArray.count)
                {
                    dayIndex = _dayArray.count-1;
                }
                break;
            default:
                break;
        }
            break;
        case PickerStyle_MonthDayHourMinute:
            switch (component)
            {
                case 0:
                    monthIndex = row;
                    
                    [self yearChange:row];
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 1:
                    dayIndex = row;
                    break;
                case 2:
                    hourIndex = row;
                    break;
                case 3:
                    minuteIndex = row;
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_MonthDay:
            switch (component)
            {
                case 0:
                    monthIndex = row;
                    
                    [self yearChange:row];
                    [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                    if (dayIndex >= _dayArray.count)
                    {
                        dayIndex = _dayArray.count-1;
                    }
                    break;
                case 1:
                    dayIndex = row;
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_HourMinute:
            switch (component)
            {
                case 0:
                    hourIndex = row;
                    break;
                case 1:
                    minuteIndex = row;
                    break;
                default:
                    break;
            }
            break;
        case PickerStyle_Sex:
            sexIndex = row;
            break;
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    if (self.pickerStyle == PickerStyle_Sex)
    {
        self.pickerSex = _sexArray[sexIndex];
        if (self.completeBlock)
        {
            self.completeBlock(self.pickerSex, NO);
        }
        
        return;
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", _yearArray[yearIndex], _monthArray[monthIndex], _dayArray[dayIndex], _hourArray[hourIndex], _minuteArray[minuteIndex]];

    self.pickerDate = [NSDate bm_dateFromString:dateStr withFormat:@"yyyy-MM-dd HH:mm"];
    
    self.formateLabel.text = [NSDate bm_stringFromDate:self.pickerDate formatter:self.formate];
    self.formatDate = self.formateLabel.text;
    
    if (self.completeBlock)
    {
        self.completeBlock(self.pickerDate, NO);
    }

    if ([self.pickerDate compare:self.minLimitDate] == NSOrderedAscending)
    {
        self.pickerDate = self.minLimitDate;
        [self scrollToDate:self.minLimitDate animated:YES];
    }
    else if ([self.pickerDate compare:self.maxLimitDate] == NSOrderedDescending)
    {
        self.pickerDate = self.maxLimitDate;
        [self scrollToDate:self.maxLimitDate animated:YES];
    }
}

- (void)yearChange:(NSInteger)row
{
    monthIndex = row % 12;
    
    //年份状态变化
    if (row-preIndex < 12 && row-preIndex>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preIndex%12] integerValue])
    {
        yearIndex++;
    }
    else if(preIndex-row < 12 && preIndex-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preIndex%12] integerValue])
    {
        yearIndex--;
    }
    else
    {
        NSInteger interval = (row-preIndex)/12;
        yearIndex += interval;
    }
    
    self.yearLabel.text = _yearArray[yearIndex];
    
    preIndex = row;
}


#pragma mark - tools

// 通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0 ? YES:NO):YES):NO;
    switch (num_month)
    {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
        {
            [self buildDayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:
        {
            [self buildDayArray:30];
            return 30;
        }
        case 2:
        {
            if (isrunNian)
            {
                [self buildDayArray:29];
                return 29;
            }
            else
            {
                [self buildDayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

// 设置每月的天数数组
- (void)buildDayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    
    for (NSInteger i=1; i<=num; i++)
    {
        [_dayArray addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
}

- (IBAction)doneClick:(id)sender
{
    if (self.completeBlock)
    {
        if (self.pickerStyle == PickerStyle_Sex)
        {
            self.completeBlock(self.pickerSex, YES);
        }
        else
        {
            self.completeBlock(self.pickerDate, YES);
        }
    }
}

// 滚动到指定的时间位置
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date)
    {
        date = [NSDate date];
    }
    
    self.pickerDate = date;

    [self DaysfromYear:date.bm_year andMonth:date.bm_month];
    
    yearIndex = date.bm_year-Picker_MinYear;
    monthIndex = date.bm_month-1;
    dayIndex = date.bm_day-1;
    hourIndex = date.bm_hour;
    minuteIndex = date.bm_minute;
    
    // 循环滚动时需要用到
    preIndex = (date.bm_year-Picker_MinYear)*12+date.bm_month-1;
    
    NSArray *indexArray = nil;
    switch (self.pickerStyle)
    {
        case PickerStyle_YearMonthDayHourMinute:
            indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        case PickerStyle_MonthDayHourMinute:
            indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        case PickerStyle_Year:
            indexArray = @[@(yearIndex)];
            break;
        case PickerStyle_YearMonthDay:
            indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
            break;
        case PickerStyle_MonthDayYear:
            indexArray = @[@(monthIndex),@(dayIndex),@(yearIndex)];
            break;
        case PickerStyle_MonthDay:
            indexArray = @[@(monthIndex),@(dayIndex)];
            break;
        case PickerStyle_HourMinute:
            indexArray = @[@(hourIndex),@(minuteIndex)];
            break;
        default:
            break;
    }
    
    self.formateLabel.text = [NSDate bm_stringFromDate:date formatter:self.formate];
    self.yearLabel.text = _yearArray[yearIndex];

    [self.picker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++)
    {
        if ((self.pickerStyle == PickerStyle_MonthDayHourMinute || self.pickerStyle == PickerStyle_MonthDay) && i==0)
        {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(date.bm_year - Picker_MinYear));
            [self.picker selectRow:mIndex inComponent:i animated:animated];
        }
        else
        {
            [self.picker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
}

- (void)scrollToSex:(NSString *)sex animated:(BOOL)animated
{
    if (!sex)
    {
        sex = @"男";
    }
    
    self.pickerSex = sex;

    sexIndex = [_sexArray indexOfObject:sex];
    [self.picker selectRow:sexIndex inComponent:0 animated:animated];
}

@end
