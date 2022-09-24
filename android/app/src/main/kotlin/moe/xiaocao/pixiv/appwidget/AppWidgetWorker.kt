package moe.xiaocao.pixiv.appwidget

import android.annotation.SuppressLint
import android.content.Context
import androidx.work.*
import moe.xiaocao.pixiv.appwidget.provider.RecommendAppWidget
import java.util.concurrent.TimeUnit

class AppWidgetWorker(val context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {
    override fun doWork(): Result {

        return try {
            if (updateWidget()) {
                Result.success()
            } else {
                Result.retry()
            }

        } catch (e: Exception) {
            //异常了不处理 等待下一次任务
            Result.success()
        }
    }

    private fun updateWidget(): Boolean {
        return RecommendAppWidget.update(context)
    }

    companion object {

        fun enqueueUniquePeriodic(context: Context) {
            //15-20分钟一次
            val worker =
                PeriodicWorkRequest.Builder(AppWidgetWorker::class.java, 20, TimeUnit.MINUTES, 15, TimeUnit.MINUTES).setConstraints(
                    Constraints.Builder().also {
                        //网络已连接
                        it.setRequiredNetworkType(NetworkType.CONNECTED)
                        //待机状态下执行
                        it.setRequiresDeviceIdle(true)

                    }.build()
                ).build()
            WorkManager.getInstance(context).enqueueUniquePeriodicWork("AppWidgetAutoRefresh", ExistingPeriodicWorkPolicy.KEEP, worker)
        }

        fun cancelUnique(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork("AppWidgetAutoRefresh")
        }
    }

}