package moe.xiaocao.pixiv

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.target.AppWidgetTarget
import com.bumptech.glide.request.transition.Transition
import moe.xiaocao.pixiv.platform.appwidget.PlatformAppWidgetPlugin
import org.json.JSONArray

class RecommendAppWidget : AppWidgetProvider() {
    private var serviceStarted = false

    @SuppressLint("CommitPrefEdits")
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        Log.d("AppWidget", "serviceStarted:${serviceStarted}")
        if (!serviceStarted) {
            Log.d("AppWidget", "startService")
            update(context, appWidgetManager, appWidgetIds) {
                context.startService(Intent(context, AppWidgetService::class.java))
            }
            serviceStarted = true
        }
    }


    override fun onEnabled(context: Context) {

    }

    override fun onDisabled(context: Context) {
        context.stopService(Intent(context, AppWidgetService::class.java))
    }

    data class IllustInfo(
        val id: Int,
        val url: String,
        val data: String,
    )

    companion object {
        const val click = "click_illust"
        private val list: ArrayList<IllustInfo> = arrayListOf()

        fun update(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, onComplete: (() -> Unit)) {
            Log.d("AppWidget", "update")
            //list为长度小于appWidgetIds长度
            if (list.size < appWidgetIds.size) {
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
                    onComplete()
                }
            } else {
                for (i in appWidgetIds.indices) {
                    updateAppWidget(context, appWidgetManager, appWidgetIds[i], list.last())
                    list.removeLast()
                }
                onComplete()
            }

        }

        @SuppressLint("UnspecifiedImmutableFlag")
        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            illustInfo: IllustInfo,
        ) {

            val views = RemoteViews(context.packageName, R.layout.recommend_app_widget)

            val intent = Intent(context, AppWidgetReceiver::class.java)
            intent.action = click
            intent.putExtra("data", illustInfo.data)

            val pendingIntent = PendingIntent.getBroadcast(context, illustInfo.id, intent, PendingIntent.FLAG_UPDATE_CURRENT)

            views.setOnClickPendingIntent(R.id.recommend_appwidget_image, pendingIntent)

            val appWidgetTarget = object : AppWidgetTarget(context, R.id.recommend_appwidget_image, views, appWidgetId) {
                override fun onLoadStarted(placeholder: Drawable?) {
                    views.setViewVisibility(R.id.appwidget_progress, View.VISIBLE)
                    views.setViewVisibility(R.id.recommend_appwidget_image, View.GONE)
                }

                override fun onLoadFailed(errorDrawable: Drawable?) {
                    views.setImageViewResource(R.id.recommend_appwidget_image, R.drawable.ic_launcher_foreground)
                    views.setViewVisibility(R.id.recommend_appwidget_image, View.VISIBLE)
                }

                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    views.setViewVisibility(R.id.appwidget_progress, View.GONE)
                    views.setViewVisibility(R.id.recommend_appwidget_image, View.VISIBLE)
                    super.onResourceReady(resource, transition)
                }
            }


            Glide.with(context).asBitmap().load(Uri.parse(illustInfo.url)).placeholder(R.drawable.ic_launcher_foreground)
                .error(R.drawable.ic_launcher_foreground)
                .transform(CenterCrop(), RoundedCorners(15)).override(600).into(appWidgetTarget)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
