

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
    
        lEmoteRating.first = pDictionary["first"] == nil ? 0 : pDictionary["first"] as? Int ?? 0
        lEmoteRating.second = pDictionary["second"] == nil ? 0 : pDictionary["second"] as? Int ?? 0
        lEmoteRating.third =  pDictionary["third"] == nil ? 0 : pDictionary["third"] as? Int ?? 0
        lEmoteRating.fourth = pDictionary["fourth"] == nil ? 0 : pDictionary["fourth"] as? Int ?? 0
        lEmoteRating.fifth = pDictionary["fifth"] == nil ? 0 : pDictionary["fifth"] as? Int ?? 0
        lEmoteRating.sixth = pDictionary["sixth"] == nil ? 0 : pDictionary["sixth"] as? Int ?? 0
        return lEmoteRating
    }

    
}