package co.ab180.airbridge.deeplinkplan

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Patterns
import android.widget.Toast
import androidx.annotation.DrawableRes
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import co.ab180.airbridge.Airbridge
import co.ab180.airbridge.deeplinkplan.databinding.ActivityMainBinding
import co.ab180.airbridge.deeplinkplan.databinding.DialogInfoBinding
import androidx.core.net.toUri

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        initUi()

        // handle airbridge deferred deeplink
        val isHandled = Airbridge.handleDeferredDeeplink { uri ->
            // when app is opened with deferred deeplink
            // show proper content using url
            uri?.let {
                showDialog(
                    title = getString(R.string.title_deferred_deeplink),
                    message = uri.toString()
                )
            }
        }
    }

    override fun onResume() {
        super.onResume()

        // handle airbridge deeplink
        val isHandled = Airbridge.handleDeeplink(intent) { uri ->
            // when app is opened with airbridge deeplink
            // show proper content using url (YOUR_SCHEME://...)
            showDialog(
                title = getString(R.string.title_deeplink),
                message = uri.toString()
            )
        }
        if (isHandled) return

        // when app is opened with other deeplink
        // use existing logic as it is
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    private fun initUi() {
        binding.airbridgeAppName.text = BuildConfig.AIRBRIDGE_APP_NAME
        binding.airbridgeAppToken.text = BuildConfig.AIRBRIDGE_APP_TOKEN

        "${BuildConfig.AIRBRIDGE_APP_NAME}.abr.ge".let {
            binding.airbridgeAppLinks1Label.text = it
            binding.airbridgeAppLinks1Status.setImageResource(getAppLinkStatus(it))
        }
        "${BuildConfig.AIRBRIDGE_APP_NAME}.airbridge.io".let {
            binding.airbridgeAppLinks2Label.text = it
            binding.airbridgeAppLinks2Status.setImageResource(getAppLinkStatus(it))
        }
    }

    private fun showDialog(title: String, message: String) {
        val dialogInfoBinding = DialogInfoBinding.inflate(layoutInflater)
        dialogInfoBinding.dialogTitle.text = title
        dialogInfoBinding.dialogMessage.text = message

        AlertDialog.Builder(this)
            .setView(dialogInfoBinding.root)
            .setCancelable(true)
            .setNeutralButton(getString(R.string.copy), null)
            .setPositiveButton(getString(R.string.ok), null)
            .create()
            .apply {
                show()
                getButton(AlertDialog.BUTTON_NEUTRAL)?.setOnClickListener {
                    val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val clip = ClipData.newPlainText(getString(R.string.clipboard_label), message)
                    clipboard.setPrimaryClip(clip)
                    Toast.makeText(
                        this@MainActivity,
                        getString(R.string.toast_copy_to_clipboard),
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
    }

    @DrawableRes
    private fun getAppLinkStatus(host: String): Int {
        val urlString = "https://$host"
        if (!Patterns.WEB_URL.matcher(urlString).matches()) {
            return R.drawable.ic_unverified_24dp
        }
        val intent = Intent(Intent.ACTION_VIEW, urlString.toUri()).apply {
            addCategory(Intent.CATEGORY_BROWSABLE)
        }
        val handled = packageManager
            .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
            .any { it.activityInfo.packageName == packageName }
        return if (handled) R.drawable.ic_verified_24dp else R.drawable.ic_unverified_24dp
    }
}