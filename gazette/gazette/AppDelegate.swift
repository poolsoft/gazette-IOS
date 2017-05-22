//
//  AppDelegate.swift
//  gazette
//
//  Created by Alireza Ghias on 2/2/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		Dao.setup()
		configAppearance()
		configPushNotification(application)
		return true
	}
	func configPushNotification(_ application: UIApplication) {
		let notificationSettings = UIUserNotificationSettings(
			types: [.badge, .sound, .alert], categories: nil)
		if #available(iOS 10, *) {
			UNUserNotificationCenter.current().delegate = self
			UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (success, error) in
				if (success) {
					application.registerForRemoteNotifications()
				}
			})
			
		} else {
			application.registerUserNotificationSettings(notificationSettings)
		}
	}
	func configAppearance() {
		let pageControl = UIPageControl.appearance()
		pageControl.pageIndicatorTintColor = ColorPalette.Accent
		pageControl.currentPageIndicatorTintColor = ColorPalette.DarkAccent
		pageControl.backgroundColor = UIColor.clear
		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textAlignment = .right
		UITabBar.appearance().tintColor = ColorPalette.Accent
		UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : AppFont.withSize(Dimensions.TextTiny)], for: UIControlState())
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = AppFont.withSize(Dimensions.TextSmall)
		UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = AppFont.withSize(Dimensions.TextSmall)
		
		UILabel.appearance().defaultFont = AppFont.font()
		UITextField.appearance().defaultFont = AppFont.font()
		UITextView.appearance().defaultFont = AppFont.font()
		
		AppDelegate.changeLang()
		if  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView {
			statusBar.backgroundColor = ColorPalette.Actionbar
		}		
	}
	static func changeLang() {
		let targetLang = UserDefaults.standard.object(forKey: "selectedLanguage") as? String
		IOSUtil.lang = targetLang ?? "Base"
		Bundle.setLanguage(IOSUtil.lang)
	}
	
	func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
		if notificationSettings.types != UIUserNotificationType() {
			application.registerForRemoteNotifications()
		}
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
		var tokenString = ""
		for i in 0..<deviceToken.count {
			tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
		}
		if !CurrentUser.token.isEmpty {
			RestHelper.request(.post, json: false, command: "updateCid", params: ["token":CurrentUser.token, "cid":tokenString], onComplete: { (_) in
				
			}) { (_, _) in
				
			}
		}
		
		
	}
 
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register:", error)
	}
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		notifProcess(response.notification.request.content.userInfo)
	}
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .badge, .sound])
	}
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		notifProcess(userInfo)
	}
	
	func notifProcess(_ userInfo: [AnyHashable : Any]?) {
		if userInfo != nil {
			if let json = userInfo!["json"] as? String {
				if let vc = UIApplication.shared.keyWindow?.rootViewController {
					var presentedVC = vc.presentedViewController
					var nextP = vc.presentedViewController
					while (nextP != nil)
					{
						presentedVC = nextP
						nextP = nextP!.presentedViewController
						
					}
					if presentedVC != nil {
						if presentedVC!.isKind(of: UINavigationController.self) {
							presentedVC = (presentedVC as! UINavigationController).topViewController
						}
						if let data = json.data(using: .utf8) {
							if let map = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
								let transactionDao = TransactionDao()
								let t = Transaction()
								t.update(map)
								if transactionDao.findByTxId(t.transactionId) == nil {
									transactionDao.save({ (Void) -> Transaction in
										return t
									})
									if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
										presentedVC?.navigationController?.pushViewController(controller, animated: true)
									}
								}
							}
						}
					}
				}
			}
		}
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
	}


}

