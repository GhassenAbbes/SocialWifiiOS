//
//  TVCWifi.swift
//  SocialWifi
//
//  Created by Ghassen on 5/1/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit

class TVCWifi: UITableViewCell {
    lazy var lazyImage:LazyImage = LazyImage()
    @IBOutlet weak var ivWifiImage: UIImageView!
    @IBOutlet weak var laWifiDesc: UILabel!
    @IBOutlet weak var laWifiSsid: UILabel!
    @IBOutlet weak var laWifiDislike: UILabel!
    @IBOutlet weak var laWifiPassword: UILabel!
    @IBOutlet weak var laWifiLike: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var infoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetWifi(wifi:Wifi){
        self.laWifiDesc.text = wifi.desc_loc
        self.laWifiSsid.text = wifi.ssid
        self.laWifiDislike.text = wifi.nbdislike
        self.laWifiPassword.text = wifi.wifi_pass
        self.laWifiLike.text = wifi.nblike
        if wifi.img != "null"{
           self.lazyImage.showWithSpinner(imageView: ivWifiImage, url: wifi.img)
        }else{
            ivWifiImage.image = #imageLiteral(resourceName: "wifihotspot")
        }
        
    }
    
    func SetWifi(wifi:WifiDB){
        self.laWifiDesc.text = wifi.img
        self.laWifiSsid.text = wifi.ssid
        self.laWifiDislike.text = wifi.dislikes
        self.laWifiPassword.text = wifi.pw
        self.laWifiLike.text = wifi.likes
        ivWifiImage.image = #imageLiteral(resourceName: "wifihotspot")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
