package moe.xiaocao.pixiv

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.target.AppWidgetTarget
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import moe.xiaocao.pixiv.platform.appwidget.PlatformAppWidgetPlugin
import org.json.JSONArray

class RecommendAppWidget : AppWidgetProvider() {
    private val latestUpdateAtTag = "latestUpdateAt"
    private val list: ArrayList<IllustInfo> = arrayListOf()

    @SuppressLint("CommitPrefEdits")
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        Log.i("AppWidget", "appWidgetIds: $appWidgetIds")
        val sharedPreferences = context.getSharedPreferences("appwidget", MODE_PRIVATE)
        val latestUpdateAt = sharedPreferences.getLong(latestUpdateAtTag, 0)
        val currentAt = System.currentTimeMillis()
        //list为空 或 上次更新时间已经过去3分钟
        if (list.isEmpty() || latestUpdateAt + (60 * 3 * 1000) < currentAt) {
            sharedPreferences.edit().putLong(latestUpdateAtTag, currentAt).apply()
            PlatformAppWidgetPlugin.refreshRecommend {
                list.clear()
                val jsonArray = JSONArray(it)
                for (i in 0 until jsonArray.length()) {
                    val item = jsonArray.getJSONObject(i)
                    list.add(
                        IllustInfo(
                            id = item.getInt("id"),
                            url = item.getString("url"),
                            data = item.getString("data")
                        )
                    )
                }
                for (i in appWidgetIds.indices) {
                    updateAppWidget(context, appWidgetManager, appWidgetIds[i], list.last())
                    list.removeLast()
                }
            }
        } else {
            for (i in appWidgetIds.indices) {
                updateAppWidget(context, appWidgetManager, appWidgetIds[i], list.last())
                list.removeLast()
            }
        }


    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    data class IllustInfo(
        val id: Int,
        val url: String,
        val data: String,
    )

    companion object {
        const val clickAppWidget = "click_appwidget"
    }
}

@SuppressLint("UnspecifiedImmutableFlag")
internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    illustInfo: RecommendAppWidget.IllustInfo,
) {

    val views = RemoteViews(context.packageName, R.layout.recommend_app_widget)

    val intent = Intent(context, AppWidgetReceiver::class.java)
    intent.action = RecommendAppWidget.clickAppWidget
    intent.putExtra("data", illustInfo.data)

    val pendingIntent = PendingIntent.getBroadcast(context, illustInfo.id, intent, PendingIntent.FLAG_UPDATE_CURRENT)

    views.setOnClickPendingIntent(R.id.appwidget_image, pendingIntent)

    val appWidgetTarget = AppWidgetTarget(context, R.id.appwidget_image, views, appWidgetId)

    Glide.with(context).asBitmap().load(Uri.parse(illustInfo.url)).placeholder(R.drawable.ic_launcher_foreground)
        .error(R.drawable.ic_launcher_foreground)
        .transform(CenterCrop(), RoundedCorners(15)).override(600).into(appWidgetTarget)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}