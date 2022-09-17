package moe.xiaocao.pixiv

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import moe.xiaocao.pixiv.platform.appwidget.PlatformAppWidgetPlugin

class AppWidgetReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        Log.i("CAO", intent.action.toString())
        if (RecommendAppWidget.clickAppWidget == intent.action) {
            context.startActivity(Intent(context, MainActivity::class.java))
            PlatformAppWidgetPlugin.clickAppWidget(intent.getStringExtra("data")!!)
        }
    }
}