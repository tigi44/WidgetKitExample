//
//  ContentView.swift
//  WidgetKitExample
//
//  Created by tigi KIM on 2021/02/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
        
        Button(action: {
            WidgetCenter.shared.reloadAllTimelines()
        }, label: {
            Text("reload all widget")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
