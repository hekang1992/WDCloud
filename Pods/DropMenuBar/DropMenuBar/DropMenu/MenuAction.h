//
//  MenuAction.h
//  LinkageMenu
//
//  Created by 魏小庄 on 2018/5/18.
//  Copyright © 2018年 魏小庄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
typedef NS_ENUM(NSInteger, MenuActionStyle) {
     MenuActionTypeList,
     MenuActionTypeCustom
};

@interface MenuAction : UIButton

@property (nonatomic, assign, readonly) MenuActionStyle actionStyle;
@property (nonatomic, copy, readonly) NSString *title;
// 数据源
@property (nonatomic, strong) NSArray <ItemModel *>*ListDataSource;

//granted 是否点击了不限
@property (nonatomic, copy) void(^didSelectedMenuResult)(NSInteger index, ItemModel *selecModel, BOOL granted);

@property (nonatomic, copy) UIView *(^displayCustomWithMenu)(void);

+ (instancetype) actionWithTitle:(NSString *)title style:(MenuActionStyle)style;

-(void)adjustFrame;

/** 用于调整 自定义视图选中时文字的显示 */
- (void) adjustTitle:(NSString *)title textColor:(UIColor *)color;

- (void) dismiss;

/** 私有属性用于自定义视图 主动移除筛选列表  */
@property (nonatomic, copy) void (^didDismissDropMenu)(void);

@end
