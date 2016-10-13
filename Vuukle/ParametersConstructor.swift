

import Foundation
import UIKit
import Social


class ParametersConstructor  {
    static let sharedInstance = ParametersConstructor()
    let defaults : UserDefaults = UserDefaults.standard
    
    
    func showAlert(_ title : String ,message : String) {
        let ErrorAlert = UIAlertView(title: "\(title)", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
        ErrorAlert.show()
    }
    
    func checkFields(_ name : String , email : String , comment : String) -> Bool {
        var allFill = false
        if name != "" && email != "" && comment != "" && comment != "Please write a comment..."{
            if ((email.range(of: "@")) != nil) && ((email.range(of: ".")) != nil) {
                allFill = true
            } else {
                showAlert( "Please enter a correct email!",message: "")
                allFill = false
            }
        } else if (name == "") || (name == " ") || checkStringForSpaces(string: name, indexSimbol: 0) == false{
            showAlert("Please enter a name!", message: "")
            allFill = false
        } else if email == ""{
            showAlert("Please enter a email!", message: "")
            allFill = false
        } else if ((comment == "Please write a comment...") || (comment == "") || (comment.isEmpty) || (comment == " ")) || (checkStringForSpaces(string: comment, indexSimbol: 0) == false) {
            showAlert("Please enter a comment!", message: "")
            allFill = false
        }
        return allFill
    }
    
    func setDateInFofmat(_ dateInString : String) -> Date{
        var date = Date()
        if dateInString != "" {
            let dateString:String = dateInString
            let dateFormat = DateFormatter.init()
            dateFormat.dateStyle = .full
            dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
            date = (dateFormat.date(from: dateString)! as NSDate) as Date
        }
        return date
    }
    
    func encodingString(_ string : String) -> String{
        
        return string.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
    }
    
    func decodingString(_ string : String) -> String{
        return string.removingPercentEncoding!
    }
    
    
    func setRatePercent (_ first : Int , second : Int , thirt : Int , fourth : Int , fifth : Int , sixt : Int , element : Int) -> Int {
        let sume : Int = first + second + thirt + fourth + fifth + sixt
        if sume == 0 {
            return 0
        }
        let percent = (element * 100)/sume
        return percent
    }
    
    
    func searchUpperChracters(_ fullName: String) -> String{
        var output1 = ""
        var output2 = ""
        var output = ""
        var sname = ""
        var fname = ""
        if fullName != "" {
            
            var fullNameComponents = fullName.components(separatedBy: " ")
            
            fname = fullNameComponents.count > 0 ? fullNameComponents[0]: ""
            sname = fullNameComponents.count > 1 ? fullNameComponents[1]: ""
            fname = fname.capitalized
            sname = sname.capitalized
            for chr in fname.characters {
                if output1.characters.count != 1 {
                    output1 = String(chr)
                }
            }
            for chr in sname.characters {
                if output2.characters.count != 1 {
                    output2 = String(chr)
                }
            }
            output = "\(output1)\(output2)"
        }
        return output
    }
    
    
    
    func setRate(_ article_id : String ,emote : Int , tableView : UITableView) {
        
        if  self.defaults.object(forKey: "\(article_id)") as? String == nil{
            
            showAlert( "Voted!",message: "Thanks for voting!")
            NetworkManager.sharedInstance.setRaring(article_id, emote: emote) { (response) in
                switch emote {
                case 1:
                    Global.firstEmoticonVotesCount += 1
                    self.defaults.set("firstEmoticonSelected", forKey: "\(article_id)")
                case 2:
                    Global.secondEmoticonVotesCount += 1
                    self.defaults.set("secondEmoticonSelected", forKey: "\(article_id)")
                case 3:
                    Global.thirdEmoticonVotesCount += 1
                    self.defaults.set("thirdEmoticonSelected", forKey: "\(article_id)")
                case 4:
                    Global.fourthEmoticonVotesCount += 1
                    self.defaults.set("fourthEmoticonSelected", forKey: "\(article_id)")
                case 5:
                    Global.fifthEmoticonVotesCount += 1
                    self.defaults.set("fifthEmoticonSelected", forKey: "\(article_id)")
                case 6:
                    Global.sixthEmoticonVotesCount += 1
                    self.defaults.set("sixtEmoticonSelected", forKey: "\(article_id)")
                default:
                    break
                }
                self.defaults.synchronize()
                tableView.reloadData()
            }
            
        } else {
            showAlert( "You have already voted!",message: "")
        }
    }
    
    
    
    func setEmoticonCountVotes (_ data : EmoteRating){
        Global.firstEmoticonVotesCount = data.first
        Global.secondEmoticonVotesCount = data.second
        Global.thirdEmoticonVotesCount = data.third
        Global.fourthEmoticonVotesCount = data.fourth
        Global.fifthEmoticonVotesCount = data.fifth
        Global.sixthEmoticonVotesCount = data.sixth
        Global.votes = data
        
    }
    
    func checkStringForSpaces(string : String , indexSimbol : Int) -> Bool {
        var result : Bool!
        var fullNameComponents = string.components(separatedBy: " ")
        if fullNameComponents[indexSimbol].isEmpty && indexSimbol < string.characters.count{
            checkStringForSpaces(string: string, indexSimbol: indexSimbol + 1)
            result = false
        } else {
            result = true
        }
        return result
    }
    
}
