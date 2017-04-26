//
//  ViewController.swift
//  Screenbase
//
//  Created by Shree ButBhavani on 14/04/17.
//  Copyright © 2017 VBTechlabs. All rights reserved.
//

import UIKit
import Iconic

class ViewController: UIViewController {

    
    @IBOutlet weak var leftBarButton = UIBarButtonItem()
    
    @IBOutlet weak var rightBarButton = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

    func leftBarButtonClicked()
    {
        print("Done clicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

