package top.xiaocao.pixiv.update

import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class DownloadReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getLongExtra(
            DownloadManager.EXTRA_DOWNLOAD_ID,
            -1
        )
        when (intent.action) {
            DownloadManager.ACTION_DOWNLOAD_COMPLETE -> {
//                Log.i("DownloadReceiver", "下载完成")
                if (DownloadManagerUtil.appId == id) {
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