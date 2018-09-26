//
//  AppDelegate.swift
//  idtp
//
//  Created by Apple on 16.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, APIServiceSharier, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var sharedAPIService = APIService()
    
    var notificationsHandler = NotificationsHandler()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.setDefaultMaskType(.black)
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:  [.alert, .badge, .sound]) { (res, err) in }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        YMKConfiguration.sharedInstance().apiKey = "fEg5rer4wLsnXeHWivwtSILDd2bEZHpmy9j6tbjYAa6Sp6TCtG45HN471KkEATAu6PWFBQdMpwzVySnqdNq01-xgoKpGPbB~ghxWeveyajY="
        
        return true
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("Will Present:")
        print(userInfo)
        
        let msgType = Int(userInfo["msg_type"]! as! String)!
        let msgTitle : String = userInfo["title"]! as! String
        let msgBody : String = userInfo["body"]! as! String
        let msgExtra : String = userInfo["extra"]! as! String
        let msgValues : String = userInfo["values"]! as! String
        
        notificationsHandler.handleMessage(msgType: msgType,
                                           msgTitle: msgTitle,
                                           msgBody: msgBody,
                                           msgValues: msgValues,
                                           msgExtra: msgExtra)
        
        if let rootViewController = self.window?.rootViewController {
            rootViewController.navigationController?.popToRootViewController(animated: true)
        }
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print("Did Recieve Responce:")
        print(userInfo)
        
        completionHandler()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistenceService.saveContext()
    }
}

