//
//  Languages.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation
protocol LanguagesModelProtocol{
    var typeLabel: String { get }
    var typeValue: String { get }
}

   
enum Languages: CaseIterable {
    case ru, en, french, danish, czech, bulgarian, german, greek
}


extension Languages: LanguagesModelProtocol{
    var typeLabel: String {
        switch self{
            
        case .ru:
            return "Russian"
        case .en:
            return "English"
        case .french:
            return "French"
        case .danish:
            return "Danish"
        case .czech:
            return "Czech"
        case .bulgarian:
            return "Bulgarian"
        case .german:
            return "German"
        case .greek:
            return "Greek"
        }
    }
    
    var typeValue: String {
        switch self{
        case .ru:
            return "ru"
        case .en:
            return "en"
        case .french:
            return "fr"
        case .danish:
            return "da"
        case .czech:
            return "cs"
        case .bulgarian:
            return "bg"
        case .german:
            return "de"
        case .greek:
            return "el"
        }
    }
    
    
}
