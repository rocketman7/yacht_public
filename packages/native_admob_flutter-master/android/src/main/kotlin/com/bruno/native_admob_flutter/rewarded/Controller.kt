package com.bruno.native_admob_flutter.rewarded

import android.app.Activity
import com.bruno.native_admob_flutter.RequestFactory
import com.bruno.native_admob_flutter.encodeError
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import com.google.android.gms.ads.rewarded.ServerSideVerificationOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RewardedAdController(
        val id: String,
        val channel: MethodChannel,
        private val activity: Activity
) : MethodChannel.MethodCallHandler {

    private var rewardedAd: RewardedAd? = null

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadAd" -> {
                channel.invokeMethod("loading", null)
                val unitId: String = call.argument<String>("unitId")!!
                val nonPersonalizedAds = call.argument<Boolean>("nonPersonalizedAds")!!
                val keywords = call.argument<List<String>>("keywords")!!
                val options: ServerSideVerificationOptions.Builder = ServerSideVerificationOptions.Builder()
                val ssv = call.argument<Map<String, Any>>("ssv")
                if (ssv != null) {
                    val userId = ssv["userId"] as String?
                    val customData = ssv["customData"] as String?
                    if (userId != null) {
                        options.setUserId(userId)
                    }
                    if (customData != null) {
                        options.setCustomData(customData)
                    }
                }
                RewardedAd.load(activity, unitId, RequestFactory.createAdRequest(nonPersonalizedAds, keywords), object : RewardedAdLoadCallback() {
                    override fun onAdLoaded(ad: RewardedAd) {
                        ad.setServerSideVerificationOptions(options.build())
                        rewardedAd = ad
                        channel.invokeMethod("onAdLoaded", null)
                        result.success(true)
                    }
                    override fun onAdFailedToLoad(error: LoadAdError) {
                        channel.invokeMethod("onAdFailedToLoad", encodeError(error))
                        result.success(false)
                    }
                })
            }
            "show" -> {
                if (rewardedAd == null) return result.success(false)
                rewardedAd!!.fullScreenContentCallback = object : FullScreenContentCallback() {
                    override fun onAdDismissedFullScreenContent() {
                        channel.invokeMethod("onAdDismissedFullScreenContent", null)
                        result.success(true)
                    }

                    override fun onAdFailedToShowFullScreenContent(error: AdError?) {
                        channel.invokeMethod("onAdFailedToShowFullScreenContent", encodeError(error))
                        result.success(false)
                    }

                    override fun onAdShowedFullScreenContent() {
                        rewardedAd = null
                        channel.invokeMethod("onAdShowedFullScreenContent", null)
                    }
                }
                rewardedAd!!.show(activity) { reward ->
                    channel.invokeMethod("onUserEarnedReward", hashMapOf<String, Any>(
                            "amount" to reward.amount,
                            "type" to reward.type
                    ))
                }
            }
            else -> result.notImplemented()
        }
    }

}

object RewardedAdControllerManager {
    private val controllers: ArrayList<RewardedAdController> = arrayListOf()

    fun createController(id: String, binaryMessenger: BinaryMessenger, activity: Activity): RewardedAdController {
        if (getController(id) == null) {
            val methodChannel = MethodChannel(binaryMessenger, id)
            val controller = RewardedAdController(id, methodChannel, activity)
            controllers.add(controller)
            return controller
        }
        return getController(id)!!
    }

    private fun getController(id: String): RewardedAdController? {
        return controllers.firstOrNull { it.id == id }
    }

    fun removeController(id: String) {
        val index = controllers.indexOfFirst { it.id == id }
        if (index >= 0) controllers.removeAt(index)
    }
}