//
//  NSBundle+BMResource.h
//  Pods
//
//  Created by DennisDeng on 2018/3/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BMResource)

#pragma mark image
// imageName不带扩展名默认为png
// 其他会自动补齐相应扩展名

+ (nullable UIImage *)bm_bundleImageFromBundleNamed:(NSString *)bundleName imageName:(NSString *)imageName;
+ (nullable UIImage *)bm_bundleAssetsImageFromeBundleName:(NSString *)bundleName assetsName:(NSString *)assetsName imageName:(NSString *)imageName;

- (nullable UIImage *)bm_imageWithImageName:(NSString *)imageName;
- (nullable UIImage *)bm_imageWithAssetsName:(NSString *)assetsName imageName:(NSString *)imageName;

#pragma mark localizedString

+ (NSBundle *)bm_mainLocalizedBundle;
+ (NSBundle *)bm_mainLocalizedBundleWithLanguage:(nullable NSString *)language;

+ (nullable NSBundle *)bm_localizedBundleWithBundleName:(NSString *)bundleName;
+ (nullable NSBundle *)bm_localizedBundleWithBundleName:(NSString *)bundleName language:(nullable NSString *)language;

+ (NSBundle *)bm_localizedBundleWithBundle:(NSBundle *)bundle;
+ (nullable NSBundle *)bm_localizedBundleWithBundle:(NSBundle *)bundle language:(nullable NSString *)language;

+ (nullable NSString *)bm_localizedStringFromBundleNamed:(NSString *)bundleName forKey:(NSString *)key value:(nullable NSString *)value;
+ (nullable NSString *)bm_localizedStringFromBundleNamed:(NSString *)bundleName forKey:(NSString *)key value:(nullable NSString *)value table:(nullable NSString *)table;

- (nullable NSString *)bm_localizedLanguageStringForKey:(NSString *)key value:(nullable NSString *)value;
- (nullable NSString *)bm_localizedLanguageStringForKey:(NSString *)key value:(nullable NSString *)value table:(nullable NSString *)table;

@end

NS_ASSUME_NONNULL_END

