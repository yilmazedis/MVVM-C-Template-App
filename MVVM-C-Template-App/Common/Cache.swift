//
//  Cache.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

import Foundation

class Cache<Key: Hashable, Value>: NSObject {
    
    private let cache = NSCache<KeyHolder<Key>, ValueHolder<Value>>()
    
    override init() {
        super.init()
    // TODO: - Consider memory warning for cache
//        addNotifications(NotificationCenter.default.observe(name: .applicationDidReceiveMemoryWarning) {
//            [unowned self] _ in
//            self.cache.removeAllObjects()
//        })
    }
    
    subscript(_ key: Key) -> Value? {
        get {
            return cache.object(forKey: KeyHolder(key))?.value
        }
        set {
            if let newValue = newValue {
                cache.setObject(ValueHolder(newValue), forKey: KeyHolder(key))
            }
            else {
                cache.removeObject(forKey: KeyHolder(key))
            }
        }
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}

// MARK: - Private API

private extension Cache {
    final class KeyHolder<T: Hashable>: NSObject {
        
        let key: T
        
        override var hash: Int {
            return key.hashValue
        }
        
        init(_ key: T) {
            self.key = key
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? KeyHolder<T> else { return false }
            return object.key == key
        }
    }
    
    final class ValueHolder<T> {
        let value: T
        
        init(_ value: T) {
            self.value = value
        }
    }
}
