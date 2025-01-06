//
//  UsernameRequirementsView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import SwiftUI

struct UsernameRequirementsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Username must contain the following:")
                .font(.headline)
                .padding(.bottom, 5)
                .lineLimit(5)

            Text("• Only numbers and letters.")
                .font(.body)
            Text("• Must start with two capital letters.")
                .font(.body)
            Text("• Followed by 4 numbers (0-9).")
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
