
import UIKit



class DetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var averageScoreTextField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    var name: String?
    var lastName: String?
    var averageScore: String?
    let dataStore = StudentDataStore.shared
    let validator = Validator.shared
    var indexInArray: Int? = nil
    enum State {
        case edit
        case creat
    }
    var  state : State?
    var nameFildChecked = false {
        didSet{checkAllFieldCorrectValue()}
    }
    var lastNameChecked = false{
        didSet{checkAllFieldCorrectValue()}
    }
    var averageScoreChecked = false{
        didSet{checkAllFieldCorrectValue()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        lastNameTextField.text = lastName
        averageScoreTextField.text = averageScore
        switch state {
        case .creat:
            stateCreateConfig()
        case .edit:
            stateEditConfig()
        case .none:
            break
        }
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        averageScoreTextField.delegate = self
        saveButtonOutlet.isEnabled = false
        validationConfig()
    }
    
    private func stateCreateConfig (){
        saveButtonOutlet.setTitle("Сохранить", for: .normal)
        nameTextField.becomeFirstResponder()
        nameTextField.returnKeyType = UIReturnKeyType.next
        lastNameTextField.returnKeyType = UIReturnKeyType.next
        averageScoreTextField.returnKeyType = UIReturnKeyType.done
    }
    
    private func stateEditConfig(){
        nameFildChecked = true
        lastNameChecked = true
        averageScoreChecked = true
        nameTextField.returnKeyType = UIReturnKeyType.done
        lastNameTextField.returnKeyType = UIReturnKeyType.done
        averageScoreTextField.returnKeyType = UIReturnKeyType.done
        saveButtonOutlet.setTitle("Изменить", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.removeTarget(self, action: #selector(nameFildValidation(parametrTarget:)), for: UIControl.Event.editingDidEnd)
        lastNameTextField.removeTarget(self, action: #selector(lastNameFildValidation(parametrTarget:)), for: .editingDidEnd)
        averageScoreTextField.removeTarget(self, action: #selector(averageScoreFildValidation(parametrTarget:)), for: .editingDidEnd)    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    
    func configure (forData data: StudenItem? , state:State, index: Int?){
        if let data = data{
        self.name = data.name
        self.lastName = data.lastName
        self.averageScore = String(data.averageScore)
        }
        self.state = state
        if let index = index{
            self.indexInArray = index
        }
    }
    
    @IBAction private func cancelButtonAction(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func saveButonAction(_ sender: Any) {
        guard  let name = nameTextField.text , let lastName = lastNameTextField.text , let averageScore = averageScoreTextField.text, let averageScoreInt = Int(averageScore) else {
            return
        }
        let student = StudenItem(name: name, lastName: lastName, averageScore: averageScoreInt)
        switch state {
        case .creat:
            dataStore.addStudent(student)
        case .edit:
            dataStore.changeStudent(index: indexInArray!, newValue: student)
        case .none:
        break
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func validationConfig (){
        nameTextField.addTarget(self, action: #selector(nameFildValidation(parametrTarget:)), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(lastNameFildValidation(parametrTarget:)), for: .editingDidEnd)
        averageScoreTextField.addTarget(self, action: #selector(averageScoreFildValidation(parametrTarget:)), for: .editingDidEnd)
    }
    
    @objc private func nameFildValidation(parametrTarget:UITextField){
        guard let text = parametrTarget.text else {return} // ALLERT
        let checkedResult =  validator.nameFildValidation(text: text)
        nameFildChecked = checkedResult.0
        if !nameFildChecked {
            let alertMessage = getErrorMessage(error: checkedResult.1)
            getAlertController(message: alertMessage, field: parametrTarget)
        }
    }
    
    @objc private func lastNameFildValidation(parametrTarget:UITextField){
        guard let text = parametrTarget.text else {return} // ALLERT
        let checkedResult =  validator.lastNameFildValidation(text: text)
        lastNameChecked = checkedResult.0
        if !lastNameChecked {
            let alertMessage = getErrorMessage(error: checkedResult.1)
           getAlertController(message: alertMessage, field: parametrTarget)
        }
    }
    
    @objc private func averageScoreFildValidation(parametrTarget:UITextField){
        guard let text = parametrTarget.text else {return} // ALLERT
        let checkedResult =  validator.averageScoreFildValidation(text: text)
        averageScoreChecked = checkedResult.0
        if !averageScoreChecked {
            let alertMessage = getErrorMessage(error: checkedResult.1)
           getAlertController(message: alertMessage, field: parametrTarget)
        }
    }
    
    
    
    private func getAlertController(message: String, field: UITextField){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            DispatchQueue.main.async {
                field.becomeFirstResponder()
            }
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func getErrorMessage(error: ValidationErrorType) ->String{
        var alertMessage = " "
                   switch error {
                   case .emptyString:
                   alertMessage = ValidationErrorType.emptyString.rawValue
                   case .incorrectSymbol:
                   alertMessage = ValidationErrorType.incorrectSymbol.rawValue
                   case .numberInString:
                   alertMessage = ValidationErrorType.numberInString.rawValue
                   case .spaceInString:
                   alertMessage = ValidationErrorType.spaceInString.rawValue
                   case .defferenceAlphabet:
                   alertMessage = ValidationErrorType.defferenceAlphabet.rawValue
                   case .none:
                   alertMessage = ValidationErrorType.none.rawValue
                   case .isNoNumber:
                    alertMessage = ValidationErrorType.isNoNumber.rawValue
                   case .incorrectValue:
                    alertMessage = ValidationErrorType.incorrectValue.rawValue
                   }
        return alertMessage
    }
    
    private func checkAllFieldCorrectValue(){
        
        switch state {
        case .creat:
            if nameFildChecked && lastNameChecked && averageScoreChecked {
                saveButtonOutlet.isEnabled = true
            }
        case .edit:
            guard nameFildChecked && lastNameChecked && averageScoreChecked  else {
                return
            }
            if name != nameTextField.text ||
                lastName != lastNameTextField.text ||
                averageScore != averageScoreTextField.text{
                saveButtonOutlet.isEnabled = true
            }
       case .none:
       break
        }
    }
    
}



extension DetailViewController : UITextFieldDelegate{
    
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch state {
    case .creat:
        if textField == nameTextField{
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
    
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButtonOutlet.isEnabled = false
    }
}
