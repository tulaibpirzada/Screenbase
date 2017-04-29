//
//  ViewController.swift
//  Screenbase
//
//  Created by Shree ButBhavani on 14/04/17.
//  Copyright © 2017 VBTechlabs. All rights reserved.
//

import UIKit
import Iconic
import SQLite

class ViewController: UIViewController {

    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var animeGameNameLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bmpLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var leftBarButton = UIBarButtonItem()
    
    @IBOutlet weak var rightBarButton = UIBarButtonItem()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDB()
        loadData()
        ServerController.shared.downloadFile()
        //Iconic.registerFontAwesomeIcon()
        
        
//        leftBarButton = UIBarButtonItem.init(withIcon: FontAwesomeIcon.arrowLeftIcon, size: CGSize(width: 20, height: 20), target: self, action: #selector(leftBarButtonClicked))
//        leftBarButton?.tintColor = UIColor.white
//        
//        rightBarButton = UIBarButtonItem.init(withIcon: FontAwesomeIcon.arrowLeftIcon, size: CGSize(width: 20, height: 20), target: self, action: #selector(leftBarButtonClicked))
//        rightBarButton?.tintColor = UIColor.white
        

        
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(withIcon: FontAwesomeIcon.bar, size: CGSize(width: 20, height: 20), target: self, action: #selector(leftBarButtonClicked))
        
        //leftBarButton = UIBarButtonItem(withIcon: FontAwesomeIcon.backwardIcon, size: CGSize(width: 24, height: 24), target: self, action: #selector(leftBarButtonClicked(_:)))
            //UIBarButtonItem(withIcon: .BookIcon, size: CGSize(width: 24, height: 24), target: self, action: #selector(didTapButton))
            //Iconic.attributedString(withIcon: FontAwesomeIcon.backwardIcon, pointSize: 17.0, color: UIColor.white)
        
    }
    
    func loadData() {
        loadLikeDislikeTableData()
        loadFavTableData()
    }
    
    func loadLikeDislikeTableData() {
        do {
            isDataPresentInLikeDislikeTable = false
            for song in try db.prepare(likeDislikeTable) {
                isDataPresentInLikeDislikeTable = true
                if song[like_or_dislike] == "LIKE" {
                    likeButton.setIconImage(withIcon: FontAwesomeIcon._334Icon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                    dislikeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsDownAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                } else if song[like_or_dislike] == "DISLIKE" {
                    likeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsUpAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                    dislikeButton.setIconImage(withIcon: FontAwesomeIcon._335Icon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                }
            }
            
            if !isDataPresentInLikeDislikeTable {
                likeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsUpAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                dislikeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsDownAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
            }
        } catch {
            print("ERROR")
        }
    }
    
    func loadFavTableData() {
        do {
            isDataPresentInFavTable = false
            for favSong in try db.prepare(favTable) {
                isDataPresentInFavTable = true
                songNameLabel.text = favSong[song_name]
                animeGameNameLabel.text = favSong[anime_game_name]
                songArtistLabel.text = favSong[song_artist]
                favoriteButton.setIconImage(withIcon: FontAwesomeIcon.heartIcon, size: CGSize(width: 25, height: 25), color: .white, forState: .normal)
            }
            
            if !isDataPresentInFavTable {
                songNameLabel.text = "_"
                animeGameNameLabel.text = "_"
                songArtistLabel.text = "_"
                favoriteButton.setIconImage(withIcon: FontAwesomeIcon.heartEmptyIcon, size: CGSize(width: 25, height: 25), color: .white, forState: .normal)
            }
        } catch {
            print("ERROR")
        }
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
    
    func createLikeDislikeTable() throws {
        try db.run(likeDislikeTable.create { t in
            t.column(id, primaryKey: true)
            t.column(song_id, unique: true)
            t.column(like_or_dislike)
        })
    }
    
    func createFavTable() throws {
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

    func leftBarButtonClicked()
    {
        print("Done clicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonTapped() {
        if isDataPresentInFavTable {
            removeFavData()
        } else {
            insertFavData()
        }
        loadFavTableData()
    }

    @IBAction func dislikeButtonTapped() {
        if !isDataPresentInLikeDislikeTable {
            removeLikeDislikeData()
            insertLikeDislikeData(likeDislike: "DISLIKE")
            loadLikeDislikeTableData()
            ServerController.shared.postLikeDislike(2789, like_or_dislike: "DISLIKE")
        }
    }
    
    @IBAction func likeButtonTapped() {
        if !isDataPresentInLikeDislikeTable {
            removeLikeDislikeData()
            insertLikeDislikeData(likeDislike: "LIKE")
            loadLikeDislikeTableData()
            ServerController.shared.postLikeDislike(2789, like_or_dislike: "LIKE")
        }
    }

}

