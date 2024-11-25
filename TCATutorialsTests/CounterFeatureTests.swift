//
//  CounterFeatureTests.swift
//  TCATutorialsTests
//
//  Created by Masanori Ogawa on 26/11/R6.
//

import ComposableArchitecture
import Testing

@testable import TCATutorials

@MainActor
struct CounterFeatureTests {
    //    ボタンをタップして増減をテストする
    //    @Test
    //    func basics() async {
    //        let store = TestStore(initialState: CounterFeature.State()) {
    //            CounterFeature()
    //        }
    //
    //        await store.send(.incrementButtonTapped) {
    //            $0.count = 1
    //        }
    //        await store.send(.decrementButtonTapped) {
    //            $0.count = 0
    //        }
    //    }
    
    //    タイマーが動作しているかテストする
    @Test
    func timer() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // タイマーを開始
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        // 1秒待つ（ちゃんとタイマーがアクションを発行する依存関係などを考慮している）
        await clock.advance(by: .seconds(1))
        
        // timerTickが1であることを期待する
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        // タイマーを止める
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    //    factの動作テスト
    @Test
    func numberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
          CounterFeature()
        } withDependencies: {
          $0.numberFact.fetch = { "\($0) is a good number." }
        }
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        //        await store.receive(\.factResponse, timeout: .seconds(1)) {
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
