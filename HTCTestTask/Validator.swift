//
//  Validator.swift
//  HTCTestTask
//
//  Created by Анна Ильиных on 12.11.2020.
//  Copyright © 2020 Анна Ильиных. All rights reserved.
//

import Foundation
enum ValidationErrorType: String{
    case none = " "
    case emptyString = "Поле пусто"
    case numberInString = "Поле не должно содержать цифр"
    case spaceInString = "Поле не должно содержать пробелов"
    case incorrectSymbol = "Поле  содержит некорретные символы"
    case defferenceAlphabet = "Поле не должно содержать буквы разных алфавитов"
    case isNoNumber = "Поле должно содержать только цифры"
    case incorrectValue = "Введите значение от 1 до 5"
}

class Validator{
    private init(){}
    static let shared = Validator()
    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    private let patternIncorrectSymbols = "\\W|\\_"
    private  let patternEngAlphabetic = "[a-z]"
    private let patternRusAlphabetic = "[а-я]"
    
    func nameFildValidation(text:String)->(Bool,ValidationErrorType){
        guard checkIsEmpry(text: text) else {return (false, .emptyString)}
        guard checkNumberInString(text: text) else {return (false, .numberInString)}
        guard checkSpaceInString(text: text) else {return (false, .spaceInString)}
        guard checkIncorrectSymbols(text: text) else {return (false, .incorrectSymbol)}
        guard checkAlphabeticalDifference(text: text) else {return (false, .defferenceAlphabet)}
        return (true, .none)}
    
    func lastNameFildValidation(text:String)->(Bool,ValidationErrorType){
        guard checkIsEmpry(text: text) else {return (false, .emptyString)}
        guard checkNumberInString(text: text) else {return (false, .numberInString)}
        guard checkSpaceInString(text: text) else {return (false, .spaceInString)}
        guard checkIncorrectSymbols(text: text) else {return (false, .incorrectSymbol)}
        guard checkAlphabeticalDifference(text: text) else {return (false, .defferenceAlphabet)}
        return (true, .none)}
    
    func averageScoreFildValidation(text:String)->(Bool,ValidationErrorType){
        guard checkIsEmpry(text: text) else {return (false, .emptyString)}
        guard checkSpaceInString(text: text) else {return (false, .spaceInString)}
        guard checkIncorrectSymbols(text: text) else {return (false, .incorrectSymbol)}
        guard checkIsNumber(text: text) else {return (false, .isNoNumber )}
        guard checkCorrectValueAverageScore(text: text) else {return (false, .incorrectValue ) }
        
        return (true, .none)}
    
  
   
    //MARK: - private metod
    
    
  
    private func checkIsEmpry(text:String) -> Bool{
          guard !text.isEmpty else {return false}
          return true
      }
      
    
    private func checkNumberInString(text: String)-> Bool{
        for number in numbers{
            if  text.contains(number) {
                return false
            }
        }
        return true
    }
    
    private func checkSpaceInString(text:String)-> Bool{
        if text.contains(" "){
            return false
        }
        return true
    }
    
    private func checkIsNumber(text:String)->Bool{
        guard let _ = Int(text) else {return false}
        return true
    }
    
    private func checkCorrectValueAverageScore(text: String) -> Bool{
        guard !(Int(text)! < 1) && !(Int(text)! > 5) else {return false}
        return true
    }
    
     private func checkIncorrectSymbols (text:String) -> Bool{
        let regText = try? NSRegularExpression(pattern: patternIncorrectSymbols, options: .caseInsensitive)
        if regText?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).count != 0 {
            return false
        }else {
          return true
        }
        
    }
    
    private func checkAlphabeticalDifference(text: String) -> Bool  {
        let firstSymbol = String(text.first!)
        let regTextEng = try? NSRegularExpression(pattern: patternEngAlphabetic, options: .caseInsensitive)
        let regTextRus = try? NSRegularExpression(pattern: patternRusAlphabetic, options: .caseInsensitive)
        if regTextEng?.matches(in: firstSymbol, options: [], range: NSRange(location: 0, length: firstSymbol.count)).count == 0{
            //значит первая русская
            guard regTextEng?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).count == 0 else{return false}
            
            return true
        }else{
            guard regTextRus?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).count == 0 else{return false}
             
            return true
        }
        
        
    }
}
