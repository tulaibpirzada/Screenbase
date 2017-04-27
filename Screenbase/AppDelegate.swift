//
//  AppDelegate.swift
//  Screenbase
//
//  Created by Shree ButBhavani on 14/04/17.
//  Copyright © 2017 VBTechlabs. All rights reserved.
//

import UIKit
import Iconic
import SQLite
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Iconic.registerFontAwesomeIcon()
        setupDB()
        
        return true
    }
    
    func setupDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            let db = try Connection("\(path)/db.sqlite3")
            try createLikeDislikeTable(db)
            try createFavTable(db)
            
            
        } catch {
            print("db creation failed")
        }
    }
    
    func createLikeDislikeTable(_ db: Connection) throws {
        let likeDislikeTable = Table("like_dislike")
        let default_row = Expression<Int64>("default_row")
        let song_id = Expression<Int64>("song_id")
        let like_or_dislike = Expression<String>("like_or_dislike")
        
        try db.run(likeDislikeTable.create { t in
            t.column(default_row, primaryKey: true)
            t.column(song_id, unique: true)
            t.column(like_or_dislike)
        })
    }
    
    func createFavTable(_ db: Connection) throws {
        let favTable = Table("fav")
        let default_row = Expression<Int64>("default_row")
        let song_id = Expression<Int64>("song_id")
        let song_like = Expression<Int64>("song_like")
        let song_dislike = Expression<Int64>("song_dislike")
        let song_highest_score = Expression<Int64>("song_highest_score")
        let song_type = Expression<String>("song_type")
        let song_name = Expression<String>("song_name")
        let anime_game_name = Expression<String>("anime_game_name")
        let song_artist = Expression<String>("song_artist")
        let song_by = Expression<String>("song_by")
        let song_url = Expression<String>("song_url")
        let song_date = Expression<String>("song_date")
        
        try db.run(favTable.create { t in
            t.column(default_row, primaryKey: true)
            t.column(song_id, unique: true)
            t.column(song_like)
            t.column(song_dislike)
            t.column(song_highest_score)
            t.column(song_type)
            t.column(song_name)
            t.column(anime_game_name)
            t.column(song_artist)
            t.column(song_by)
            t.column(song_url)
            t.column(song_date)
        })
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

