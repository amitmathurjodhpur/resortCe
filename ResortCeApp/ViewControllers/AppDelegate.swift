//
//  AppDelegate.swift
//  ResortCeApp
//
//  Created by AJ12 on 12/02/18.
//  Copyright © 2018 AJ12. All rights reserved.
//

import UIKit
import PassKit
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import Stripe
import IQKeyboardManager
import SimplePDF
public struct  User
{
    public static var  iswhichUser = ""
    public static var  restoreBtn = ""
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            ///////////some  changesssssss
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    var window: UIWindow?
    var loginStr : String = ""

    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self as UNUserNotificationCenterDelegate
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        //  print("refresh token call")
        guard let contents = InstanceID.instanceID().token()
            else {
                return
        }
        print("InstanceID token: \(contents)")
        UserDefaults.standard.set(contents, forKey: "DeviceToken")
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    //MARK:- registerApns
    func registerApns(application:UIApplication)
    {
        if #available(iOS 10.0, *)
        {
            let authOptions: UNAuthorizationOptions = [.alert, .sound,.badge]
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
            })
            center.delegate = self
            Messaging.messaging().delegate = (self as MessagingDelegate)
        }
        else
        {
            let notificationType : UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: notificationType, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        //fireBaseConfig()
    }
    //MARK:- FireBaseConfig-
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
       // STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.cqlsys.ResortceNewId"
       // STPPaymentConfiguration.shared().publishableKey = "pk_test_84lEfDytldFCDO6rJasxJTR7"
        
        GMSServices.provideAPIKey("AIzaSyCaBQRFwGRZPKQ2Q5XzEODeTdjMNG9cKiE")
        GMSPlacesClient.provideAPIKey("AIzaSyA6TI1NWtDHnXSEBuiVXeLo_eu7GO4Vy34")
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 20
        GIDSignIn.sharedInstance().clientID = "322547470433-i8168vb1l1pd8a810ndn98ovtjpp7u3g.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       
        self.registerApns(application: application)
        registerForRemoteNotification()
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
         UIApplication.shared.applicationIconBadgeNumber = 0
       // pushToDashBord()
        
        let remoteNotification  = launchOptions?[.remoteNotification]
        
        if (remoteNotification != nil){
            // DataManager.showAlert("SD", "SDSDSD")
            let value = remoteNotification as? [String:Any]
            if let aKey = value?["notification_code"] as? Int {
                if Int(aKey) == 11 {
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        UIView.animate(withDuration: 1, animations: {
                            NotificationCenter.default.post(name: NSNotification.Name("styleUser1"), object: nil)
                            
                        })
                        
                    }
                    
                }
            }
        }
        sleep(3)
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if(loginStr == "FACEBOOK")
    {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
        }
        else if(loginStr == "GOOGLEPLUS")
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return false
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
//        let type = userInfo["notification_code"] as! String
//        print(userInfo)
//        //Booking user Side
//        if type == "11" {
////            let jsonString : NSString = userInfo["body"]! as! NSString
////            let json  = JSON(parseJSON:jsonString as String)
////            //   lodeStyleDetailData(myDictionary: json)
////            NuserId = json["user_id"].stringValue
////            Norder = json["order_id"].stringValue
////            Nrequest_id = json["request_id"].stringValue
////            Nquantity = json["quantity"].stringValue
//        }
        
        NotificationCenter.default.post(name: NSNotification.Name("styleUser1"), object: nil)
        print("dfskhdhfd")
    }
}
@available(iOS 10, *)
extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // completionHandler([.sound, .alert, .badge])
        var userInformation = notification.request.content.userInfo
//        let type = userInformation["notification_code"] as! String
//        // print(userInfo)
//        //Booking user Side
//        if type == "11" {
//            let jsonString : NSString = userInformation["body"]! as! NSString
//            let json  = JSON(parseJSON:jsonString as String)
//            //   lodeStyleDetailData(myDictionary: json)
//           // NuserId = json["user_id"].stringValue
//           // Norder = json["order_id"].stringValue
//            //Nrequest_id = json["request_id"].stringValue
//           // Nquantity = json["quantity"].stringValue
////        }
        
        NotificationCenter.default.post(name: NSNotification.Name("styleUser1"), object: nil)
        print("Notiiiiiiiiiiiiiiiiii")
    }
}

extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices.
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
        //print("%@", remoteMessage.appData)
    }
}


