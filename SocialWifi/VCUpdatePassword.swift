//
//  VCUpdatePassword.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 5/11/18.
//  Copyright © 2018 esprit. All rights reserved.
//

import UIKit
import Alamofire

class VCUpdatePassword: UIViewController {

    @IBOutlet weak var laPassword: UITextField!
    var id:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btSave(_ sender: Any) {
        let cm = ConnectionManager(action :"updatelocios&id=\(self.id ?? "")&pw=\(self.laPassword.text ?? "")")
        
        print ("url = \(cm.getURL())")
        Alamofire.request(cm.getURL()).responseString{ response in
            print (response.result.isSuccess)
            if     response.result.isSuccess{
                self.dismiss(animated: true)
            }else{
                self.view.makeToast("the wifi couldn't be updated 😞")
            }
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
