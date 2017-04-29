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
    
    var favTableDictionary:[String:Any]? = nil
    var likeDislikeTableDictionary:[String:Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetUI()
        DBController.shared.setupDB()
        favTableDictionary = DBController.shared.loadFavTableData()
        likeDislikeTableDictionary = DBController.shared.loadLikeDislikeTableData()
        loadDataInUI()
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
    
    func resetUI() {
        resetLikeUnlikeRelatedUI()
        resetFavRelatedUI()
    }
    
    func resetLikeUnlikeRelatedUI() {
        likeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsUpAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
        dislikeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsDownAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
    }
    
    func resetFavRelatedUI() {
        songNameLabel.text = "_"
        animeGameNameLabel.text = "_"
        songArtistLabel.text = "_"
        favoriteButton.setIconImage(withIcon: FontAwesomeIcon.heartEmptyIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
    }
    
    func loadDataInUI() {
        loadFavDataInUI()
        loadLikeUnlikeDataInUI()
    }
    
    func loadFavDataInUI() {
        if let unwrappedFavTableDict = favTableDictionary {
            songNameLabel.text = unwrappedFavTableDict["song_name"] as! String?
            animeGameNameLabel.text = unwrappedFavTableDict["anime_game_name"] as! String?
            songArtistLabel.text = unwrappedFavTableDict["song_artist"] as! String?
            favoriteButton.setIconImage(withIcon: FontAwesomeIcon.heartIcon, size: CGSize(width: 25, height: 25), color: .white, forState: .normal)
        } else {
            resetFavRelatedUI()
        }
        
    }
    
    func loadLikeUnlikeDataInUI() {
        if let unwrappedLikeDislikeTableDict = likeDislikeTableDictionary {
            if unwrappedLikeDislikeTableDict["like_or_dislike"] as! String? == "LIKE" {
                likeButton.setIconImage(withIcon: FontAwesomeIcon._334Icon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                dislikeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsDownAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
            } else if unwrappedLikeDislikeTableDict["like_or_dislike"] as! String? == "DISLIKE" {
                likeButton.setIconImage(withIcon: FontAwesomeIcon.thumbsUpAltIcon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
                dislikeButton.setIconImage(withIcon: FontAwesomeIcon._335Icon, size: CGSize(width: 25, height: 25), color: .white, forState: [])
            }
        } else {
            resetLikeUnlikeRelatedUI()
        }
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
        if let _ = favTableDictionary {
            DBController.shared.removeFavData()
        } else {
            DBController.shared.insertFavData()
        }
        favTableDictionary = DBController.shared.loadFavTableData()
        loadFavDataInUI()
    }

    @IBAction func dislikeButtonTapped() {
        
        if likeDislikeTableDictionary == nil {
            DBController.shared.removeLikeDislikeData()
            DBController.shared.insertLikeDislikeData(likeDislike: "DISLIKE")
            likeDislikeTableDictionary = DBController.shared.loadLikeDislikeTableData()
            loadLikeUnlikeDataInUI()
             ServerController.shared.postLikeDislike(likeDislikeTableDictionary?["song_id"] as! Int64, like_or_dislike: likeDislikeTableDictionary?["like_or_dislike"] as! String)
        }
    }
    
    @IBAction func likeButtonTapped() {
        if likeDislikeTableDictionary == nil {
            DBController.shared.removeLikeDislikeData()
            DBController.shared.insertLikeDislikeData(likeDislike: "LIKE")
            likeDislikeTableDictionary = DBController.shared.loadLikeDislikeTableData()
            loadLikeUnlikeDataInUI()
            ServerController.shared.postLikeDislike(likeDislikeTableDictionary?["song_id"] as! Int64, like_or_dislike: likeDislikeTableDictionary?["like_or_dislike"] as! String)
        }
    }

}

