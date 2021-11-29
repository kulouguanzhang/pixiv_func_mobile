# 你好,色批人

### _该项目与一切现有同类项目无关,请不要拿来比较_

此软件开源且免费(不收取打赏) 禁止用于盈利(包括但不仅限于收取打赏)

如果你觉得我的软件好用 可以推荐给朋友

---
[![Latest release](https://img.shields.io/github/release/xiao-cao-x/pixiv-func-android?label=latest%20release)](https://github.com/xiao-cao-x/pixiv_func_android/releases/latest)


| 下载最新版本 |  |
| --- | --- |
| [方式1(点击下载)](https://github.com/xiao-cao-x/pixiv_func_android/releases/latest/download/app-release.apk) | github.com |
| [方式2(点击下载)](https://ghproxy.com/https://github.com/xiao-cao-x/pixiv_func_android/releases/latest/download/app-release.apk) | ghproxy.com(国内用这个) |


支持功能如下

| 名称 | 备注 |
| --- | --- |
| 登录 | 用的 [WebView](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/android/app/src/main/kotlin/top/xiaocao/pixiv/platform/webview/PlatformWebView.kt) 支持免代理直连(本地反向代理) |
| 浏览历史记录 | 存储在`SQLite`数据库中 可以在设置中开关 |
| 查看推荐作品 | 插画/漫画/小说 |
| 查看收藏作品 | 插画&漫画/小说  |
| 查看已关注用户的最新作品  |  |
| 查看陌生人的最新作品 | 插画&漫画/小说 |
| 查看关注用户 |  |
| 查看排行榜 |  |
| 推荐 | 推荐用户/推荐标签 |
| 搜索插画&漫画/小说  | 支持排序,支持时间范围,支持搜索ID,支持按收藏数量搜索 |
| 搜索用户 | 支持搜索ID |
| 图片搜源 | [集成了一个外部网站(非WebView)](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/lib/view_model/search_image_result_model.dart#L98) |
| 查看小说 | [解析HTML(非WebView)](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/lib/view_model/novel_model.dart) |
| 查看动图 | [Native解压](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/android/app/src/main/kotlin/top/xiaocao/pixiv/platform/api/PlatformApi.kt#L60)   [CustomPainter播放](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/lib/ui/widget/gif_view.dart) 支持暂停 |
| 保存动图 | [Native合成](https://github.com/xiao-cao-x/pixiv_func_android/blob/main/android/app/src/main/kotlin/top/xiaocao/pixiv/platform/api/PlatformApi.kt#L26) |
| 保存原图到系统相册 | 可以查看下载任务 |
| 关注和取消关注(用户) |  |
| 收藏和取消收藏(插画&漫画/小说) |  |
