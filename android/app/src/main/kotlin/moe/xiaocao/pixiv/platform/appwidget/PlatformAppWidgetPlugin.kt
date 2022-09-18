package moe.xiaocao.pixiv.platform.appwidget

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import kotlin.concurrent.thread


class PlatformAppWidgetPlugin(val context: Context) : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        private lateinit var messageChannel: BasicMessageChannel<Any>
        var init = false
        fun refreshRecommend(callback: (data: String) -> Unit) {
            //还没初始化(App还没启动)

            thread {
                while (!init) {
                    Thread.sleep(100)
                }
                Handler(Looper.getMainLooper()).post {
                    messageChannel.send(mapOf("action" to "refreshRecommend")) { result ->
                        callback(result!! as String)
                    }
                }
            }

        }

        fun clickAppWidget(data: String) {
            messageChannel.send(mapOf("action" to "clickAppWidget", "data" to data))
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        messageChannel = BasicMessageChannel(
            binding.binaryMessenger,
            "xiaocao/platform/appwidget/message",
            StandardMessageCodec()
        )
        init = true
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

    }
}