import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'i18n.dart';

class I18nTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          I18n.doubleClickExitHint: '再按一次退出',
          I18n.illust: '插画',
          I18n.manga: '漫画',
          I18n.novel: '小说',
          I18n.illustAndManga: '插画&漫画',
          I18n.user: '用户',
          I18n.bookmark: '收藏',
          I18n.info: '信息',
          I18n.followed: '已关注',
          I18n.follow: '关注',
          I18n.fans: '粉丝',
          I18n.followUser: '关注用户',
          I18n.recommended: '推荐',
          I18n.ranking: '排行',
          I18n.search: '搜索',
          I18n.self: '我的',
          I18n.all: '全部',
          I18n.public: '公开',
          I18n.private: '悄悄',
          I18n.confirm: '确定',
          I18n.cancel: '取消',
          I18n.delete: '删除',
          I18n.close: '关闭',
          I18n.send: '发送',
          I18n.read: '阅读',
          I18n.success: '成功',
          I18n.notExist: '不存在',
          I18n.failed: '失败',
          I18n.loadFailedRetry: '加载失败,点击重新加载',
          I18n.followingNewIllust: '最新作品(关注者)',
          I18n.anyNewIllust: '最新作品(所有人)',
          I18n.settings: '设置',
          I18n.downloadTask: '下载任务',
          I18n.browsingHistory: '浏览历史记录',
          I18n.about: '关于',
          I18n.openSettingsPageInBrowser: '在浏览器中打开设置页面',
          I18n.refreshIndicatorModeDarg: '继续下拉以刷新',
          I18n.refreshIndicatorModeArmed: '松手刷新',
          I18n.refreshIndicatorModeSnap: '准备刷新',
          I18n.refreshIndicatorModeRefresh: '正在刷新...',
          I18n.refreshIndicatorModeCanceled: '已取消',
          I18n.imageIsExist: '图片已经存在',
          I18n.saveSuccess: '保存成功',
          I18n.saveFailed: '保存失败',
          I18n.downloadFailed: '下载失败',
          I18n.downloadTaskIsExist: '下载任务已经存在',
          I18n.downloadStart: '下载开始',
          I18n.nextStep: '下一步',
          I18n.replice: '回复',
          I18n.comment: '评论',
          I18n.commentNotFoundHint: '评论失败,欲回复的评论不存在',
          I18n.commentFailedHint: '评论失败,请重试',
          I18n.loadingMore: '点击加载更多',
          I18n.totalView: '总查看',
          I18n.totalBookmark: '总收藏',
          I18n.viewComment: '查看评论',
          I18n.noBackgroundImage: '没有背景图片',
          I18n.saveExceptionHint: '保存异常',
          I18n.copySuccess: '复制成功',
          I18n.latestRelease: '最新发行版',
          I18n.openInGitHub: '在GitHub上打开',
          I18n.getHelp: '获取帮助',
          I18n.clickCheckUpdate: '点击检查更新',
          I18n.openTagWebPage: '打开标签页',
          I18n.downloadLatestVersion: '下载最新版本',
          I18n.longPressCopyUrl: '长按复制url',
          I18n.startUpdateFailed: '启动更新失败',
          I18n.openBrowserFailed: '打开浏览器失败',
          I18n.name: '名称',
          I18n.account: '账号',
          I18n.webpage: '网页',
          I18n.birth: '出生',
          I18n.job: '工作',
          I18n.pc: '电脑',
          I18n.monitor: '显示器',
          I18n.tool: '软件',
          I18n.scanner: '扫描仪',
          I18n.tablet: '数位板',
          I18n.mouse: '鼠标',
          I18n.printer: '打印机',
          I18n.desktop: '桌子上的东西',
          I18n.music: '画图时听的音乐',
          I18n.desk: '桌子',
          I18n.chair: '椅子',
          I18n.other: '其他',
          I18n.useReverseProxy: '使用本地反向代理',
          I18n.language: '语言',
          I18n.theme: '主题',
          I18n.imageSource: '图片源',
          I18n.previewQuality: '预览质量',
          I18n.scaleQuality: '缩放质量',
          I18n.previewQualityItem1: '中等',
          I18n.previewQualityItem2: '大图',
          I18n.scaleQualityItem1: '大图',
          I18n.scaleQualityItem2: '原图',
          I18n.day: '每日',
          I18n.dayR18: '每日(R-18)',
          I18n.dayMale: '每日(男性欢迎)',
          I18n.dayMaleR18: '每日(男性欢迎 & R-18)',
          I18n.dayFemale: '每日(女性欢迎)',
          I18n.dayFemaleR18: '每日(女性欢迎 & R-18)',
          I18n.week: '每周',
          I18n.weekR18: '每周(R-18)',
          I18n.weekOriginal: '每周(原创)',
          I18n.weekRookie: '每周(新人)',
          I18n.month: '每月',
          I18n.statusError: '加载失败',
          I18n.clickRetry: '点击重试',
          I18n.statusBusying: '正在加载...',
          I18n.statusNoMoreLoad: '没有更多数据了',
          I18n.statusEmpty: '没有任何数据',
          I18n.timeRange: '时间范围',
          I18n.timeRangeUnlimit: '无限制',
          I18n.timeRangeOneDay: '一天内',
          I18n.timeRangeOneWeek: '一周内',
          I18n.timeRangeOneMonth: '一月内',
          I18n.timeRangeHalfYear: '半年内',
          I18n.timeRangeOneYear: '一年内',
          I18n.timeRangeCustom: '自定义',
          I18n.dark: '黑暗',
          I18n.light: '明亮',
          I18n.loginFromClipboard: '从剪切板登录',
          I18n.loginFromClipboardHint: '先长按头像复制账号数据',
          I18n.clipboardDataIsNotValidAccountData: '剪切板数据不是有效的账号数据',
          I18n.login: '登录',
          I18n.register: '注册',
          I18n.clear: '清空',
          I18n.clearBrowsingHistoryAsk: '确定要清空嘛?',
          I18n.removeBrowsingHistoryOne: '删除这一条历史记录',
          I18n.removeBrowsingHistoryOneAsk: '确定要删除嘛',
          I18n.enableBrowsingHistory: '启用历史记录',
          I18n.prePage: '上一页',
          I18n.nextPage: '下一页',
          I18n.searchInputHint: '搜索关键字或ID',
          I18n.similarity: '相似度',
          I18n.image: '图片',
          I18n.use: '使用',
          I18n.customImageSource: '自定义图片源',
          I18n.noPremiumHint: '你不是Pixiv高级会员,所以该选项与时间降序行为一致',
          I18n.partialMatchForTags: '标签(部分匹配)',
          I18n.exactMatchForTags: '标签(完全匹配)',
          I18n.titleAndCaption: '标签&简介',
          I18n.dateDesc: '时间降序',
          I18n.dateAsc: '时间升序',
          I18n.popularDesc: '热度降序',
          I18n.frame: '帧',
          I18n.ugoiraLoadStartHint: '开始获取动图信息',
          I18n.ugoiraLoadFailedHint: '获取动图信息失败',
          I18n.ugoiraDownloadStartHint: '开始下载动图压缩包',
          I18n.ugoiraDownloadFailedHint: '下载动图压缩包失败',
          I18n.ugoiraGenerateStartHint: '开始生成图片',
          I18n.ugoiraSaveStartHint: '开始合成图片',
          I18n.currentVersion: '当前版本',
          I18n.bookmarksOverNum: '以上的收藏',
          I18n.bookmarksNumUnlimited: '收藏数量不限',
        },
        'en_US': {
          I18n.doubleClickExitHint: 'Return again to exit',
          I18n.illust: 'Illust',
          I18n.manga: 'Manga',
          I18n.novel: 'Novel',
          I18n.illustAndManga: 'Illust&Manga',
          I18n.user: 'User',
          I18n.bookmark: 'Bookmark',
          I18n.info: 'Info',
          I18n.followed: 'Followed',
          I18n.follow: 'Follow',
          I18n.fans: 'Fans',
          I18n.followUser: 'Follow user',
          I18n.recommended: 'Recommended',
          I18n.ranking: 'Ranking',
          I18n.search: 'Search',
          I18n.self: 'Me',
          I18n.all: 'All',
          I18n.public: 'Public',
          I18n.private: 'Private',
          I18n.confirm: 'Confirm',
          I18n.cancel: 'Cancel',
          I18n.delete: 'Delete',
          I18n.close: 'Close',
          I18n.send: 'Send',
          I18n.read: 'Read',
          I18n.success: 'Success',
          I18n.notExist: 'NotExist',
          I18n.failed: 'Failed',
          I18n.loadFailedRetry: 'Load failed, click to reload',
          I18n.followingNewIllust: 'Latest works (following)',
          I18n.anyNewIllust: 'Latest work (owner)',
          I18n.settings: 'Settings',
          I18n.downloadTask: 'Download task',
          I18n.browsingHistory: 'Browsing history',
          I18n.about: 'About',
          I18n.openSettingsPageInBrowser: 'Open settings page in browser',
          I18n.refreshIndicatorModeDarg: 'Continue to pull down to refresh',
          I18n.refreshIndicatorModeArmed: 'Let go and refresh',
          I18n.refreshIndicatorModeSnap: 'Ready to refresh',
          I18n.refreshIndicatorModeRefresh: 'Refreshing...',
          I18n.refreshIndicatorModeCanceled: 'Cancelled',
          I18n.imageIsExist: 'Picture already exists',
          I18n.saveSuccess: 'Saved successfully',
          I18n.saveFailed: 'Save failed',
          I18n.downloadFailed: 'Download failed',
          I18n.downloadTaskIsExist: 'Download task already exists',
          I18n.downloadStart: 'Download starts',
          I18n.nextStep: 'Next step',
          I18n.replice: 'Reply',
          I18n.comment: 'Comment',
          I18n.commentNotFoundHint: 'Comment failed, the comment you want to reply does not exist',
          I18n.commentFailedHint: 'Comment failed, please try again',
          I18n.loadingMore: 'Click to load more',
          I18n.totalView: 'TotalView',
          I18n.totalBookmark: 'TotalBookmark',
          I18n.viewComment: 'View comments',
          I18n.noBackgroundImage: 'No background image',
          I18n.saveExceptionHint: 'Save exception',
          I18n.copySuccess: 'Copy successfully',
          I18n.latestRelease: 'Latest release',
          I18n.openInGitHub: 'Open in GitHub',
          I18n.getHelp: 'Get help',
          I18n.clickCheckUpdate: 'Click to check for updates',
          I18n.openTagWebPage: 'Open tab',
          I18n.downloadLatestVersion: 'Download the latest version',
          I18n.longPressCopyUrl: 'Long press to copy url',
          I18n.startUpdateFailed: 'Failed to start update',
          I18n.openBrowserFailed: 'Failed to open the browser',
          I18n.name: 'Name',
          I18n.account: 'Account',
          I18n.webpage: 'Webpage',
          I18n.birth: 'Birth',
          I18n.job: 'Job',
          I18n.pc: 'PC',
          I18n.monitor: 'Monitor',
          I18n.tool: 'Tool',
          I18n.scanner: 'Scanner',
          I18n.tablet: 'Tablet',
          I18n.mouse: 'Mouse',
          I18n.printer: 'Printer',
          I18n.desktop: 'Desktop',
          I18n.music: 'Music',
          I18n.desk: 'Desk',
          I18n.chair: 'chair',
          I18n.other: 'comment',
          I18n.useReverseProxy: 'Use local reverse proxy',
          I18n.language: 'Language',
          I18n.theme: 'Theme',
          I18n.imageSource: 'Image source',
          I18n.previewQuality: 'Preview quality',
          I18n.scaleQuality: 'Scale quality',
          I18n.previewQualityItem1: 'Medium',
          I18n.previewQualityItem2: 'Large',
          I18n.scaleQualityItem1: 'Large',
          I18n.scaleQualityItem2: 'Original',
          I18n.day: 'Daily',
          I18n.dayR18: 'Daily(R-18)',
          I18n.dayMale: 'Daily(men welcome)',
          I18n.dayMaleR18: 'Daily(male welcome & R-18)',
          I18n.dayFemale: 'Daily(Women welcome)',
          I18n.dayFemaleR18: 'Daily(Women welcome & R-18)',
          I18n.week: 'Weekly',
          I18n.weekR18: 'Every week (R-18)',
          I18n.weekOriginal: 'Weekly (original)',
          I18n.weekRookie: 'Every week (newcomers)',
          I18n.month: 'Month',
          I18n.statusError: 'Load failed',
          I18n.clickRetry: 'Click to try again',
          I18n.statusBusying: 'Loading...',
          I18n.statusNoMoreLoad: 'No more data',
          I18n.statusEmpty: 'No data',
          I18n.timeRange: 'Time limit',
          I18n.timeRangeUnlimit: 'Unlimited',
          I18n.timeRangeOneDay: 'In one day',
          I18n.timeRangeOneWeek: 'Within a week',
          I18n.timeRangeOneMonth: 'Within a month',
          I18n.timeRangeHalfYear: 'Within half a year',
          I18n.timeRangeOneYear: 'Within a year',
          I18n.timeRangeCustom: 'Customize',
          I18n.dark: 'Dark',
          I18n.light: 'Light',
          I18n.loginFromClipboard: 'Login from the clipboard',
          I18n.loginFromClipboardHint: 'Long press the avatar to copy the account data',
          I18n.clipboardDataIsNotValidAccountData: 'Clipboard data is not valid account data',
          I18n.login: 'Login',
          I18n.register: 'Register',
          I18n.clear: 'Clear',
          I18n.clearBrowsingHistoryAsk: 'Are you sure you want to empty it?',
          I18n.removeBrowsingHistoryOne: 'Delete this history',
          I18n.removeBrowsingHistoryOneAsk: 'Are you sure you want to delete',
          I18n.enableBrowsingHistory: 'Enable history',
          I18n.prePage: 'Previous page',
          I18n.nextPage: 'Next page',
          I18n.searchInputHint: 'Search keyword or ID',
          I18n.similarity: 'Similarity',
          I18n.image: 'Image',
          I18n.use: 'Use',
          I18n.customImageSource: 'Custom picture source',
          I18n.noPremiumHint: 'You are not a Pixiv premium member, so this option is consistent with the descending behavior of time',
          I18n.partialMatchForTags: 'Label (partial match)',
          I18n.exactMatchForTags: 'Label (exact match)',
          I18n.titleAndCaption: 'Labels & Caption',
          I18n.dateDesc: 'Time descending',
          I18n.dateAsc: 'Ascending time',
          I18n.popularDesc: 'Descending by popularity',
          I18n.frame: 'Frame',
          I18n.ugoiraLoadStartHint: 'Start to get GIF information',
          I18n.ugoiraLoadFailedHint: 'Failed to get GIF information',
          I18n.ugoiraDownloadStartHint: 'Start downloading the gif compressed package',
          I18n.ugoiraDownloadFailedHint: 'Failed to download GIF compression package',
          I18n.ugoiraGenerateStartHint: 'Start to generate image',
          I18n.ugoiraSaveStartHint: 'Start synthesizing image',
          I18n.currentVersion: 'Current version',
          I18n.bookmarksOverNum: 'Above collection',
          I18n.bookmarksNumUnlimited: 'Unlimited number of collections',
        },
        'ja_JP': {
          I18n.doubleClickExitHint: 'もう一度押すと終了します',
          I18n.illust: 'イラスト',
          I18n.manga: 'コミック',
          I18n.novel: '小説',
          I18n.illustAndManga: 'イラスト＆コミック',
          I18n.user: 'ユーザー',
          I18n.bookmark: '収集',
          I18n.info: '情報',
          I18n.followed: 'フォローしました',
          I18n.follow: '注意を払う',
          I18n.fans: 'ファン',
          I18n.followUser: 'ユーザーをフォローする',
          I18n.recommended: 'お勧め',
          I18n.ranking: 'ランキング',
          I18n.search: '探す',
          I18n.self: '私の',
          I18n.all: '全て',
          I18n.public: '公衆',
          I18n.private: '静かに',
          I18n.confirm: 'もちろん',
          I18n.cancel: 'キャンセル',
          I18n.delete: '消去',
          I18n.close: '閉鎖',
          I18n.send: '送信',
          I18n.read: '読む',
          I18n.success: '成功',
          I18n.notExist: '存在しません',
          I18n.failed: '失敗',
          I18n.loadFailedRetry: 'ロードに失敗しました。クリックしてリロードしてください',
          I18n.followingNewIllust: '最新作（フォロワー）',
          I18n.anyNewIllust: '最新作（オーナー）',
          I18n.settings: '設定',
          I18n.downloadTask: 'タスクのダウンロード',
          I18n.browsingHistory: '閲覧履歴',
          I18n.about: '約',
          I18n.openSettingsPageInBrowser: 'ブラウザで設定ページを開く',
          I18n.refreshIndicatorModeDarg: 'プルダウンを続けて更新します',
          I18n.refreshIndicatorModeArmed: '手放してリフレッシュ',
          I18n.refreshIndicatorModeSnap: '更新する準備ができました',
          I18n.refreshIndicatorModeRefresh: 'さわやか...',
          I18n.refreshIndicatorModeCanceled: 'キャンセル',
          I18n.imageIsExist: '写真はすでに存在します',
          I18n.saveSuccess: '正常に保存',
          I18n.saveFailed: '保存に失敗しました',
          I18n.downloadFailed: 'ダウンロードに失敗しました',
          I18n.downloadTaskIsExist: 'ダウンロードタスクはすでに存在します',
          I18n.downloadStart: 'ダウンロード開始',
          I18n.nextStep: '次のステップ',
          I18n.replice: '返事',
          I18n.comment: 'コメント',
          I18n.commentNotFoundHint: 'コメントに失敗しました。返信したいコメントが存在しません',
          I18n.commentFailedHint: 'コメントに失敗しました。もう一度やり直してください',
          I18n.loadingMore: 'クリックしてさらにロード',
          I18n.totalView: '全体のビュー',
          I18n.totalBookmark: 'トータルコレクション',
          I18n.viewComment: 'コメントを見る',
          I18n.noBackgroundImage: '背景画像なし',
          I18n.saveExceptionHint: '例外を保存',
          I18n.copySuccess: '正常にコピー',
          I18n.latestRelease: '最新のリリース',
          I18n.openInGitHub: 'GitHubで開きます',
          I18n.getHelp: '助けを得ます',
          I18n.clickCheckUpdate: 'クリックして更新を確認します',
          I18n.openTagWebPage: 'タブを開く',
          I18n.downloadLatestVersion: '最新バージョンをダウンロードする',
          I18n.longPressCopyUrl: '長押ししてURLをコピー',
          I18n.startUpdateFailed: '更新を開始できませんでした',
          I18n.openBrowserFailed: 'ブラウザを開くことができませんでした',
          I18n.name: '名前',
          I18n.account: 'アカウント',
          I18n.webpage: 'ウェブページ',
          I18n.birth: '生まれ',
          I18n.job: '仕事',
          I18n.pc: 'コンピューター',
          I18n.monitor: 'モニター',
          I18n.tool: 'ソフトウェア',
          I18n.scanner: 'スキャナー',
          I18n.tablet: 'タブレット',
          I18n.mouse: 'ねずみ',
          I18n.printer: 'プリンター',
          I18n.desktop: 'テーブルの上のもの',
          I18n.music: '絵を描きながら音楽を聴く',
          I18n.desk: 'テーブル',
          I18n.chair: '椅子',
          I18n.other: '他の',
          I18n.useReverseProxy: 'ローカルリバースプロキシを使用する',
          I18n.language: '言語',
          I18n.theme: 'テーマ',
          I18n.imageSource: '画像ソース',
          I18n.previewQuality: 'プレビュー品質',
          I18n.scaleQuality: 'ズーム品質',
          I18n.previewQualityItem1: '中くらい',
          I18n.previewQualityItem2: '大きい',
          I18n.scaleQualityItem1: '大きい',
          I18n.scaleQualityItem2: '原画',
          I18n.day: '毎日',
          I18n.dayR18: '每日(R-18)',
          I18n.dayMale: '每日(男性歓迎)',
          I18n.dayMaleR18: '每日(男性歓迎 & R-18)',
          I18n.dayFemale: '每日(女性歓迎)',
          I18n.dayFemaleR18: '每日(女性歓迎 & R-18)',
          I18n.week: '毎週',
          I18n.weekR18: '毎週(R-18)',
          I18n.weekOriginal: '毎週(元の)',
          I18n.weekRookie: '每周(新入社員)',
          I18n.month: '月額',
          I18n.statusError: 'ロードに失敗しました',
          I18n.clickRetry: 'クリックして再試行してください',
          I18n.statusBusying: '読み込み中...',
          I18n.statusNoMoreLoad: 'これ以上のデータはありません',
          I18n.statusEmpty: 'データなし',
          I18n.timeRange: '制限時間',
          I18n.timeRangeUnlimit: '無制限',
          I18n.timeRangeOneDay: '一日で',
          I18n.timeRangeOneWeek: '1週間以内に',
          I18n.timeRangeOneMonth: '1か月以内',
          I18n.timeRangeHalfYear: '半年以内',
          I18n.timeRangeOneYear: '1年以内に',
          I18n.timeRangeCustom: 'カスタマイズ',
          I18n.dark: '闇',
          I18n.light: '明るい',
          I18n.loginFromClipboard: 'クリップボードからログインします',
          I18n.loginFromClipboardHint: 'アバターを長押ししてアカウントデータをコピーします',
          I18n.clipboardDataIsNotValidAccountData: 'クリップボードデータは有効なアカウントデータではありません',
          I18n.login: 'ログイン',
          I18n.register: '登録',
          I18n.clear: '空の',
          I18n.clearBrowsingHistoryAsk: '空にしてよろしいですか?',
          I18n.removeBrowsingHistoryOne: 'この履歴を削除する',
          I18n.removeBrowsingHistoryOneAsk: '消去してもよろしいですか',
          I18n.enableBrowsingHistory: '履歴を有効にする',
          I18n.prePage: '前のページ',
          I18n.nextPage: '次のページ',
          I18n.searchInputHint: 'キーワードまたはIDを検索',
          I18n.similarity: '類似性',
          I18n.image: '画像',
          I18n.use: '使用する',
          I18n.customImageSource: 'カスタム画像ソース',
          I18n.noPremiumHint: 'あなたはPixivプレミアム会員ではないので、このオプションは時間の降順の振る舞いと一致しています',
          I18n.partialMatchForTags: 'ラベル（部分一致）',
          I18n.exactMatchForTags: 'ラベル（完全一致）',
          I18n.titleAndCaption: 'ラベルと紹介',
          I18n.dateDesc: '時間の降順',
          I18n.dateAsc: '昇順時間',
          I18n.popularDesc: '人気の降順',
          I18n.frame: 'フレーム',
          I18n.ugoiraLoadStartHint: 'ugoira情報の取得を開始します',
          I18n.ugoiraLoadFailedHint: 'ugoira情報を取得できませんでした',
          I18n.ugoiraDownloadStartHint: 'ugoira圧縮パッケージのダウンロードを開始します',
          I18n.ugoiraDownloadFailedHint: 'ugoira圧縮パッケージのダウンロードに失敗しました',
          I18n.ugoiraGenerateStartHint: 'ugoiraの生成を開始します',
          I18n.ugoiraSaveStartHint: 'ugoiraの合成を開始します',
          I18n.currentVersion: '現行版',
          I18n.bookmarksOverNum: '上記のコレクション',
          I18n.bookmarksNumUnlimited: 'コレクションの数に制限はありません',
        },
      };
}
