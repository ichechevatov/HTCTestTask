
import UIKit
let descriptionsNameTextField = "Поле ввода имени"
let descriptionsLastNameTextField = "Поле ввода фамилии"
let descriptionsAverageScoreTextField = "Поле ввода среднего балла"


class DetailViewController: UIViewController {
    enum State {
        case edit
        case create
    }
    //MARK: - outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var averageScoreTextField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //MARK: - property
    private var name: String?
    private var lastName: String?
    private var averageScore: String?
    
    private let dataStore = StudentDataStore.shared
    private let validator = Validator.shared
    
    private var indexInArray: Int? = nil
    private var  state : State?
    
    //MARK: - lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        lastNameTextField.text = lastName
        averageScoreTextField.text = averageScore
        
        switch state {
        case .create:
            stateCreateConfig()
        case .edit:
            stateEditConfig()
        case .none:
            break
        }
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        averageScoreTextField.delegate = self
        saveButtonOutlet.isEnabled = true
    }
    
    func configure (forData data: StudenItem?, state: State, index: Int?) {
        if let data = data {
            self.name = data.name
            self.lastName = data.lastName
            self.averageScore = String(data.averageScore)
        }
        self.state = state
        if let index = index {
            self.indexInArray = index
        }
    }
    
    private func stateCreateConfig () {
        saveButtonOutlet.setTitle("Сохранить", for: .normal)
        nameTextField.becomeFirstResponder()
        nameTextField.returnKeyType = UIReturnKeyType.next
        lastNameTextField.returnKeyType = UIReturnKeyType.next
        averageScoreTextField.returnKeyType = UIReturnKeyType.done
    }
    
    private func stateEditConfig(){
        nameTextField.returnKeyType = UIReturnKeyType.done
        lastNameTextField.returnKeyType = UIReturnKeyType.done
        averageScoreTextField.returnKeyType = UIReturnKeyType.done
        saveButtonOutlet.setTitle("Изменить", for: .normal)
    }
    
    //MARK: - Actions method
    @IBAction private func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func saveButonAction(_ sender: Any) {
        if validateTextFilds() {
            let averageScoreInt = Int(averageScoreTextField.text!)
            let name = nameTextField.text
            let lastName = lastNameTextField.text
            let student = StudenItem(name: name!, lastName: lastName!, averageScore: averageScoreInt!)
            switch state {
            case .create:
                dataStore.addStudent(student)
            case .edit:
                dataStore.changeStudent(index: indexInArray!, newValue: student)
            case .none:
                break
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Alert methods
    private func createMessageToAlert(errorsNameField: Array<ValidationErrorType>, errorsLastNameField: Array<ValidationErrorType>, errorsAverageScoreField: Array<ValidationErrorType>)-> String {
        var result: String = ""
        if errorsNameField.count != 0 {
            result = result + descriptionsNameTextField + ":" + "\n"
            for errorMessage in errorsNameField {
                result = result  + "- " + errorMessage.rawValue + "\n"
            }
            result = result + "\n"
        }
        if errorsLastNameField.count != 0 {
            result = result + descriptionsLastNameTextField + ":" + "\n"
            for errorMessage in errorsLastNameField {
                result = result  + "- " + errorMessage.rawValue + "\n"
            }
            result = result + "\n"
        }
        if errorsAverageScoreField.count != 0 {
            result = result + descriptionsAverageScoreTextField + ":" + "\n"
            for errorMessage in errorsAverageScoreField {
                result = result  + "- " + errorMessage.rawValue + "\n"
            }
        }
        return result
    }
    
    private func getAlertController(message: String){
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private methods
    private func validateTextFilds() -> Bool {
        let errorsValidationName = validator.nameFildValidation(text: nameTextField.text ?? "")
        let errorsValidationLastName = validator.lastNameFildValidation(text: lastNameTextField.text ?? "")
        let errorsValidationAverageScore = validator.averageScoreFildValidation(text: averageScoreTextField.text ?? "")
        if (!(errorsValidationName.isEmpty) || !(errorsValidationLastName.isEmpty) || !(errorsValidationAverageScore.isEmpty)){
            let messageToAlert = createMessageToAlert(errorsNameField: errorsValidationName, errorsLastNameField: errorsValidationLastName, errorsAverageScoreField: errorsValidationAverageScore)
            getAlertController(message: messageToAlert)
            return false
        }
        return true
    }
}

//MARK: - UITextFieldDelegate
extension DetailViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch state {
        case .create:
            if textField == nameTextField {
                lastNameTextField.becomeFirstResponder()
            } else if textField == lastNameTextField {
                averageScoreTextField.becomeFirstResponder()
            } else if textField == averageScoreTextField {
                averageScoreTextField.resignFirstResponder()
            }
        case .edit:
            textField.resignFirstResponder()
        case .none:
            break
        }
        return true
    }
    
}
