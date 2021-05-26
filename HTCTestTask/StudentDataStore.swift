

import Foundation

class StudentDataStore {
    //MARK: - property
    private var arrayStudents : Array<StudenItem> = Array<StudenItem>()
    private let dataBase = UserDefaults.standard
    static let shared = StudentDataStore()
    
    //MARK: - init
    private init() {
        loadData()
    }
    
    //MARK: - public method
    func getStudent(forIndex index: Int) -> StudenItem {
        let student = arrayStudents[index]
        return student
    }
    
    func getCountStudents() -> Int {
        return arrayStudents.count
    }
    
    func addStudent(_ student: StudenItem) {
        arrayStudents.append(student)
        saveData()
    }
    
    func changeStudent(index: Int , newValue: StudenItem) {
        arrayStudents.insert(newValue, at: index)
        deleteStudent(index: index + 1)
        saveData()
    }
    
    func deleteStudent(index: Int)  {
        arrayStudents.remove(at: index)
        saveData()
    }
    
    //MARK: - private method
    private func saveData() {
        let archiveDataToSave: Data
        if #available(iOS 11.0, *) {
            guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: arrayStudents, requiringSecureCoding: false) else {return}
            archiveDataToSave = archiveData
        } else {
             let archiveData = NSKeyedArchiver.archivedData(withRootObject: arrayStudents)
            archiveDataToSave = archiveData
        }
        dataBase.set(archiveDataToSave, forKey: "arrayStudents")
    }
    
    private func loadData() {
        guard  let data = dataBase.object(forKey: "arrayStudents")  else {return}
        guard let unarchiveData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) else {return}
        arrayStudents = unarchiveData as! Array<StudenItem>
    }
}
