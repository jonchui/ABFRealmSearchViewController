//
//  File.swift
//  EIS
//
//  Created by Logan Keller on 4/5/17.
//  Copyright © 2017 Logan Keller. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class QuickNote: Object, Mappable {

    dynamic var note = ""
    dynamic var isSelected : Bool = false

    // Following are entered by the user only (not from the server), and sent to the server
    var recommendations = List<Recommendation>()

    convenience init(note: String, isSelected: Bool) {
        self.init()

        self.note = note
        self.isSelected = isSelected
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        note <- map["Note"]
    }

    func toJSON() -> [String : Any] {
        return ["note": note]
    }
}
