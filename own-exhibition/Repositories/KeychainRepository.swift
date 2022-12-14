//
//  KeychainRepository.swift
//  own-exhibition
//
//  Created by Jaewon Yun on 2022/11/29.
//

import Foundation

final class KeychainRepository {
    
    private let serviceName = Bundle.main.bundleIdentifier!
    
    @discardableResult
    func save(token: Token) -> Bool {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : token.id,
                                 kSecAttrGeneric : token.value]
        
        self.delete(id: token.id)
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func update(token: Token) -> Bool {
        return false
    }
    
    func get(id: String) -> Token? {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : id,
                                  kSecMatchLimit : kSecMatchLimitOne,
                            kSecReturnAttributes : true,
                                  kSecReturnData : true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [CFString : Any],
              let tokenValue = existingItem[kSecAttrGeneric] as? String
        else { return nil }
        
        return .init(id: id, value: tokenValue)
    }
    
    @discardableResult
    func delete(id: String) -> Bool {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : id]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
