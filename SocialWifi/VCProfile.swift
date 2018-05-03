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
import CoreData

class VCProfile: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var laFullname: UILabel!
    @IBOutlet weak var UIImageProfileB: UIImageView!
    @IBOutlet weak var laEmail: UILabel!
    @IBOutlet weak var UIImageProfile: UIImageView!
    @IBOutlet weak var tvListWifis: UITableView!

    @IBOutlet weak var tabController: UISegmentedControl!
    var listOfWifi = [Wifi]()
    var fbuser = FBUser()
    lazy var lazyImage:LazyImage = LazyImage()
    var offlineData = [WifiDB]()

    
    @IBAction func tabAction(_ sender: Any) {
        self.listOfWifi.removeAll()
        self.offlineData.removeAll()
        self.tvListWifis.reloadData()
        if tabController.selectedSegmentIndex == 0 {
            
            if Reachability.isConnectedToNetwork(){
               LoadAdds()
            }else {
                self.view.makeToast("No internet found 😞")
            }
        }else {
             if Reachability.isConnectedToNetwork(){
                LoadFavs()
             }else {
               
                self.view.makeToast("No internet found 😞")
                let fetchrequest:NSFetchRequest<WifiDB> = WifiDB.fetchRequest()
                do{
                    let wifis = try PersistenceService.context.fetch(fetchrequest)
                    self.offlineData = wifis
                    self.tvListWifis.reloadData()
                }catch{}
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadAdds()
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
    
    
    func LoadAdds(){
        
        let cm = ConnectionManager(action :"selectmyadds&id_user=\(FBUserShare.getFBId())")
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
                    let loc_name = Slocation["loc_name"] as! String
                    //print(id)
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC , nblike: nblike , nbdislike: nbdislike,ssid: ssid , loc_name:loc_name)
                    
                    self.listOfWifi.append(w)
                    self.tvListWifis.reloadData()
                }
            }
        }
    }
    
    func LoadFavs(){
        let fetchrequest:NSFetchRequest<WifiDB> = WifiDB.fetchRequest()
        let batchdeleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest as! NSFetchRequest<NSFetchRequestResult>)
        do{
            try PersistenceService.context.execute(batchdeleterequest)
        }catch{
            
        }
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
                    let loc_name = Slocation["loc_name"] as! String
                    //print(id)
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC , nblike: nblike , nbdislike: nbdislike,ssid: ssid , loc_name:loc_name)
                    
                    let offlineW = WifiDB(context: PersistenceService.context)
                    offlineW.id = id
                    offlineW.img = desc_loc
                    offlineW.ssid = ssid
                    offlineW.pw = wifi_pass
                    offlineW.lat = slat
                    offlineW.lng = slng
                    offlineW.name = loc_name
                    offlineW.likes = nblike
                    offlineW.dislikes = nbdislike
                    
                    PersistenceService.saveContext()
                    self.listOfWifi.append(w)
                    self.tvListWifis.reloadData()
                }
            }
        }
    }
    //Table view load
    

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        //let wifi = tableData[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "delete"){ (action , view , completion )in
            if Reachability.isConnectedToNetwork(){
                self.DelFavourit(tag: indexPath.row)
            }
            completion(true)
            self.listOfWifi.remove(at: indexPath.row)
            self.tvListWifis.deleteRows(at:[indexPath], with: .automatic)
            
        }
        action.image = #imageLiteral(resourceName: "garbage")
        action.backgroundColor = .red
        return action
    }
    func detailAction(at indexPath: IndexPath) -> UIContextualAction{
        //let wifi = tableData[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "detail"){ (action , view , completion )in
            let sb = UIStoryboard(name: "WifiDetail", bundle: nil)
            let destination = sb.instantiateInitialViewController()! as! VCWifiDetail
            
            if Reachability.isConnectedToNetwork(){
                let wifi = self.listOfWifi[indexPath.row]
                destination.lat = wifi.lat
                destination.lng = wifi.lng
                destination.img = wifi.img
                destination.disc = wifi.desc_loc
                destination.pw = wifi.wifi_pass
                destination.loc_name = wifi.loc_name
                destination.nblike = wifi.nblike
                destination.nbdislike = wifi.nbdislike
                destination.ssid = wifi.ssid
                destination.id = wifi.id_loc
                
            }else{
                let wifi = self.offlineData[indexPath.row]
                destination.lat = wifi.lat
                destination.lng = wifi.lng
                
                destination.disc = wifi.img
                destination.pw = wifi.pw
                destination.loc_name = wifi.name
                destination.nblike = wifi.likes
                destination.nbdislike = wifi.dislikes
                destination.ssid = wifi.ssid
                destination.id = wifi.id
            }
            
            self.present(destination, animated: true)
           
            
        }
        action.image = #imageLiteral(resourceName: "eye")
        action.backgroundColor = .blue
        return action
    }
//    @objc func mapAction(at indexPath: IndexPath) -> UIContextualAction{
//        //let wifi = tableData[indexPath.row]
//        let action = UIContextualAction(style: .normal, title: "Show"){ (action , view , completion )in
//            self.listOfWifi.remove(at: indexPath.row)
//            self.tableView.deleteRows(at:[indexPath], with: .automatic)
//            completion(true)
//        }
//        action.image = #imageLiteral(resourceName: "eye")
//        action.backgroundColor = .gray
//        return action
//    }
    
    //MARK: - table view delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Reachability.isConnectedToNetwork(){
            return self.listOfWifi.count
        }else{
            return self.offlineData.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellWifi = tableView.dequeueReusableCell(withIdentifier: "cellWifi", for: indexPath) as! TVCWifi
        if Reachability.isConnectedToNetwork(){
   
            cellWifi.SetWifi(wifi: listOfWifi[indexPath.row])
    
        }else{
             cellWifi.SetWifi(wifi: offlineData[indexPath.row])
        }
          return cellWifi
    }
    
    public  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [delete])
    }
    
    
    public  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detail = detailAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [detail])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell tapped" )
        let sb = UIStoryboard(name: "FavouriteMapStoryboard", bundle: nil)
        let destination = sb.instantiateInitialViewController()! as! FavouritMapViewController
        
        if Reachability.isConnectedToNetwork(){
            let wifi = self.listOfWifi[indexPath.row]
            destination.lat = wifi.lat
            destination.lng = wifi.lng
            destination.img = wifi.img
            destination.desc_loc = wifi.desc_loc
            destination.wifi_pass = wifi.wifi_pass
        }else{
            let wifi = self.offlineData[indexPath.row]
            destination.lat = wifi.lat
            destination.lng = wifi.lng
            destination.img = "wifihotspot"
            destination.desc_loc = wifi.ssid
            destination.wifi_pass = wifi.pw
        }
        
        self.present(destination, animated: true)
        //
        //self.performSegue(withIdentifier: "showfavmap", sender: self)
        
    }
    
    func DelFavourit(tag: Int){
        print (tag)
        var cm = ConnectionManager()
        if (tabController.selectedSegmentIndex == 0){
            cm = ConnectionManager(action :"deleteloc&id_loc=\(self.listOfWifi[tag].id_loc )&id_user=\(FBUserShare.getFBId())")

        }else{
            cm = ConnectionManager(action :"delfavourite&id_loc=\(self.listOfWifi[tag].id_loc )&id_user=\(FBUserShare.getFBId())")
        }
        //let url = "http://192.168.1.7/android/services.php?action=addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null"
        print ("url = \(cm.getURL())")
        
        
        
        
        Alamofire.request(cm.getURL()).responseString{ response in
            print (response.result.isSuccess)
            if     response.result.isSuccess{
                self.view.makeToast("the delete succeded")
            }else{
                self.view.makeToast("the delete failed 😞")
            }
            
        }
        
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
