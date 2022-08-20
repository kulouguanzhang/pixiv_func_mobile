import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';

class I18nTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          I18n.aboutPageTitle : '关于',
          I18n.accountPageTitle : '账号管理',
          I18n.blockTagPageTitle : '屏蔽标签管理',
          I18n.downloaderPageTitle : '下载任务',
          I18n.historyPageTitle : '历史记录',
          I18n.themeSettingsPageTitle : '主题',
          I18n.languageSettingsPageTitle : '语言',
          I18n.imageSourceSettingsPageTitle : '图片源',
          I18n.previewQualitySettingsPageTitle : '预览质量',
          I18n.scaleQualitySettingsPageTitle : '缩放质量',
          I18n.meSettingsPageTitle : '账号设置',
          I18n.meProfileSettingsPageTitle : '个人资料',
          I18n.meWorkspaceSettingsPageTitle : '工作环境',
          I18n.meWebSettingsPageTitle : 'Web设置',
          I18n.loginPageTitle : '注册 或 登录',
          I18n.copiedToClipboardHint : '已复制到剪贴板',
          I18n.cancel : '取消',
          I18n.confirm : '确定',
          I18n.dark : '黑暗',
          I18n.light : '明亮',
          I18n.followSystem : '跟随系统',
          I18n.illust : '插画',
          I18n.manga : '漫画',
          I18n.novel : '小说',
          I18n.illustAndManga : '插画&漫画',
          I18n.user : '用户',
          I18n.live : '直播',
          I18n.restrictPublic : '公开',
          I18n.restrictPrivate : '悄悄',
          I18n.account : '账号',
          I18n.checkVersionHint : '检查版本更新',
          I18n.hasNewVersionHint : '发现新版本 点击更新',
          I18n.noNewVersionHint : '已经是最新版本',
          I18n.checkingVersionHint : '正在检查更新...',
          I18n.checkVersionErrorHint : '检查更新失败 点击重试',
          I18n.contactAuthor : '联系作者',
          I18n.getHelp : '获取帮助',
          I18n.currentVersion : '当前版本:%s',
          I18n.openTagPage : '打开标签页',
          I18n.confirmLogoutHint : '确认退出此账号',
          I18n.next : '下一步',
          I18n.selectFavoriteTheme : '选择喜欢的主题',
          I18n.laterChangeInSettings : '稍后您可以在设置中进行相应变更',
          I18n.browsingHistory : '历史记录',
          I18n.deleteThisHistory : '删除这条历史记录',
          I18n.deleteThisHistoryHint : '删除后将不可恢复',
          I18n.all : '全部',
          I18n.recommend : '推荐',
          I18n.comment : '评论',
          I18n.illustIdPageTitle : '插画%s',
          I18n.illustIdNotFound : '插画%s不存在',
          I18n.illustAgeLimitHint : '插画%s是%s,请前往Web设置中修改年龄限制',
          I18n.send : '发送',
          I18n.commentSuccessHint : '评论成功',
          I18n.replySuccessHint : '回复成功',
          I18n.replyFailedHint : '回复失败,欲回复的评论不存在',
          I18n.commentFailedHint : '评论失败',
          I18n.deleteCommentSuccessHint : '删除评论成功',
          I18n.deleteCommentFailedHint : '删除评论失败',
          I18n.commentIllust : '评论 插画',
          I18n.replyComment : '回复 %s',
          I18n.selectImage : '选择图片',
          I18n.reset : '重置',
          I18n.reselect : '重选',
          I18n.playDuration : '播放时长',
          I18n.liveEnd : '直播已经结束',
          I18n.register : '注册',
          I18n.login : '登录',
          I18n.localReverseProxy : '本地反向代理',
          I18n.reverseProxyHint : 'Pixiv官方页面无法注册或登陆时，建议开启本地反向代理。',
          I18n.getMoreHelp : '获取更多帮助 >>',
          I18n.useLoginWithClipboardHint : '或使用\n长按头像复制账号数据',
          I18n.useLoginWithClipboard : '使用剪贴板数据登录',
          I18n.loginAgree : '登录即表示您同意',
          I18n.userAgreement : '《Pixiv Func用户使用协议》',
          I18n.password : '密码',
          I18n.pixivAccountHint : '邮箱地址或pixiv ID',
          I18n.clipboard : '剪贴板',
          I18n.copy : '复制',
          I18n.noEntry : '无法输入?',
          I18n.following : '关注者',
          I18n.everyone : '所有人',
          I18n.myPixiv : '好P友',
          I18n.rankingItemDay : '每日',
          I18n.rankingItemDayR18 : '每日(R-18)',
          I18n.rankingItemDayMale : '每日(男性欢迎)',
          I18n.rankingItemDayMaleR18 : '每日(男性欢迎 & R-18)',
          I18n.rankingItemDayFemale : '每日(女性欢迎)',
          I18n.rankingItemDayFemaleR18 : '每日(女性欢迎 & R-18)',
          I18n.rankingItemWeek : '每周',
          I18n.rankingItemWeekR18 : '每周(R-18)',
          I18n.rankingItemWeekOriginal : '每周(原创)',
          I18n.rankingItemWeekRookie : '每周(新人)',
          I18n.rankingItemMonth : '每月',
          I18n.search : '搜索',
          I18n.searchItem : '搜索: %s',
          I18n.keyword : '关键字',
          I18n.illustId : '插画ID',
          I18n.novelId : '小说ID',
          I18n.userId : '用户ID',
          I18n.searchImage : '搜图',
          I18n.searchHint : '搜索关键字或ID',
          I18n.searchDateLimitNo : '无限制',
          I18n.searchDateLimitDay : '一天内',
          I18n.searchDateLimitWeek : '一周内',
          I18n.searchDateLimitMonth : '一月内',
          I18n.searchDateLimitHalfYear : '半年内',
          I18n.searchDateLimitYear : '一年内',
          I18n.searchDateLimitCustom : '自定义',
          I18n.searchTarget : '搜索方式',
          I18n.searchSort : '搜索排序',
          I18n.searchDateRange : '时间范围',
          I18n.searchBookmarkCount : '收藏数量',
          I18n.searchBookmarkCountNo : '不限制',
          I18n.searchBookmarkCountMore : '%s以上',
          I18n.searchSortDateDesc : '时间降序',
          I18n.searchSortDateAsc : '时间升序',
          I18n.searchSortPopularDesc : '热度降序',
          I18n.searchTargetPartialMatchForTags : '标签(部分)',
          I18n.searchTargetExactMatchForTags : '标签(完全)',
          I18n.searchTargetTitleAndCaption : '标题&简介',
          I18n.searchTargetText : '文本',
          I18n.searchTargetKeyword : '关键字',
          I18n.useCustomImageSource : '使用自定义图片源',
          I18n.mediumImage : '中等',
          I18n.largeImage : '大图',
          I18n.originalImage : '原图',
          I18n.resolution : '分辨率:%s',
          I18n.summary : '介绍',
          I18n.uploadDate : '上传日期%s',
          I18n.startGetUgoiraInfo : '开始获取动图信息',
          I18n.getUgoiraInfoFailed : '获取动图信息失败',
          I18n.startDownloadUgoira : '开始下载动图压缩包',
          I18n.downloadUgoiraFailed : '下载动图压缩包失败',
          I18n.startGenerateImage : '开始生成图片 共%s帧',
          I18n.startCompositeImage : '开始合成图片 共%s帧',
          I18n.userIdPageTitle : '用户ID%s',
          I18n.userIdNotFound : '用户ID%s不存在',
          I18n.work : '作品',
          I18n.bookmarked : '收藏',
          I18n.about : '关于',
          I18n.fans : '粉丝',
          I18n.ageLimit : '年龄限制',
          I18n.allAge : '全年龄',
          I18n.publicityPublic : '公开',
          I18n.publicityPrivate : '私密',
          I18n.publicityMyPixiv : '好P友',
          I18n.modify : '修改',
          I18n.delete : '删除',
          I18n.avatar : '头像',
          I18n.nickname : '昵称',
          I18n.homepage : '主页',
          I18n.gender : '性别',
          I18n.genderMale : '男性',
          I18n.genderFemale : '女性',
          I18n.genderUnknown : '未选择',
          I18n.address : '地址',
          I18n.country : '国家',
          I18n.birthday : '生日',
          I18n.job : '工作',
          I18n.introduction : '简介',
          I18n.introductionHint : '写点什么吧',
          I18n.updateProfile : '更新个人资料',
          I18n.workspacePc : '电脑',
          I18n.workspaceMonitor : '显示器',
          I18n.workspaceTool : '软件',
          I18n.workspaceScanner : '扫描仪',
          I18n.workspaceTablet : '数位板',
          I18n.workspaceMouse : '鼠标',
          I18n.workspacePrinter : '打印机',
          I18n.workspaceDesktop : '桌子上的东西',
          I18n.workspaceMusic : '画画时的音乐',
          I18n.workspaceDesk : '桌子',
          I18n.workspaceChair : '椅子',
          I18n.workspaceOther : '其他',
          I18n.workspaceUpdate : '更新工作环境',
          I18n.followed : '已关注',
          I18n.follow : '关注',
          I18n.followUser : '关注用户',
          I18n.bookmarkIllust : '收藏插画',
          I18n.illustIdDownloadTaskExists : '插画ID%s下载任务已经存在',
          I18n.illustIdDownloadTaskStart : '插画ID%s下载任务开始',
          I18n.illustIdSaveSuccess : '插画ID%s保存成功',
          I18n.illustIdSaveFailed : '插画ID%s保存失败',
          I18n.initPostKeyFailed : '初始化PostKey失败',
          I18n.ageLimitHint : '请将个人资料的年龄设置为大于18岁',
          I18n.webSettingFailed : 'Web设置失败',
          I18n.updateProfileSuccess : '更新个人资料成功',
          I18n.updateProfileFailed : '更新个人资料失败',
          I18n.updateWorkspaceSuccess : '更新工作环境成功',
          I18n.updateWorkspaceFailed : '更新工作环境失败',
          I18n.permissionDenied : '拒绝了权限',
          I18n.updateTitle : 'Pixiv Func更新',
          I18n.startDownload : '开始下载',
          I18n.downloadProgress : '下载进度:%s',
          I18n.loginRequired : '需要登录',
          I18n.invalidId : '无效的ID:%s',
          I18n.invalidPath : '无效的Path:%s',
          I18n.loginSuccess : '登录成功',
          I18n.setToPrivate : '已被设置为私密',
          I18n.getClipboardDataFailed : '获取剪贴板数据失败,可能是没有剪贴板权限',
          I18n.clipboardDataEmpty : '剪贴板数据为空',
          I18n.clipboardDataInvalid : '剪贴板数据不是有效的账号数据',
          I18n.unblockTag : '解除屏蔽:%s',
          I18n.blockTag : '屏蔽:%s',
          I18n.notPremiumHint : '你不是Pixiv高级会员,所以该选项与时间降序行为一致',
          I18n.searchImageStatus429Hint : '当前IP超过了saucenao未注册用户每日50次上限',
        },
        'en_US': {},
        'ja_JP': {},
        'ru_RU': {},
      };
}
