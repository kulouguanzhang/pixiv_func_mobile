package me.xiaocao.pixiv

import android.content.IntentFilter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import me.xiaocao.pixiv.platform.api.PlatformApiPlugin
import me.xiaocao.pixiv.platform.webview.PlatformWebViewPlugin
import me.xiaocao.pixiv.update.DownloadReceiver


class MainActivity : FlutterActivity() {
    private val receiver = DownloadReceiver()
    override fun onCreate(savedInstanceState: Bundle?) {
        val intentFilter = IntentFilter()
        intentFilter.addAction("android.intent.action.DOWNLOAD_COMPLETE")
        intentFilter.addAction("android.intent.action.DOWNLOAD_NOTIFICATION_CLICKED")
        registerReceiver(receiver, intentFilter)
        super.onCreate(savedInstanceState)
    }

    override fun onDestroy() {
        unregisterReceiver(receiver)
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        flutterEngine.plugins.add(PlatformWebViewPlugin())
        flutterEngine.plugins.add(PlatformApiPlugin(context))
        super.configureFlutterEngine(flutterEngine)
    }

}
