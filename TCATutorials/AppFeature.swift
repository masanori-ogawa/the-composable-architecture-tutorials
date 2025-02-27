//
//  AppFeature.swift
//  TCATutorials
//
//  Created by Masanori Ogawa on 26/11/R6.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
  struct State: Equatable {
    var tab1 = ContactsFeature.State()
    var tab2 = CounterFeature.State()
    var tab3 = CounterFeature.State()
  }
  
  enum Action {
    case tab1(ContactsFeature.Action)
    case tab2(CounterFeature.Action)
    case tab3(CounterFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    // 親Feature（AppFeature）に子Feature（CounterFeature）を組み込むためにScope Reducerを用いる
    Scope(state: \.tab1, action: \.tab1) {
      ContactsFeature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      CounterFeature()
    }
    Scope(state: \.tab3, action: \.tab3) {
      CounterFeature()
    }
    Reduce { state, action in
      // Core logic of the app feature
      return .none
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    TabView {
      ContactsView(store: store.scope(state: \.tab1, action: \.tab1))
        .tabItem {
          Text("Contacts")
        }

      CounterView(store: store.scope(state: \.tab2, action: \.tab2))
        .tabItem {
          Text("Counter 1")
        }
      
      CounterView(store: store.scope(state: \.tab3, action: \.tab3))
        .tabItem {
          Text("Counter 3")
        }

    }
  }
}

#Preview {
  AppView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
