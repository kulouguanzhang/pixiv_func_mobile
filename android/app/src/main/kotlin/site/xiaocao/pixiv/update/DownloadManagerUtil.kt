package site.xiaocao.pixiv.update

import android.app.DownloadManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File
import java.net.URI

class DownloadManagerUtil(private val context: Context) {

    private val downloadManager: DownloadManager
        get() =
            context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager


    fun checkDownloadManagerEnable(): Boolean {
        try {
            // 获取下载管理器的状态
            val state: Int =
                context.packageManager.getApplicationEnabledSetting(context.packageName)
            if (state == PackageManager.COMPONENT_ENABLED_STATE_DISABLED ||
                state == PackageManager.COMPONENT_ENABLED_STATE_DISABLED_USER ||
                state == PackageManager.COMPONENT_ENABLED_STATE_DISABLED_UNTIL_USED
            ) {
                // 跳转系统设置

                try {
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                    intent.data = Uri.parse("package:${context.packageName}")
                    context.startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    val intent = Intent(Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS)
                    context.startActivity(intent)
                }
                return false
            }
        } catch (e: Exception) {
            return false
        }
        return true
    }

    fun download(url: String, versionTag: String) {
        Log.i("Download", url)
        val destFile = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            "PixivFunc-$versionTag.apk"
        )
        if (destFile.exists()) {
            install(destFile)
            Log.i("Download", "文件已经存在")
            return
        }
        // 返回任务ID

        downloadId = try {
            downloadManager.enqueue(
                DownloadManager.Request(Uri.parse(url)).apply {
                    // 设置允许使用的网络类型
                    setAllowedNetworkTypes(
                        DownloadManager.Request.NETWORK_MOBILE or
                                DownloadManager.Request.NETWORK_WIFI
                    )
                    // 下载中以及下载完成都显示通知栏
                    setNotificationVisibility(
                        DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                    )

                    setTitle("PixivFunc更新")
                    setDescription("正在下载${destFile.name}")
                    setMimeType("application/vnd.android.package-archive")

                    setDestinationUri(Uri.fromFile(destFile))

                }
            )
        } catch (e: Exception) {
            e.printStackTrace()
            -1
        }
        Log.i("Download", downloadId.toString())
        Log.i("Download", destFile.absolutePath)
    }


    fun cleanup() {

        try {
            downloadManager.remove(downloadId)

        } catch (e: Exception) {
        }

        downloadId = 0L
    }

    fun install(id: Long) {
        val downloadFileUri = downloadManager.getUriForDownloadedFile(id)

        startInstall(
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                FileProvider.getUriForFile(
                    context.applicationContext,
                    context.packageName.toString() + ".FileProvider",
                    File(URI(downloadFileUri.toString()))
                )

            } else {
                downloadFileUri
            }
        )
    }

    private fun install(file: File) {
        startInstall(
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                FileProvider.getUriForFile(
                    context.applicationContext,
                    context.packageName.toString() + ".FileProvider",
                    file
                )

            } else {
                Uri.fromFile(file)
            }
        )
    }

    private fun startInstall(uri: Uri) {
        Intent(Intent.ACTION_VIEW).apply {

            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            // 7.0 以上
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            setDataAndType(
                uri,
                "application/vnd.android.package-archive"
            )

        }.run {
            if (resolveActivity(context.packageManager) != null) {
                try {
                    context.startActivity(this)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }


    companion object {

        var downloadId: Long = 0L
    }
}