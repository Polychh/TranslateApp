//
//  TranslateViewModel.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation

final class TranslateViewModel: ObservableObject{
    private let network: NetworkMangerProtocol
    @Published var dataTranslations: String = .init()
    @Published var plsceHolderDest: String = .init()
    
    let languages: [Languages] = Languages.allCases
    
    init(network: NetworkMangerProtocol) {
        self.network = network
    }
    
    func translateWords(text: String){
        print("text \(text)")
        let request = TranslateRequest(sourseLan: "ru", destLan: "en", textToTranslate: text)
        text.isEmpty ? plsceHolderDest = "Translate Word" : fetchCoctailData(request: request)
    }
    
    private func fetchCoctailData(request: TranslateRequest){
        Task{ @MainActor in
            do{
                let dataTranslate = try await network.request(request)
                dataTranslations = dataTranslate.translations.possibleTranslations.joined(separator: "\n")
               // print(dataTranslations)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
