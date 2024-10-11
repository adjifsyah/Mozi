//
//  My_DokuApp.swift
//  My Doku
//
//  Created by Adji Firmansyah on 28/08/24.
//

import SwiftUI

@main
struct My_DokuApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
