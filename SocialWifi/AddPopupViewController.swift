//
//  AddPopupViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 3/31/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit

class AddPopupViewController: UIViewController {

    var lat:String?
    var lng:String?
    @IBOutlet weak var SSIDText: UITextField!
    @IBOutlet weak var PWText: UITextField!
    @IBOutlet weak var SaveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        print (lat)
        dismiss(animated: true)
    }
}
