//
//  AppDelegate.swift
//  Beacon
//
//  Created by Rahul Garg on 20/02/16.
//  Copyright © 2016 Rahul Garg. All rights reserved.
//

import UIKit
//import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        configureBeacon()
        
        //to change status bar text color to white for all views
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //for local notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    
    //MARK: Helper Method
    func configureBeacon() {
        let beaconId = SBKBeaconID(proximityUUID: SBKSensoroDefaultProximityUUID)
        
        SBKBeaconManager.sharedInstance().startRangingBeaconsWithID(beaconId,
                                                                    wakeUpApplication: true)
        
        
        SBKBeaconManager.sharedInstance().requestAlwaysAuthorization()
        
        SBKBeaconManager.sharedInstance().addBroadcastKey("01Y2GLh1yw3+6Aq0RsnOQ8xNvXTnDUTTLE937Yedd/DnlcV0ixCWo7JQ+VEWRSya80yea6u5aWgnW1ACjKNzFnig==")
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(beacon(_:)),
                                                         name:SBKBeaconInRangeStatusUpdatedNotification,
                                                         object:nil)
    }
    
    
    //MARK: NSNotificationCenter Observer Selector Method
    func beacon(notification: NSNotification) {
        let beacon = notification.object as! SBKBeacon
        if (beacon.serialNumber == nil) {
            return
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey(beacon.serialNumber) {
            return
        }
        
        /*if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            if (beacon.inRange) {
                let notification = UILocalNotification()
                let message = NSString(format: "\u{0001F603} IN: \(beacon.serialNumber)")
                notification.alertBody = message as String
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            else{
                let notification = UILocalNotification()
                let message = NSString(format: "\u{0001F603} OUT: \(beacon.serialNumber)")
                notification.alertBody = message as String
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            
        }
        else{
            if (beacon.inRange) {
                print(beacon.serialNumber)
                let message = NSString(format: "\(beacon.serialNumber)")
                SVProgressHUD.showImage(nil,
                                        status: message as String)
            }
            else{
                let message = NSString(format: "\(beacon.serialNumber)")
                SVProgressHUD.showImage(nil,
                                        status: message as String)
            }
        }*/
    }
}

