//
//  Validator.swift
//  HTCTestTask
//
//  Created by Анна Ильиных on 12.11.2020.
//  Copyright © 2020 Анна Ильиных. All rights reserved.
//

import Foundation
enum ValidationErrorType: String{
    case emptyString = "Поле пусто"
    case numberInString = "Поле не должно содержать цифр"
    case spaceInString = "Поле не должно содержать пробелов"
    case incorrectSymbol = "Поле  содержит некорретные символы"
    case defferenceAlphabet = "Поле не должно содержать буквы разных алфавитов"
    case isNoNumber = "Поле должно содержать только цифры"
    case incorrectValue = "Введите значение от 1 до 5"
    case firstSymbolIsLetter = "Первый символ должен быть буквой"
}

class Validator{
    //MARK: - singleton init
    private init(){}
    static let shared = Validator()
    
    //MARK: - property
    private let decimalSetChar = CharacterSet.decimalDigits
    private let lCharSet = CharacterSet.lowercaseLetters
    private let uCharSet = CharacterSet.uppercaseLetters
    private let spaceCharSet = CharacterSet.whitespacesAndNewlines
    private let decimalCharaSer = CharacterSet.decimalDigits
    private let apostropheCharSet = CharacterSet.init( arrayLiteral: Unicode.Scalar(UInt32(8216))!, Unicode.Scalar(UInt32(8217))!, Unicode.Scalar(39), Unicode.Scalar(96) ) // " \'" for example "O'Hara"
    private  let patternEngAlphabetic = "[a-z]"
    private let patternRusAlphabetic = "[а-я]"
    
    //MARK: - public metod
    func nameFildValidation(text:String)->(Array<ValidationErrorType>){
        var resulError: Array<ValidationErrorType> = []
        if !(checkIsEmpry(text: text))                  {resulError.append(.emptyString)}
        if !(checkNumberInString(text: text))           {resulError.append(.numberInString)}
        if !(checkSpaceInString(text: text))            {resulError.append(.spaceInString)}
        if !(checkIncorrectSymbols(text: text))         {resulError.append(.incorrectSymbol)}
        if !(checkAlphabeticalDifference(text: text))   {resulError.append(.defferenceAlphabet)}
        if !(checkFirstSymbolIsLetter(text: text))      {resulError.append(.firstSymbolIsLetter)}
        return ( resulError)
    }
    
    func lastNameFildValidation(text:String)->(Array<ValidationErrorType>){
        var resulError: Array<ValidationErrorType> = []
        if !(checkIsEmpry(text: text))                  {resulError.append(.emptyString)}
        if !(checkNumberInString(text: text))           {resulError.append(.numberInString)}
        if !(checkSpaceInString(text: text))            {resulError.append(.spaceInString)}
        if !(checkIncorrectSymbols(text: text))         {resulError.append(.incorrectSymbol)}
        if !(checkAlphabeticalDifference(text: text))   {resulError.append(.defferenceAlphabet)}
        if !(checkFirstSymbolIsLetter(text: text))      {resulError.append(.firstSymbolIsLetter)}
        return ( resulError)
    }
    
    func averageScoreFildValidation(text:String)->(Array<ValidationErrorType>){
        var resulError: Array<ValidationErrorType> = []
        if !(checkIsEmpry(text: text))                  {resulError.append(.emptyString)}
        if !(checkSpaceInString(text: text))            {resulError.append(.spaceInString)}
        if !(checkIncorrectSymbols(text: text))         {resulError.append(.incorrectSymbol)}
        if !(checkIsNumber(text: text))                 {resulError.append(.isNoNumber)}
        if !(checkCorrectValueAverageScore(text: text)) {resulError.append(.incorrectValue)}
        return ( resulError)
    }
    
    
    
    //MARK: - private metod
    private func checkFirstSymbolIsLetter(text: String) -> Bool {
        guard !(text.isEmpty) else {return true}
        guard text.first!.isLetter else {return false}
        return true
    }
    
    private func checkIsEmpry(text:String) -> Bool {
        guard !text.isEmpty else {return false}
        return true
    }
    
    private func checkNumberInString(text: String) -> Bool {
        guard  text.rangeOfCharacter(from: decimalSetChar) == nil else {return false}
        return true
    }
    
    private func checkSpaceInString(text:String) -> Bool {
        if text.contains(" "){return false}
        return true
    }
    
    private func checkIsNumber(text:String) -> Bool {
        guard !(text.isEmpty) else {return true}
        guard let _ = Int(text) else {return false}
        return true
    }
    
    private func checkCorrectValueAverageScore(text: String) -> Bool {
        guard !(text.isEmpty) else {return true}
        guard let text = Int(text) , text >= 1 , text <= 5 else {return false}
        return true
    }
    
    private func checkIncorrectSymbols (text:String) -> Bool {
        var unionCharSet = lCharSet.union(uCharSet).union(spaceCharSet).union(apostropheCharSet).union(decimalCharaSer)
        unionCharSet.invert()
        
        if text.rangeOfCharacter(from: unionCharSet) != nil {return false}
        return true
    }
    
    private func checkAlphabeticalDifference(text: String) -> Bool {
        guard !(text.isEmpty) else {return true}
        guard let firstSymbolLetter = text.first(where: {$0.isLetter}) else {return true}
        let firstSymbolLetterAndNotNill = String(firstSymbolLetter)
        let regTextEng = try? NSRegularExpression(pattern: patternEngAlphabetic, options: .caseInsensitive)
        let regTextRus = try? NSRegularExpression(pattern: patternRusAlphabetic, options: .caseInsensitive)
        if regTextEng?.matches(in: firstSymbolLetterAndNotNill, options: [], range: NSRange(location: 0, length: firstSymbolLetterAndNotNill.count)).count == 0 {
            //значит первая русская
            guard regTextEng?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).count == 0 else{return false}
            return true
        }else{
            guard regTextRus?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).count == 0 else{return false}
            return true
        }
    }
}
