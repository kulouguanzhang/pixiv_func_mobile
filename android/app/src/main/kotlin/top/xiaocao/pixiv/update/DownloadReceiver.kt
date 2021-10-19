package top.xiaocao.pixiv.update

import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class DownloadReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        when (intent.action) {
            DownloadManager.ACTION_DOWNLOAD_COMPLETE -> {
//                Log.i("DownloadReceiver", "下载完成")
                if (DownloadManagerUtil.downloadId == intent.getLongExtra(
                        DownloadManager.EXTRA_DOWNLOAD_ID,
                        -1
                    )
                ) {
                    DownloadManagerUtil(context).install()
                }
            }
            DownloadManager.ACTION_NOTIFICATION_CLICKED -> {
//                Log.i("DownloadReceiver", "点击标题栏")
                DownloadManagerUtil(context).cleanup()
            }
        }

    }
}