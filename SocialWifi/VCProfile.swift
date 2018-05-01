//
//  VCProfile.swift
//  SocialWifi
//
//  Created by Ghassen on 4/30/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class VCProfile: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var laFullname: UILabel!
    @IBOutlet weak var UIImageProfileB: UIImageView!
    @IBOutlet weak var laEmail: UILabel!
    @IBOutlet weak var UIImageProfile: UIImageView!
    
    var listOfWifi = [Wifi]()
    var fbuser = FBUser()
    lazy var lazyImage:LazyImage = LazyImage()
    @IBOutlet weak var tvListWifis: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadLocations()
        UIImageProfile.layer.cornerRadius = UIImageProfile.frame.size.width/3
        UIImageProfile.clipsToBounds = true
        UIImageProfileB.addBlur()
        self.laFullname.text = "\(FBUserShare.getFBName()) \(FBUserShare.getFBLast())"
        self.laEmail.text = FBUserShare.getFBEmail()
        
        self.lazyImage.showWithSpinner(imageView: UIImageProfile, url: FBUserShare.getFBPhotoUrl())
        self.lazyImage.showWithSpinner(imageView: UIImageProfileB, url: FBUserShare.getFBPhotoUrl())
        
        tvListWifis.delegate = self
        tvListWifis.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btLogout(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if((FBSDKAccessToken.current()) != nil){
            fbLoginManager.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
    }
    
    
    func LoadLocations(){

        let cm = ConnectionManager(action :"selectfav&id_user=\(FBUserShare.getFBId())")
        print(cm.getURL())
        Alamofire.request(cm.getURL()).responseJSON{ response in
            if let locationsJSON = response.result.value {
                let json =  locationsJSON as! NSArray
                for locationOBJECT in json{
                    let Slocation = locationOBJECT as! Dictionary<String, Any>
                    let slat = Slocation["lat"] as! String
                    let slng = Slocation["lng"] as! String
                    let wifi_pass = Slocation["wifi_pass"] as! String
                    let desc_loc = Slocation["desc_loc"] as! String
                    let img = Slocation["img"] as! String
                    let MAC = Slocation["MAC"] as Any
                    let id = Slocation["id_loc"] as! String
                    let nblike = Slocation["nblike"] as! String
                    let nbdislike = Slocation["nbdislike"] as! String
                    let ssid = Slocation["ssid"] as! String
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC ,nblike: nblike , nbdislike: nbdislike , ssid: ssid)
                    self.listOfWifi.append(w)
                    self.tvListWifis.reloadData()
                }
            }
        }
    }
    
    //Table view load
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfWifi.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWifi:TVCWifi = tableView.dequeueReusableCell(withIdentifier: "cellWifi", for: indexPath) as! TVCWifi
       
        cellWifi.SetWifi(wifi: listOfWifi[indexPath.row])
        
        return cellWifi
    }

}








protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 1) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

extension UIView: Bluring {}
