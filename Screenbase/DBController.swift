//
//  DBController.swift
//  Screenbase
//
//  Created by Taskeen Ashraf on 4/29/17.
//  Copyright © 2017 VBTechlabs. All rights reserved.
//

import Foundation
import SQLite

class DBController {
    
    static let shared = DBController()
    
    var db: Connection!
    let favTable = Table("fav")
    let likeDislikeTable = Table("like_dislike")
    
    let id = Expression<Int64>("id")
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
    let like_or_dislike = Expression<String>("like_or_dislike")
    
    var isDataPresentInFavTable = false
    var isDataPresentInLikeDislikeTable = false
    
    private init()
    {
        NSLog("Singleton Initialized")
    }
    
    func setupDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createLikeDislikeTable()
            try createFavTable()
            
            
        } catch {
            print("db creation failed")
        }
    }
    
    fileprivate func createLikeDislikeTable() throws {
        try db.run(likeDislikeTable.create { t in
            t.column(id, primaryKey: true)
            t.column(song_id, unique: true)
            t.column(like_or_dislike)
        })
    }
    
    fileprivate func createFavTable() throws {
        try db.run(favTable.create { t in
            t.column(id, primaryKey: true)
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
    
    func loadLikeDislikeTableData() -> [String:Any]? {
        do {
            var dataDictionary: [String:Any]? = nil
            for song in try db.prepare(likeDislikeTable) {
                dataDictionary = [:]
                dataDictionary?["is_data_present"] = true
                dataDictionary?["song_id"] = song[song_id]
                dataDictionary?["like_or_dislike"] = song[like_or_dislike]
                return dataDictionary
            }
        } catch {
            print("ERROR")
        }
        return nil
    }
    
    func loadFavTableData() -> [String:Any]? {
        do {
            var dataDictionary: [String:Any]? = nil
            for favSong in try db.prepare(favTable) {
                dataDictionary = [:]
                dataDictionary?["is_data_present"] = true
                dataDictionary?["song_id"] = favSong[song_id]
                dataDictionary?["song_name"] = favSong[song_name]
                dataDictionary?["anime_game_name"] = favSong[anime_game_name]
                dataDictionary?["song_artist"] = favSong[song_artist]
                return dataDictionary
            }
        } catch {
            print("ERROR")
        }
        return nil
    }
    
    func insertFavData() {
        let insert = favTable.insert(song_id <- 2789, song_type <- "song_type",
                                     song_name <- "song_name", anime_game_name <- "anime_game_name",
                                     song_artist <- "song_artist", song_by <- "song_by",
                                     song_url <- "song_url", song_like <- 0,
                                     song_dislike <- 0, song_date <- "song_date",
                                     song_highest_score <- 0)
        do {
            let _ = try db.run(insert)
        } catch {
            print("Error during inserting data")
        }
    }
    
    func insertLikeDislikeData(likeDislike: String) {
        let insert = likeDislikeTable.insert(song_id <- 2789, like_or_dislike <- likeDislike)
        do {
            let _ = try db.run(insert)
        } catch {
            print("Error during inserting data")
        }
    }
    
    func removeFavData() {
        let favSong = favTable.filter(id == 1)
        do {
            let _ = try db.run(favSong.delete())
        } catch {
            print("Error during deleting data")
        }
    }
    
    func removeLikeDislikeData() {
        let song = likeDislikeTable.filter(id == 1)
        do {
            let _ = try db.run(song.delete())
        } catch {
            print("Error during deleting data")
        }
    }
}
