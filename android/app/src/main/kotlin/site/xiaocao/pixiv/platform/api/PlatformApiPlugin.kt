/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:PlatformApiPlugin.kt
 * 创建时间:2021/9/5 下午4:48
 * 作者:小草
 */

package site.xiaocao.pixiv.platform.api

import android.content.Context
import android.os.Handler
import android.os.Looper
import kotlin.concurrent.thread
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class PlatformApiPlugin(context: Context) : FlutterPlugin,
    MethodChannel.MethodCallHandler {

    private val api = PlatformApi(context)

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MethodChannel(
            binding.binaryMessenger,
            api.pluginName
        ).also {
            it.setMethodCallHandler(this)
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PlatformApi.Method.SAVE_IMAGE.value -> {
                thread {
                    val rs = api.saveImage(
                        call.argument<ByteArray>("imageBytes")!!,
                        call.argument<String>("filename")!!
                    )
                    Handler(Looper.getMainLooper()).post {
                        result.success(rs)
                    }
                }
            }
            PlatformApi.Method.SAVE_GIF_IMAGE.value -> {
                thread {
                    val rs = api.saveGifImage(
                        call.argument<Int>("id")!!,
                        call.argument<List<ByteArray>>("images")!!,
                        call.argument<List<Int>>("delays")!!
                    )
                    Handler(Looper.getMainLooper()).post {
                        result.success(rs)
                    }
                }
            }
            PlatformApi.Method.UN_ZIP_GIF.value -> {
                thread {
                    val rs = api.unZipGif(call.argument<ByteArray>("zipBytes")!!)
                    Handler(Looper.getMainLooper()).post {
                        result.success(rs)
                    }
                }
            }
            PlatformApi.Method.IMAGE_IS_EXIST.value -> {
                result.success(api.imageIsExist(call.argument<String>("filename")!!))
            }
            PlatformApi.Method.TOAST.value -> {
                api.toast(
                    call.argument<String>("content")!!,
                    call.argument<Boolean>("isLong")!!
                )
                result.success(true)
            }
            PlatformApi.Method.GET_BUILD_VERSION.value -> {
                result.success(api.getBuildVersion())
            }
            PlatformApi.Method.GET_APP_VERSION.value -> {
                result.success(api.getAppVersion())
            }
            PlatformApi.Method.URL_LAUNCH.value -> {
                result.success(api.urlLaunch(call.argument<String>("url")!!))
            }
            PlatformApi.Method.UPDATE_APP.value -> {
                result.success(
                    api.updateApp(
                        call.argument<String>("url")!!,
                        call.argument<String>("versionTag")!!,
                    )
                )
            }
            else -> {
                result.notImplemented()
            }
        }

    }

}
