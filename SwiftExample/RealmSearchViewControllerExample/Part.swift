//
//  Part
//  EIS
//
//  Created by Jon Chui on 3/12/18.
//  Copyright © 2017 Jon Chui. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Part: Object, Mappable {

    // Following are entered by the user only (not from the server), and sent to the server
    dynamic var name = ""
    dynamic var quantity = 0

    convenience init(name: String, quantity: Int) {
        self.init()

        self.name = name
        self.quantity = quantity
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        name <- map["Name"]
        quantity <- map["Quantity"]
    }

    func toJSON() -> [String : Any] {
        return [
            "Name": name,
            "Quantity": quantity
        ]
    }
}
