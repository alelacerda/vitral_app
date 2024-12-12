import Flutter
import SwiftUI
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let registrar = self.registrar(forPlugin: "ARView")
    let factory = SwiftUIViewFactory()
    registrar!.register(factory, withId: "ARView")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class SwiftUIViewFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return SwiftUIViewController()
  }
}

class SwiftUIViewController: NSObject, FlutterPlatformView {
  func view() -> UIView {
      return UIHostingController(rootView: ContentView()).view
  }
}
