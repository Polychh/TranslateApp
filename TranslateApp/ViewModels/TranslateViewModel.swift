//
//  TranslateViewModel.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import Foundation
import Combine

enum LanType: String{
    case source = "sl"
    case dest = "dl"
}

final class TranslateViewModel: ObservableObject{
    
    @Published var dataTranslations: String = .init()
    @Published var placeHolderDest: String = .init()
    @Published var langDict: [String : String] = .init()
    @Published var langDictLabel: [String : String] = .init()
    
    let languages: [Languages] = Languages.allCases
    
    private let network: NetworkMangerProtocol
    private let storeManager: StoreManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(network: NetworkMangerProtocol, storeManager: StoreManagerProtocol) {
        self.network = network
        self.storeManager = storeManager
        observeData()
        setUpSavedtLangs()
    }
    
    private func observeData(){
        $langDict
            .dropFirst()
            .sink { [unowned self] dict in
                filterDictValue(dict: dict)
            }
            .store(in: &cancellables)
    }
    
    func translateWords(text: String){
        let request = TranslateRequest(sourseLan: langDict[LanType.source.rawValue] ?? "en", destLan: langDict[LanType.dest.rawValue] ?? "ru", textToTranslate: text)
        text.isEmpty ? placeHolderDest = "Translate Word" : fetchCoctailData(request: request)
    }
    
    func changeLanSourseOrDest(type:LanType, newlan: String){
        switch type{
        case .source:
            langDict[LanType.source.rawValue] = newlan
            saveNewLan(lanDict: langDict)
        case .dest:
            langDict[LanType.dest.rawValue] = newlan
            saveNewLan(lanDict: langDict)
        }
    }
    private func setUpSavedtLangs() {
        langDict = storeManager.getData(forKey: .languages) ?? [LanType.dest.rawValue: languages.first?.typeValue ?? "ru", LanType.source.rawValue: languages.last?.typeValue ?? "en"]
    }
    
    private func saveNewLan(lanDict: [String : String]){
        storeManager.set(langDict, forKey: .languages)
    }
    
    private func filterDictValue(dict: [String : String]){
        if let sl = languages.first(where: { $0.typeValue == dict[LanType.source.rawValue] })?.typeLabel {
            langDictLabel[LanType.source.rawValue] = sl
        }
        if let dl = languages.first(where: { $0.typeValue == dict[LanType.dest.rawValue] })?.typeLabel {
            langDictLabel[LanType.dest.rawValue] = dl
        }
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
