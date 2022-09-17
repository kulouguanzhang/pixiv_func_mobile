package moe.xiaocao.pixiv.platform.appwidget

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import moe.xiaocao.pixiv.util.newThreadFunc
import kotlin.concurrent.thread


class PlatformAppWidgetPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        private lateinit var messageChannel: BasicMessageChannel<Any>
        val mutex: Mutex = Mutex(true)
        fun refreshRecommend(callback: (data: String) -> Unit) {
            //还没初始化(App还没启动)
            if (mutex.isLocked) {
                thread {
                    runBlocking {
                        mutex.withLock {
                            Handler(Looper.getMainLooper()).post {
                                messageChannel.send(mapOf("action" to "refreshRecommend")) { result ->
                                    callback(result!! as String)
                                }
                            }
                        }
                    }
                }
            } else {
                messageChannel.send(mapOf("action" to "refreshRecommend")) { result ->
                    callback(result!! as String)
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
        runBlocking {
            mutex.unlock()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

    }
}