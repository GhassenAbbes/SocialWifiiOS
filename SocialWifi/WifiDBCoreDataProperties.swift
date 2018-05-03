//
//  WifiDB+CoreDataProperties.swift
//  
//
//  Created by Ahmed BHD on 4/14/18.
//
//

import Foundation
import CoreData


extension WifiDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WifiDB> {
        return NSFetchRequest<WifiDB>(entityName: "WifiDB")
    }

    @NSManaged public var id: String?
    @NSManaged public var ssid: String?
    @NSManaged public var pw: String?
    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var img: String?
    @NSManaged public var name: String?
    @NSManaged public var likes: String?
    @NSManaged public var dislikes: String?

}
