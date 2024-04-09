//
//  TranslateRequest.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//


import Foundation

struct TranslateRequest: TranslateRequestProtocol{
    typealias Response = TranslateModel
    
    let sourseLan: String
    let destLan: String
    let textToTranslate: String
    
    var url: String {
        let baseUrl = "https://ftapi.pythonanywhere.com/translate"
        return baseUrl
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]?
    
    var queryItems: [(String, String)]?{
        let params = [
            ("sl", "\(sourseLan)"),
            ("dl", "\(destLan)"),
            ("text", "\(textToTranslate)"),
        ]
        return params
    }
}
