import Flutter
import SwiftUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if let registrar = self.registrar(forPlugin: "ARView") {
            let factory = SwiftUIViewFactory(messenger: registrar.messenger())
            registrar.register(factory, withId: "ARView")
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class SwiftUIViewFactory: NSObject, FlutterPlatformViewFactory {
    private weak var messenger: FlutterBinaryMessenger?

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return SwiftUIViewController(messenger: messenger)
    }
}

class SwiftUIViewController: NSObject, FlutterPlatformView {
    private let messenger: FlutterBinaryMessenger?

    init(messenger: FlutterBinaryMessenger?) {
        self.messenger = messenger
    }

    func view() -> UIView {
        let channel = FlutterMethodChannel(name: "ar_view_channel", binaryMessenger: messenger!)
        return UIHostingController(rootView: StainedGlassView(channel: channel)).view
    }
}
