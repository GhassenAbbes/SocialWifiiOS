//
//  RestaurantPreviewView.swift
//  googlMapTutuorial2
//
//  Created by Muskan on 12/17/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
class LocationPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=true
        setupViews()
    }
    
    func setData(title: String, img: String,  price: String) {
        lblTitle.text = title
        //imgView.image = img
        if img == "null"{
            imgView.image = #imageLiteral(resourceName: "wifihotspot")
        }else{
            get_image(img, imgView)
        }
        lblPrice.text = price
    }
    func setData(title: String,  price: String) {
        lblTitle.text = title
        lblPrice.text = price
    }
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        containerView.addSubview(lblTitle)
        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive=true
        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive=true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
        imgView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        addSubview(lblPrice)
        lblPrice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblPrice.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive=true
        lblPrice.widthAnchor.constraint(equalToConstant:200).isActive=true
        lblPrice.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
//        addSubview(btnFav)
//        btnFav.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -10).isActive=true
//        btnFav.rightAnchor.constraint(equalTo: imgView.rightAnchor, constant: -10).isActive=true
//        btnFav.widthAnchor.constraint(equalToConstant: 20).isActive=true
//
        
    }
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image=#imageLiteral(resourceName: "wifihotspot")
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblPrice: UILabel = {
        let lbl=UILabel()
        lbl.text="$12"
        lbl.font=UIFont.boldSystemFont(ofSize: 32)
        lbl.textColor=UIColor.white
        lbl.backgroundColor=UIColor(white: 0.2, alpha: 0.8)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let btnFav: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "inlove"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(AddFav), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    @objc func AddFav() {
        print ("fav")
        
        self.makeToast("Added a favourite ▾")
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}


