
import Foundation


class StudenItem:NSObject , NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(averageScore, forKey: "averageScore")
    }
    
    required init?(coder: NSCoder) {
        self.name =  coder.decodeObject(forKey: "name") as! String
        self.lastName =  coder.decodeObject(forKey: "lastName") as! String
        self.averageScore = coder.decodeInteger(forKey: "averageScore")
    }
    
    let name: String
    let lastName: String
    var fullName: String {
        get{return "\(name) \(lastName)"}
    }
    var averageScore: Int
    
    init(name: String, lastName: String, averageScore: Int){
        self.name = name
        self.lastName = lastName
        self.averageScore = averageScore
    }
    
    
    
}
