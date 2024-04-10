//
//  Storemanager.swift
//  TranslateApp
//
//  Created by Polina on 10.04.2024.
//

import Foundation


// MARK: - CRUD
protocol StoreManagerProtocol{
    func set(_ object: Any?, forKey key: StoreManager.Keys)
    func remove(forKey key: StoreManager.Keys)
    func getData(forKey key: StoreManager.Keys) -> [String : String]?
}

final class StoreManager{
    public enum Keys: String{
        case languages
    }
    
    private let userDefaults = UserDefaults.standard
    
    private func save(object: Any?, forKey key: String){
        userDefaults.setValue(object, forKey: key)
    }
    
    private func getSavedObject(forKey key: String) -> Any?{
        userDefaults.object(forKey: key)
    }
}

extension StoreManager: StoreManagerProtocol{
    func set(_ object: Any?, forKey key: Keys) {
        save(object: object, forKey: key.rawValue)
    } // UPDATE CREATE
    
    func getData(forKey key: Keys) -> [String : String]? {
        getSavedObject(forKey: key.rawValue) as? [String : String]
    }// READ
    
    func remove(forKey key:  Keys){
        userDefaults.removeObject(forKey: key.rawValue)
    } // DELETE
}
