//
//  AppFeatureTests.swift
//  TCATutorialsTests
//
//  Created by Masanori Ogawa on 26/11/R6.
//

import ComposableArchitecture
import Testing


@testable import TCATutorials


@MainActor
struct AppFeatureTests {
    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
    }

    await store.send(\.tab1.incrementButtonTapped) {
      $0.tab1.count = 1
    }
}
