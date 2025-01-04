//
//  ContentView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedViewModel = SharedViewModel()

    var body: some View {
        if sharedViewModel.isLoggedIn {
            MainTabView()
                .environmentObject(sharedViewModel)
        } else {
            LoginView()
                .environmentObject(sharedViewModel)
        }
    }
}
