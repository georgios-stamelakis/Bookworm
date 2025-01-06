//
//  PasswordRequirementsView.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import SwiftUI

struct PasswordRequirementsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Password must contain the following:")
                .font(.headline)
                .padding(.bottom, 5)
                .lineLimit(5)
            
            Text("• 8 characters length.")
                .font(.body)
            Text("• 2 letters in Upper Case.")
                .font(.body)
            Text("• 1 Special Character.")
                .font(.body)
            Text("• 2 numerals (0-9).")
                .font(.body)
            Text("• 3 letters in Lower Case.")
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
