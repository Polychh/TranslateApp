//
//  TranslateModel.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation

struct TranslateModel: Codable {
    let translations: Translations

    enum CodingKeys: String, CodingKey {
        case translations = "translations"
    }
}

struct Translations: Codable {
    let possibleTranslations: [String]

    enum CodingKeys: String, CodingKey {
        case possibleTranslations = "possible-translations"
    }
}


