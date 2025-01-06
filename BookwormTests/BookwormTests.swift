//
//  BookwormTests.swift
//  BookwormTests
//
//  Created by Georgios Stamelakis on 6/1/25.
//

import XCTest

@testable import Bookworm

final class CredentialValidatorsTests: XCTestCase {

    // MARK: Usernames tests
    func testValidUserIDs() {
        XCTAssertTrue(CredentialValidators.validateUsername("AB1234"), "Expected 'AB1234' to be valid")
        XCTAssertTrue(CredentialValidators.validateUsername("XY5678"), "Expected 'XY5678' to be valid")
    }

    func testInvalidUserIDs() {
        XCTAssertFalse(CredentialValidators.validateUsername("A1234"), "Expected 'A1234' to be invalid (missing second letter)")
        XCTAssertFalse(CredentialValidators.validateUsername("AB123"), "Expected 'AB123' to be invalid (too short)")
        XCTAssertFalse(CredentialValidators.validateUsername("AB12345"), "Expected 'AB12345' to be invalid (too long)")
        XCTAssertFalse(CredentialValidators.validateUsername("123456"), "Expected '123456' to be invalid (missing letters)")
        XCTAssertFalse(CredentialValidators.validateUsername("ab1234"), "Expected 'ab1234' to be invalid (lowercase letters)")
        XCTAssertFalse(CredentialValidators.validateUsername("AB12C4"), "Expected 'AB12C4' to be invalid (contains non-numeric characters)")
    }

    // MARK: Passwords tests
    func testValidPasswords() {
        XCTAssertTrue(CredentialValidators.validatePassword("Aa1!b3bC"), "Expected 'Aa1!b3bC' to be valid")
        XCTAssertTrue(CredentialValidators.validatePassword("XY2@abcD6"), "Expected 'XY2@abcD6' to be valid")
        XCTAssertTrue(CredentialValidators.validatePassword("QQ4$mmmN7"), "Expected 'QQ4$mmmN7' to be valid")
    }

    func testInvalidPasswords() {
        XCTAssertFalse(CredentialValidators.validatePassword("Aa1!bbC"), "Expected 'Aa1!bbC' to be invalid (too short)")
        XCTAssertFalse(CredentialValidators.validatePassword("Aa1bbbCC"), "Expected 'Aa1bbbCC' to be invalid (no special character)")
        XCTAssertFalse(CredentialValidators.validatePassword("aa1!bbb1"), "Expected 'aa1!bbb1' to be invalid (missing uppercase letters)")
        XCTAssertFalse(CredentialValidators.validatePassword("AA1!1234"), "Expected 'AA1!1234' to be invalid (missing lowercase letters)")
        XCTAssertFalse(CredentialValidators.validatePassword("AA!bbbCCC"), "Expected 'AA!bbbCCC' to be invalid (missing numerals)")
    }
}

