package site.xiaocao.pixiv.update

import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class DownloadReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        if (intent.action == DownloadManager.ACTION_DOWNLOAD_COMPLETE) {
            intent.getLongExtra(
                DownloadManager.EXTRA_DOWNLOAD_ID,
                -1
            ).let {
                if (it == DownloadManagerUtil.downloadId) {
                    DownloadManagerUtil(context).run {
                        install(it)
                    }
                }
            }

        }

    }
}