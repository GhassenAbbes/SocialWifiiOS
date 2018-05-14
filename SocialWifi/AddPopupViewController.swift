//
//  AddPopupViewController.swift
//  SocialWifi
//
//  Created by Ahmed BHD on 3/31/18.
//  Copyright © 2018 Ahmed BHD. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import FirebaseStorage
import NVActivityIndicatorView
class AddPopupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var lat:String?
    var lng:String?
    var ImageUrl:String = "null"
    var image:UIImage?
    let activityData = ActivityData()
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var labLocName: UITextField!
    
    @IBOutlet weak var laDesc: UITextField!
    
    @IBOutlet weak var SSIDText: UITextField!
    
    @IBOutlet weak var PWText: UITextField!
    
    @IBAction func CancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var SaveBtn: UIButton!
    let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction))
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("cancel tapped")
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(gesture)
        self.hideKeyboardWhenTappedAround() 
     
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        print("save taped")
        print (self.lat ?? "null")
        var style = ToastStyle()
        
        // this is just one of many style options
        style.messageColor = .orange
        style.messageAlignment = .center
        
        ToastManager.shared.style = style
        //print (self.SSIDText.text!)
        //print (self.lat)
        
        
        if ( self.SSIDText.text!=="" || self.PWText.text!=="" || self.labLocName.text!=="" || self.laDesc.text!=="" ){
            self.view.makeToast("You can't add a wifi without its proper informations !") // now uses the shared style
        }else{
            if (self.image != nil){
                self.UploadImage()
            }else{
                self.AddWifi()
            }
        }
        //dismiss(animated: true)
    }
    
    @IBAction func btPick(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func UploadImage(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let imageData = UIImagePNGRepresentation(self.image!)
        let imagePath = "\(self.SSIDText.text!).jpg"//whatever you want
        storageRef.child(imagePath).putData(imageData!,metadata:nil){
            (metadata, error) in
            if let error = error{
                print("Error uploading photo: \(error)")
            }
            else{
                let downloadURL = metadata!.downloadURL()?.absoluteString
                //print(downloadURL)
                self.ImageUrl = downloadURL!.replacingOccurrences(of: "&", with: "%26", options: NSString.CompareOptions.literal, range:nil)
                self.AddWifi()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                //do whatever you want...
            }
        }
    }
    ///Alamofire
    func AddWifi(){
        
        let cm = ConnectionManager(action :"addlocios&desc=\(self.laDesc.text ?? "")&pw=\(self.PWText.text ?? "")&lat=\(self.lat ?? "")&lng=\(self.lng ?? "")&img=\(self.ImageUrl )&ssid=\(self.SSIDText.text ?? "")&loc_name=\(self.labLocName.text ?? "")&id_user=\(FBUserShare.getFBId())")
    
        print ("url = \(cm.getURL())")
        Alamofire.request(cm.getURL()).responseString{ response in
            print (response.result.isSuccess)
            if     response.result.isSuccess{
                self.dismiss(animated: true)
            }else{
                self.view.makeToast("the wifi couldn't be added 😞")
            }
            
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

