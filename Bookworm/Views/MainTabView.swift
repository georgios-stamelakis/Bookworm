//
//  MainTabView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 4/1/25.
//


import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel

    var body: some View {
        ZStack {
            TabView(selection: $sharedViewModel.selectedTab) {
                BooksView()
                    .tabItem {
                        Label("Books", systemImage: "book.fill")
                    }
                    .tag(0)

                NavigationStack {
                    Text("Second Tab")
                        .navigationTitle("Second Tab")
                }
                .tabItem {
                    Label("Second", systemImage: "star.fill")
                }
                .tag(1)

                Spacer()

                NavigationStack {
                    Text("Third Tab")
                        .navigationTitle("Third Tab")
                }
                .tabItem {
                    Label("Third", systemImage: "gear")
                }
                .tag(3)

                NavigationStack {
                    Text("Fourth Tab")
                        .navigationTitle("Fourth Tab")

                }
                .tabItem {
                    Label("Fourth", systemImage: "person.fill")
                }
                .tag(4)

            }

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: {
                        sharedViewModel.selectedTab = 2
                    }) {
                        Image(systemName: "house.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .shadow(color: .gray, radius: 4, x: 2, y: 2)
                            .foregroundColor(.white)
                    }
                    .offset(y: -25)

                    Spacer()
                }
            }
        }
    }
}
