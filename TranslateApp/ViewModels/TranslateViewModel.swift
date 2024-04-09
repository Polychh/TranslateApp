//
//  TranslateViewModel.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation

final class TranslateViewModel: ObservableObject{
    private let network: NetworkMangerProtocol
    @Published var dataTranslations: TranslateModel = .init(translations: .init(possibleTranslations: .init()))
    
    init(network: NetworkMangerProtocol) {
        self.network = network
    }
    
    func translateWords(){
        let request = TranslateRequest(sourseLan: "ru", destLan: "en", textToTranslate: "привет")
        fetchCoctailData(request: request)
    }
    
    private func fetchCoctailData(request: TranslateRequest){
        Task{ @MainActor in
            do{
                let dataTranslate = try await network.request(request)
                dataTranslations = dataTranslate
                print(dataTranslations)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
