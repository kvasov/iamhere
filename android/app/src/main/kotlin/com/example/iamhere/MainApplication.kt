package com.example.iamhere
import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setLocale("ru_RU")
    MapKitFactory.setApiKey("041c74aa-d5d6-4bd0-9406-48151133939e")
  }
}