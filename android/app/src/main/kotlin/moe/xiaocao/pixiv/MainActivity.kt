package moe.xiaocao.pixiv

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import moe.xiaocao.pixiv.platform.api.PlatformApiPlugin
import moe.xiaocao.pixiv.platform.appwidget.PlatformAppWidgetPlugin
import moe.xiaocao.pixiv.platform.webview.PlatformWebViewPlugin


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        flutterEngine.plugins.add(PlatformWebViewPlugin())
        flutterEngine.plugins.add(PlatformApiPlugin(context))
        flutterEngine.plugins.add(PlatformAppWidgetPlugin(context))

        super.configureFlutterEngine(flutterEngine)
    }

}
