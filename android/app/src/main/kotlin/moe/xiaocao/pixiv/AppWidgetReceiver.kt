package moe.xiaocao.pixiv

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.Toast
import moe.xiaocao.pixiv.platform.appwidget.PlatformAppWidgetPlugin

class AppWidgetReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            RecommendAppWidget.click -> {
                context.startActivity(context.packageManager.getLaunchIntentForPackage(context.packageName))
                PlatformAppWidgetPlugin.clickAppWidget(intent.getStringExtra("data")!!)
            }
            RefreshAppWidget.click -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val ids = appWidgetManager.getAppWidgetIds(ComponentName(context, RecommendAppWidget::class.java))
                RecommendAppWidget.update(context, appWidgetManager, ids) {
                    Toast.makeText(context, "已刷新", Toast.LENGTH_LONG).show()
                }
            }
        }

    }


}