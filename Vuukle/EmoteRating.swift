

import Foundation

class EmoteRating {
    
    var first : Int!
    var second : Int!
    var third : Int!
    var fourth : Int!
    var fifth : Int!
    var sixth : Int!
    
    static func EmoteRatingWhithDictionary(pDictionary:NSDictionary) -> EmoteRating {
        
        let lEmoteRating = EmoteRating()
        lEmoteRating.first = pDictionary["first"] as? Int ?? Int("")
        lEmoteRating.second = pDictionary["second"] as? Int ?? Int("")
        lEmoteRating.third = pDictionary["third"] as? Int ?? Int("")
        lEmoteRating.fourth = pDictionary["fourth"] as? Int ?? Int("")
        lEmoteRating.fifth = pDictionary["fifth"] as? Int ?? Int("")
        lEmoteRating.sixth = pDictionary["sixth"] as? Int ?? Int("")
        return lEmoteRating
    }

    
}