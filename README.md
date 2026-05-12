# 基于ArkUI实现溪村小镇应用

### 简介

本示例基于ArkUI的基本能力和动画效果，通过展示溪村小镇的应用，帮助开发者掌握ArkUI组件的使用方法和事件的处理方法。效果图如下：

![](screenshots/device/example.gif)

### 相关概念

- Tabs组件：通过页签进行内容视图切换的容器组件，每个页签对应一个内容视图。
- List组件：列表包含一系列相同宽度的列表项，包含子组件ListItem。
- 点击手势：支持单击、双击和多次点击事件的识别。
- 拖动手势：用于触发拖动手势事件，滑动的最小距离为5vp时拖动手势识别成功。
- 捏合手势：用于触发捏合手势事件，触发捏合手势的最少手指为2指，最大为5指，最小识别距离为5vp。
- 属性动画：组件的某些通用属性变化时，可以通过属性动画实现渐变过渡效果，提升用户体验。
- 自定义弹窗：通过CustomDialogController类显示自定义弹窗。使用弹窗组件时，可优先考虑自定义弹窗，便于自定义弹窗的样式与内容。
- Canvas画布：用于自定义绘制图形。

### 工程目录

├──entry/src/main/ets	                 // 代码区
│  ├──common
│  │  ├──constants
│  │  │  ├──CommonConstants.ets          // 公共常量类
│  │  │  └──ZonesConstants.ets           // 区域常量类
│  │  ├──images
│  │  └──utils        
│  │     ├──DeviceScreen.ets             // 获取设备信息类
│  │     ├──Geography.ets                // 地理坐标转换工具类
│  │     ├──Logger.ets                   // 日志打印类
│  │     └──SwiperDataSource.ets         // 数据信息类
│  ├──controller
│  │  └──MapController.ets               // 地图控制类
│  ├──entryability
│  │  └──EntryAbility.ets	             // 程序入口类
│  ├──entryformability
│  │  └──EntryFormAbility.ets	         // 卡片入口类
│  ├──pages
│  │  ├──IntroductionPage.ets            // 区域详情页
│  │  ├──MainPage.ets                    // 应用首页
│  │  └──Splash.ets                      // 启动页
│  ├──train
│  │  └──pages
│  │     └──TrainCard.ets                // 小火车卡片
│  ├──view
│  │  ├──BuildListItem.ets               // 区域详情建筑、地理位置ListItem组件
│  │  ├──ImageAnimate.ets                // 区域详情小图滑动组件
│  │  ├──ImageViewComponent.ets          // 查看大图弹窗
│  │  ├──MapComponent.ets                // 地图组件
│  │  ├──StyleListItem.ets               // 区域详情风格信息ListItem组件          
│  │  ├──SubTitleItem.ets                // 区域详情子标题ListItem组件
│  │  ├──SwiperListItem.ets              // 区域详情首图轮播组件
│  │  ├──TrainsComponent.ets             // 小火车轨迹更新
│  │  ├──TrainsTrack.ets                 // 小火车组件
│  │  └──ZonesComponent.ets	             // 区域导览组件
│  └──viewmodel
│  │  ├──AddressItem.ets                 // 地图地标类
│  │  ├──BottomTabsItem.ets              // 底部标签类
│  │  ├──ButtonTabsModel.ets             // 底部标签数据
│  │  ├──CardListModel.ets               // 卡片列表数据
│  │  ├──MapModel.ets                    // 地图数据及方法
│  │  ├──PositionItem.ets                // 搜索面板地标类
│  │  ├──SplashModel.ets                 // 启动页数据
│  │  ├──TrainMap.ets                    // 小火车数据类
│  │  ├──TrainsMapModel.ets              // 小火车数据及方法
│  │  ├──ZonesItem.ets                   // 区域介绍类
│  │  └──ZonesViewModel.ets              // 区域介绍信息
│  └──zonescard
│     └──pages              
│        └──ZonesCard.ets                // 区域卡片类
└──entry/src/main/resources	             // 资源文件目录

### 相关权限

不涉及

### 使用说明

1. 打开应用时进入启动页，启动页轮播展示溪村小镇风景图，之后进入应用首页。
2. 在首页的“地图浏览”标签页，可以拖动和缩放查看地图，并查找相应地标建筑。
3. 在首页的“区域导览”标签页，可以上下滑动查看溪村小镇不同区域的卡片，点击卡片可以进入对应的区域详情页并查看区域的详细介绍和高清建筑风景图。
4. 在首页的“小火车”标签页，可以查看溪村小火车的运行路线图。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。
2. HarmonyOS系统：HarmonyOS 5.0.5 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.0.2 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.0.2 Release SDK及以上。
