//
//  SimpleAppApp.swift
//  SimpleApp
//
//  Created by Shazy on 03/03/23.
//

import SwiftUI

@main
struct SimpleAppApp: App {
    let router = Router()

    var body: some Scene {
        WindowGroup {
            HomeScreen(router: router)
        }
    }
}
