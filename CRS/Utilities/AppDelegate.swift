//
//  AppDelegate.swift
//  CRS
//
//  Created by John Doe on 2022-11-20.
//

import UIKit
import CoreData
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let cdManager = CoreDataManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB2v-QXnwBcFtEGMmvBf5NJ9SRZVysgv4Y")
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if cdManager.isLogin() {
            setUpHome()
        } else {
            let vc = AuthenticationViewController()
            self.window?.rootViewController = vc
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }

    private func setUpHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        print(cdManager.getUserInfo().company)
        initialViewController.company = cdManager.getUserInfo().company
        let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(initialViewController, animated: false)
        self.window?.rootViewController = navigationController
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CRS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

