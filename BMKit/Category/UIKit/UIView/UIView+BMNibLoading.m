//
//  UIView+BMNibLoading.m
//  BMBasekit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import "UIView+BMNibLoading.h"
#import "UIView+BMSize.h"

@implementation UIView (BMNibLoading)

//- (instancetype)initWithNibName:(NSString *)nibName owner:(id)owner options:nil
//{
//    _customView = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] firstObject];
//    
//    self.bounds = _customView.bounds;
//}

+ (instancetype)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)ownerOrNil
{
    //default values
    NSString *nibName = nibNameOrNil ?: NSStringFromClass(self);
    NSBundle *bundle = bundleOrNil ?: [NSBundle mainBundle];

    //cache nib to prevent unnecessary filesystem access
    static NSCache *nibCache = nil;
    if (nibCache == nil)
    {
        nibCache = [[NSCache alloc] init];
    }
    NSString *pathKey = [NSString stringWithFormat:@"%@.%@", bundle.bundleIdentifier, nibName];
    UINib *nib = [nibCache objectForKey:pathKey];
    if (nib == nil)
    {
        NSString *nibPath = [bundle pathForResource:nibName ofType:@"xib"];
        if (nibPath) nib = [UINib nibWithNibName:nibName bundle:bundle];
        [nibCache setObject:nib ?: [NSNull null] forKey:pathKey];
    }
    else if ([nib isKindOfClass:[NSNull class]])
    {
        nib = nil;
    }

    if (nib)
    {
        //attempt to load from nib
        NSArray *contents = [nib instantiateWithOwner:ownerOrNil options:nil];
        UIView *view = [contents count]? [contents objectAtIndex:0]: nil;
        NSAssert ([view isKindOfClass:self], @"First object in nib '%@' was '%@'. Expected '%@'", nibName, view, self);
        return view;
    }

    //return empty view
    return [[[self class] alloc] init];
}

- (void)loadContentsWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil
{
    NSString *nibName = nibNameOrNil ?: NSStringFromClass([self class]);
    UIView *view = [UIView instanceWithNibName:nibName bundle:bundleOrNil owner:self];
    if (view)
    {
        if (CGSizeEqualToSize(self.frame.size, CGSizeZero))
        {
            //if we have zero size, set size from content
            self.bm_size = view.bm_size;
        }
        else
        {
            //otherwise set content size to match our size
            view.frame = self.bm_contentBounds;
        }
        [self addSubview:view];
    }
}

@end
