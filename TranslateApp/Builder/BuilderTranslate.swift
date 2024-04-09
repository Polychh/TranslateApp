//
//  TranslateBuilder.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import UIKit

protocol BuilderTranslateProtocol{
    func buildTranslateVC() -> UIViewController
}

final class BuilderTranslate: BuilderTranslateProtocol{
    func buildTranslateVC() -> UIViewController {
        let network = NetworkManager()
        let viewModel = TranslateViewModel(network: network)
        let vc = TranslateViewController(viewModel: viewModel)
        return vc
        
    }
    
    
}
