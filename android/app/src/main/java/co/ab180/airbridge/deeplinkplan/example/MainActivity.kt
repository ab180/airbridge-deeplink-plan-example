package co.ab180.airbridge.deeplinkplan.example

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import co.ab180.airbridge.deeplinkplan.example.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
    }
}