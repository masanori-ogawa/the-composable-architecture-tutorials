//
//  App.swift
//  TCATutorials
//
//  Created by Masanori Ogawa on 25/11/R6.
//

import ComposableArchitecture
import SwiftUI

@main
struct MyApp: App {
  static let store = Store(initialState: CounterFeature.State()) {
    CounterFeature()
          ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      CounterView(store: MyApp.store)
    }
  }
}
