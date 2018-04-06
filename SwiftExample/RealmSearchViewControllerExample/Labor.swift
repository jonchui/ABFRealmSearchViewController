//
//  Labor
//  EIS
//
//  Created by Jon Chui on 3/12/18.
//  Copyright © 2017 Jon Chui. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Labor: Object, Mappable {

    // Following are entered by the user only (not from the server), and sent to the server
    dynamic var name = ""
    dynamic var duration = 0.0

    convenience init(name: String, duration: Double) {
        self.init()

        self.name = name
        self.duration = duration
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        name <- map["Name"]
        duration <- map["Duration"]
    }

    func toJSON() -> [String : Any] {
        return [
            "Name": name,
            "Duration": duration
        ]
    }
}
