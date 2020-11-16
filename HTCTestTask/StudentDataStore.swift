

import Foundation

class StudentDataStore{
   private var arrayStudents : Array<StudenItem> = Array<StudenItem>()
    private let dataBase = UserDefaults.standard
    static let shared = StudentDataStore()
    
    var testArray = [1,2,3,4,5,6,7]
    
    private init(){
        loadData()
    }
    
    func getStudent(forIndex index: Int) -> StudenItem{
        let student = arrayStudents[index]
        return student
    }
    
    func getCountStudent() -> Int {
        return arrayStudents.count
    }
    
    func addStudent(_ student: StudenItem){
        arrayStudents.append(student)
        saveData()
    }
    
    func changeStudent(index: Int , newValue: StudenItem) {
        //arrayStudents[index] = newValue
        arrayStudents.insert(newValue, at: index)
        saveData()
    }
    
    func deletStudent(index: Int)  {
        arrayStudents.remove(at: index)
        saveData()
    }
    
    private func saveData(){
        guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: arrayStudents, requiringSecureCoding: false) else {return}
        dataBase.set(archiveData, forKey: "arrayStudents")
    }
    private func loadData(){
        guard  let data = dataBase.object(forKey: "arrayStudents")  else {return}
        guard let unarchiveData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) else {return}
        arrayStudents = unarchiveData as! Array<StudenItem>
    }
}
