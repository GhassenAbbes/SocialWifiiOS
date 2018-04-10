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

class FavouriteViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var FavTable: UITableView!
    var tableData = [Wifi]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        LoadLocations()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///Alamofire
    func LoadLocations(){
        let cm = ConnectionManager(action :"selectfav&id_user=1828686040530623")
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
                    //print(id)
                    let w = Wifi(id_loc: id, desc_loc: desc_loc, wifi_pass: wifi_pass, lat: slat, lng: slng, img: img, mac: MAC)
                    
                    self.tableData.append(w)
                    
                    
                }
                self.tableView.reloadData()
                print(self.tableData.description)
                
            }
        }
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let wifi = tableData[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "delete"){ (action , view , completion )in
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at:[indexPath], with: .automatic)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "garbage")
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
        return self.tableData.count
    }
    
    
    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath) as! FavViewCell
        
        let wifi = self.tableData[indexPath.row]
        cell.SSIDlbl.text = wifi.desc_loc
        cell.PWlbl.text = wifi.wifi_pass
        cell.FavImage.image = #imageLiteral(resourceName: "restaurant1")
        
        return cell
    }
    
    
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
