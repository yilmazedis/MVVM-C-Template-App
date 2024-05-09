//
//  Collection.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 26.04.2024.
//

import Foundation

protocol DummyProtocol {
    static func firstIfNilDummy() -> Self
}

extension Collection where Element: DummyProtocol {
    func firstIfNilDummy() -> Element {
        return first ?? Element.firstIfNilDummy()
    }
}

// Example of simple usage
extension Int: DummyProtocol {
    static func firstIfNilDummy() -> Int {
        return 0 // Replace with your desired default value
    }
}
