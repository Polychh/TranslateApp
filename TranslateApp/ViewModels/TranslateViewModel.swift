//
//  TranslateViewModel.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation

enum lanType{
    case source
    case dest
}

final class TranslateViewModel: ObservableObject{
    
    @Published var dataTranslations: String = .init()
    @Published var placeHolderDest: String = .init()
    
    let languages: [Languages] = Languages.allCases
    var langDict: [String : String] = ["sl" : "", "dl" : ""]
    
    private let network: NetworkMangerProtocol
    
    init(network: NetworkMangerProtocol) {
        self.network = network
        setUpDefaultLangs()
    }
    
    func translateWords(text: String){
        let request = TranslateRequest(sourseLan: langDict["sl"] ?? "en", destLan: langDict["dl"] ?? "ru", textToTranslate: text)
        text.isEmpty ? placeHolderDest = "Translate Word" : fetchCoctailData(request: request)
    }
    
    func changeLanSourseOrDest(type:lanType, newlan: String){
        switch type{
        case .source:
            langDict["sl"] = newlan
        case .dest:
            langDict["dl"] = newlan
        }
    }
    
    private func setUpDefaultLangs(){
        langDict["sl"] = languages.first?.typeValue
        langDict["dl"] = languages.last?.typeValue
    }
    
    private func fetchCoctailData(request: TranslateRequest){
        Task{ @MainActor in
            do{
                let dataTranslate = try await network.request(request)
                dataTranslations =  dataTranslate.translations.possibleTranslations.joined(separator: "\n")
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
