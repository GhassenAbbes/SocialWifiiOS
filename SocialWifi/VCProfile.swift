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
class VCProfile: UIViewController {

    @IBOutlet weak var laFullname: UILabel!
    @IBOutlet weak var UIImageProfileB: UIImageView!
    @IBOutlet weak var laEmail: UILabel!
    @IBOutlet weak var UIImageProfile: UIImageView!
    var fbuser = FBUser()
    lazy var lazyImage:LazyImage = LazyImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedFB()
        UIImageProfile.layer.cornerRadius = UIImageProfile.frame.size.width/3
        UIImageProfile.clipsToBounds = true
        UIImageProfileB.addBlur()
        
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
    
    func sharedFB (){
        let preferences = UserDefaults.standard
        let name:String = preferences.string(forKey: "name")!
        let last:String = preferences.string(forKey: "lastname")!
        let email:String = preferences.string(forKey: "email")!
        let photo:String = preferences.string(forKey: "photo")!
        print(photo)
        self.laFullname.text = "\(name) \(last)"
        self.laEmail.text = "\(String(describing: email))"
        
        self.lazyImage.showWithSpinner(imageView: UIImageProfile, url: photo)
        self.lazyImage.showWithSpinner(imageView: UIImageProfileB, url: photo)
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

// Conformance
extension UIView: Bluring {}
