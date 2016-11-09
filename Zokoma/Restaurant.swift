//
//  Restaurant.swift
//  Zokoma
//
//  Created by jiro9611 on 11/26/15.
//  Copyright © 2015 jiro9611. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {

    @NSManaged var name:String!
    @NSManaged var type:String!
    @NSManaged var location:String!
    @NSManaged var image:Data!
    @NSManaged var isVisited:NSNumber!

}
