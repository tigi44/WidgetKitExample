//
//  IntentHandler.swift
//  EditableIntent
//
//  Created by tigi KIM on 2021/02/26.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: ConfigurationIntentHandling {
    func provideParameterOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
        var items: [NSString] = []
        
        items.append("first string")
        items.append("second string")
        items.append("third string")
        items.append("forth string")
        
        completion(INObjectCollection(items: items), nil)
    }
}
