//
//  ContactsFeatureTests.swift
//  TCATutorialsTests
//
//  Created by Masanori Ogawa on 2024/12/29.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import TCATutorials


@MainActor
struct ContactsFeatureTests {
  @Test
  func addFlow() async {
    let store = TestStore(initialState: ContactsFeature.State()) {
       ContactsFeature()
     } withDependencies: {
       $0.uuid = .incrementing
     }
    store.exhaustivity = .off


    await store.send(.addButtonTapped)
    await store.send(\.destination.addContact.setName, "Blob Jr.")
    await store.send(\.destination.addContact.saveButtonTapped)
    // 次に、ユーザーが「保存」ボタンをタップした後、連絡先が配列に追加され、子機能が閉じられることを確認したいです。
    // しかし、すべてのアクションが受信されるまでそれを確認することはできません。
    // そのため、skipReceivedActions(strict:fileID:file:line:column:)を使用してそれを行うことができます。
    await store.skipReceivedActions()
    store.assert {
      $0.contacts = [
        Contact(id: UUID(0), name: "Blob Jr.")
      ]
      $0.destination = nil
    }
  }

  @Test
  func deleteContact() async {
    let store = TestStore(
      initialState: ContactsFeature.State(
        contacts: [
          Contact(id: UUID(0), name: "Blob"),
          Contact(id: UUID(1), name: "Blob Jr."),
        ]
      )
      ) {
        ContactsFeature()
      }

    await store.send(.deleteButtonTapped(id: UUID(1))) {
      $0.destination = .alert(
        AlertState {
          TextState("Are you sure?")
        } actions: {
          ButtonState(role: .destructive, action: .confirmDeletion(id: UUID(1))) {
            TextState("Delete")
          }
        }
      )
    }
    await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1)))))) {
      $0.contacts.remove(id: UUID(1))
      $0.destination = nil
    }
  }
}
