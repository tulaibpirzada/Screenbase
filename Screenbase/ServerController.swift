//
//  ServerController.swift
//  Screenbase
//
//  Created by Taskeen Ashraf on 4/29/17.
//  Copyright © 2017 VBTechlabs. All rights reserved.
//

import Foundation
import Alamofire

class ServerController {
    
    static let shared = ServerController()
    
    private init()
    {
        NSLog("Singleton Initialized")
    }
    
    func downloadFile() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("test.mid")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        if (UserDefaults.standard.string(forKey: "FILE_PATH") != nil) {
            print("Image Path: \(UserDefaults.standard.string(forKey: "FILE_PATH"))")
        } else {
            Alamofire.download("https://pianopick.s3.amazonaws.com/pianoTilesSuperOnline/1491791162-test.mid", to: destination).responseData { response in
                if response.error == nil, let imagePath = response.destinationURL?.path {
                    UserDefaults.standard.set(imagePath, forKey: "FILE_PATH")
                    print("Image Path: \(imagePath)")
                }
            }
        }
    }
    
    func postLikeDislike(_ song_id: Int, like_or_dislike: String) {
        let parameters: Parameters = [
            "song_id": song_id,
            "like_or_dislike": like_or_dislike,
        ]

        Alamofire.request("https://pianopick.com/uploadMidi/midiPage/like_dislike.php", method: .post, parameters: parameters).responseData {_ in 
            print("data posted")
        }
    }
}
