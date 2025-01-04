//
//  SharedViewModel.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//

import Foundation

class SharedViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var selectedTab: Int = 0
}
