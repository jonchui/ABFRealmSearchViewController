//
//  Recommendation
//  EIS
//
//  Created by Jon Chui on 3/12/18.
//  Copyright © 2017 Jon Chui. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class AddRecommendationObject: Object {
    dynamic var potentialString = ""

    convenience init(potentialString: String) {
        self.init()
        self.potentialString = potentialString
    }
}

class Recommendation: Object, Mappable {

    // Following are entered by the user only (not from the server), and sent to the server
    dynamic var recommendationString = ""
    var labors = List<Labor>()
    var parts = List<Part>()

    var parentQuicknote: QuickNote { return quicknotes.first! }
    // quicknote that link to me
    private let quicknotes = LinkingObjects(fromType: QuickNote.self, property: "recommendations")

    convenience init(recommendationString: String) {
        self.init()

        self.recommendationString = recommendationString
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        recommendationString <- map["Note"]
    }

    func toJSON() -> [String : Any] {
        var labors = [Any]()
        for labor in self.labors {
            labors.append(labor.toJSON())
        }

        var parts = [Any]()
        for part in self.labors {
            parts.append(part.toJSON())
        }

        return [
            "Note": recommendationString,
            "Labors": labors,
            "Parts": parts
        ]
    }
}
