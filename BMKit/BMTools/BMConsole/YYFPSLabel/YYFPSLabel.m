//
//  YYFPSLabel.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#if USE_TEST_HELP

#import "YYFPSLabel.h"
//#import "YYWeakProxy.h"
#import <mach/mach.h>


#define kSize CGSizeMake(55, 20)

@implementation YYFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.type = YYFPSLabelType_FPS;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    //self.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    //_link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat width = kSize.width;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    [text addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length - 4, 1)];
    
    [attributedText appendAttributedString:text];
    //self.attributedText = text;
    
    if (self.type & YYFPSLabelType_CPU)
    {
        width += 58;
        CGFloat cpuUsage = [[self class] cpuUsageForApp];
        if (cpuUsage * 100 > 100) {
            cpuUsage = 100;
        }else{
            cpuUsage = cpuUsage * 100;
        }
        
        NSMutableAttributedString *cputext = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"|%d CPU", (int)round(cpuUsage)]];
        [cputext addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
        [cputext addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(1, cputext.length - 3)];
        [cputext addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(cputext.length - 3, 3)];
        [cputext addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, cputext.length)];
        [cputext addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(cputext.length - 4, 1)];
        
        [attributedText appendAttributedString:cputext];
    }

    if (self.type & YYFPSLabelType_MEM)
    {
        width += 100;
        double menUsage = [[self class] usedMemory];
        double menFree = [[self class] freeMemory];

        NSString *usage = [NSString stringWithFormat:@"%@", [[NSDecimalNumber bm_decimalNumberWithDouble:menUsage] bm_stringWithDecimalStyle]];
        NSString *free = [NSString stringWithFormat:@"%@", [[NSDecimalNumber bm_decimalNumberWithDouble:menFree] bm_stringWithDecimalStyle]];
        NSMutableAttributedString *memtext = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"|%@/%@", usage, free]];
        [memtext addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
        [memtext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, usage.length)];
        [memtext addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(usage.length+1, 1)];
        [memtext addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(usage.length + 2, free.length)];
        [memtext addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, memtext.length)];
        
        [attributedText appendAttributedString:memtext];
    }
    
    self.bm_width = width;
    self.attributedText = attributedText;
}


// Credit to: http://stackoverflow.com/questions/8223348/ios-get-cpu-usage-from-application
+ (CGFloat)cpuUsageForApp
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    //获取当前任务，即当前的进程信息
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS)
        return -1;
    
    //task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    //uint32_t stat_thread = 0; // Mach threads
    
    //basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    //  获取当前进程中 线程列表
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;
    //if (thread_count > 0)
    //    stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        //获取每一个线程信息
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            //宏定义TH_USAGE_SCALE返回CPU处理总频率：
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
        
    } // for each thread
    
    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

//监测剩余内存大小：
+ (double)freeMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

//监测app使用内存的情况：
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

//设备总的内存
+ (NSUInteger)totalMemoryForDevice
{
    return (NSUInteger)([NSProcessInfo processInfo].physicalMemory/1024/1024);
}

@end

#endif
