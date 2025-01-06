//
//  CredentialValidators.swift
//  Bookworm
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import Foundation

class CredentialValidators {
    static func validateUsername(_ userID: String) -> Bool {
        let pattern = "^[A-Z]{2}[0-9]{4}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: userID.utf16.count)
            return regex.firstMatch(in: userID, options: [], range: range) != nil
        } catch {
            DebugLogger.log("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }

    static func validatePassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$%^&*(),.?\":{}|<>])(?=.*\\d.*\\d)(?=.*[a-z].*[a-z].*[a-z])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: password.utf16.count)
            return regex.firstMatch(in: password, options: [], range: range) != nil
        } catch {
            DebugLogger.log("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }

}
