//
//  FavouriteViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 4/8/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import CoreData

class FavouriteViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    let userid = DownloadImage.getFBID()

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var FavTable: UITableView!
    var tableData = [Wifi]()
    var offlineData = [WifiDB]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        LoadLocations()
        tableView.delegate = self
        tableView.dataSource = self
        var style = ToastStyle()
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///Alamofire
    func LoadLocations(){
        if Reachability.isConnectedToNetwork(){
            print ("connection")
            let fetchrequest:NSFetchRequest<WifiDB> = WifiDB.fetchRequest()
            let batchdeleterequest = NSBatchDeleteRequest(fetchRequest: fetchrequest as! NSFetchRequest<NSFetchRequestResult>)
            do{
                try PersistenceService.context.execute(batchdeleterequest)
            }catch{
                
            }
            
            
            self.view.makeToast("your  connected")
            let cm = ConnectionManager(action :"selectfav&id_user=\(self.userid )")
            Alamofire.request(cm.getURL()).responseJSON{ response in
                
                if let locationsJSON = response.result.value {
                    //let locationArray:Dictionary = locationsJSON as! Dictionary<String,Any>
                    let json =  locationsJSON as! NSArray
                    for locationOBJECT in json{
                        
                        print (locationOBJECT)
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
                        //print(id)
                        let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC ,nblike: nblike , nbdislike: nbdislike)
                        let offlineW = WifiDB(context: PersistenceService.context)
                        offlineW.id = id
                        offlineW.img = "wifihotspot"
                        offlineW.ssid = desc_loc
                        offlineW.pw = wifi_pass
                        offlineW.lat = slat
                        offlineW.lng = slng
                        PersistenceService.saveContext()
                        self.tableData.append(w)
                        self.tableView.reloadData()

                        
                    }
                    print(self.tableData.description)
                    
                }
            }
        }else{
            print ("no connection")
            let fetchrequest:NSFetchRequest<WifiDB> = WifiDB.fetchRequest()
            do{
                let wifis = try PersistenceService.context.fetch(fetchrequest)
                self.offlineData = wifis
                self.tableView.reloadData()
            }catch{
                
            }
            self.view.makeToast("No internet found :(")
        }
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        //let wifi = tableData[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "delete"){ (action , view , completion )in
            if Reachability.isConnectedToNetwork(){
                self.DelFavourit(tag: indexPath.row)
            }
            completion(true)
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        action.image = #imageLiteral(resourceName: "garbage")
        action.backgroundColor = .red
        return action
    }
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "toAddViewControllerSegue" {
        //            let popup = segue.destination as! AddPopupViewController
        //            popup.lat=String(describing: self.currentlocation?.coordinate.latitude)
        //            popup.lng=String(describing: self.currentlocation?.coordinate.longitude)
        //        }
        //    }
    @objc func mapAction(at indexPath: IndexPath) -> UIContextualAction{
        //let wifi = tableData[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Show"){ (action , view , completion )in
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at:[indexPath], with: .automatic)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "eye")
        action.backgroundColor = .gray
        return action
    }
    
    //MARK: - table view delegate
    public  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [delete])
    }
    
    
    // MARK: - Table view data source
    
    public  func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.tableData.count)
        if Reachability.isConnectedToNetwork(){
            return self.tableData.count
        }else{
            return self.offlineData.count
        }
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
    }
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath) as! FavViewCell
        
        if Reachability.isConnectedToNetwork(){
            let wifi = self.tableData[indexPath.row]
            
            cell.SSIDlbl.text = wifi.desc_loc
            cell.PWlbl.text = wifi.wifi_pass
            //cell.FavImage.image = #imageLiteral(resourceName: "restaurant1")
            self.get_image(wifi.img, cell.FavImage)
            cell.FavImage.layer.cornerRadius = cell.FavImage.frame.height / 2
        }else{
            let wifi = self.offlineData[indexPath.row]
            cell.SSIDlbl.text = wifi.ssid
            cell.PWlbl.text = wifi.pw
            cell.FavImage.image = #imageLiteral(resourceName: "wifihotspot")
            cell.FavImage.layer.cornerRadius = cell.FavImage.frame.height / 2
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell tapped" )
        let sb = UIStoryboard(name: "FavouriteMapStoryboard", bundle: nil)
        let destination = sb.instantiateInitialViewController()! as! FavouritMapViewController
        
        if Reachability.isConnectedToNetwork(){
            let wifi = self.tableData[indexPath.row]
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
    
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        
        let url:URL = URL(string: url_str)!
        let session = URLSession(configuration: .default)
        
        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        imageView.image = image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        getImageFromUrl.resume()
    }
    
    func DelFavourit(tag: Int){
        print (tag)
        let cm = ConnectionManager(action :"delfavourite&id_loc=\(self.tableData[tag].id_loc )&id_user=\(self.userid )")
        
        //let url = "http://192.168.1.7/android/services.php?action=addloc&desc=\(self.SSIDText.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=null"
        print ("url = \(cm.getURL())")
        
        
        
        
                    Alamofire.request(cm.getURL()).responseString{ response in
                        print (response.result.isSuccess)
                        if     response.result.isSuccess{
                            self.view.makeToast("the favourite has been deleted")
                        }else{
                            self.view.makeToast("the favourite couldn't be added 😞")
                        }
                        
                    }
                
    }
    
    
    
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
//
//        if (segue.identifier == "showfavmap") {
//                if let indexPath = self.tableView.indexPathForSelectedRow {
//                    let viewController = segue.destination as! FavouritMapViewController
//                    let wifi = self.tableData[indexPath.row]
//
//                    // your new view controller should have property that will store passed value
//                    viewController.lat = wifi.lat
//                    viewController.lng = wifi.lng
//                    viewController.img = wifi.img
//                    viewController.desc_loc = wifi.desc_loc
//                    viewController.wifi_pass = wifi.wifi_pass
//                }
//        }
//    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
