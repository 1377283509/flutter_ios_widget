import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller:FlutterViewController = window?.rootViewController as! FlutterViewController
    
    let userDefaults = UserDefaults.init(suiteName: "group.com.cc.ToDo")
    userDefaults!.setValue("defaultID", forKey: "userid")
    userDefaults!.setValue("defauleName", forKey: "author")
    WidgetMenthod.init(messger: controller.binaryMessenger)
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


class WidgetMenthod{
    init(messger:FlutterBinaryMessenger){
        let channel = FlutterMethodChannel(name: "com.cc.ToDo.widgets", binaryMessenger: messger)
        channel.setMethodCallHandler{(call:FlutterMethodCall, result: @escaping FlutterResult) in
            print(call)
            if(call.method == "updateWidgetData"){
                print("update...")
                if let dict = call.arguments as? Dictionary<String,Any>{
                    let userid = dict["userid"] as? String
                    let author = dict["author"] as? String
                    print("\(userid) ==== \(author)")
                    let userDefaults = UserDefaults.init(suiteName: "group.com.cc.ToDo")
                    userDefaults!.setValue(userid, forKey: "userid")
                    userDefaults!.setValue(author, forKey: "author")
                    if #available(iOS 14.0, *) {
                        print("reload timelines")
                        WidgetCenter.shared.reloadTimelines(ofKind: "todo_list")
                        print("reload complete!")
                        result(["code":1,"msg":"success"])
                    } else {
                        // Fallback on earlier versions
                        result(["code":0,"msg":"系统版本过低"])
                    }
                }else{
                    // 参数类型错误
                    result(["code":0,"msg":"参数异常"])
                }
            }
        }
    }
}

