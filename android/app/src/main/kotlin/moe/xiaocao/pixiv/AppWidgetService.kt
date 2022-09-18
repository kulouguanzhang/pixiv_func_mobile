package moe.xiaocao.pixiv

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.app.Service
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.*
import android.util.Log

class AppWidgetService : Service() {
    private var updateHandler: UpdateHandler? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    companion object {
        private const val alarmDuration = 5 * 60 * 1000 // service 自启间隔

        //10分钟更新一次
        private const val updateDuration = 60 * 10 * 1000L

        private const val updateMessageCode = 444444444
    }

    override fun onCreate() {
        Log.d("AppWidgetService", "onCreate")
        delayedUpdate()
        super.onCreate()
    }

    private fun delayedUpdate() {

        if (null == updateHandler) {
            updateHandler = UpdateHandler(HandlerThread("AppWidgetServiceUpdateHandler").also { it.start() }.looper) { updateWidget() }
        }

        updateHandler!!.let {
            val message = it.obtainMessage()
            message.what = updateMessageCode
            it.sendMessageDelayed(message, updateDuration)
        }
    }

    private fun updateWidget() {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val ids = appWidgetManager.getAppWidgetIds(ComponentName(this, RecommendAppWidget::class.java))
        RecommendAppWidget.update(this, appWidgetManager, ids) {
            delayedUpdate()
        }
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val manager: AlarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val alarmIntent = Intent(baseContext, AppWidgetService::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getService(
            baseContext, 0,
            alarmIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )

        manager.set(
            AlarmManager.ELAPSED_REALTIME_WAKEUP,
            SystemClock.elapsedRealtime() + alarmDuration, pendingIntent
        )

        return START_STICKY
    }

    internal class UpdateHandler(looper: Looper, val updateWidget: () -> Unit) : Handler(looper) {
        override fun handleMessage(msg: Message) {

            when (msg.what) {
                updateMessageCode -> updateWidget()
                else -> {}
            }
        }
    }

}