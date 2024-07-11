import Flutter
import UIKit
import UserNotifications
import alarm
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  if #available(iOS 14.0, *) {
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
  }
    SwiftAlarmPlugin.registerBackgroundTasks()
    GMSServices.provideAPIKey("AIzaSyD4Mqs5tTezA_uU9y4kDyronAGWRmA1MBA")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
