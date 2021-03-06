//
//  ECKeyTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 6/19/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class ECKeyTests: XCTestCase {

  func testECKeyUniqueness() {
    let key = ECKey()
    XCTAssertNotNil(key.publicKey)
    XCTAssertNotNil(key.privateKey)
    let key1 = ECKey()
    XCTAssertNotNil(key1.publicKey)
    XCTAssertNotNil(key1.privateKey)
    XCTAssertNotEqual(key.publicKey!, key1.publicKey!)
    XCTAssertNotEqual(key.privateKey!, key1.privateKey!)
  }

  func testSignature() {
    // Test that verification succeeds when expected.
    let key = ECKey()
    let data = NSData(bytes: [0x1, 0x2, 0x3] as [UInt8], length: 3)
    let hash = data.SHA256Hash()
    let signature = key.signatureForHash(hash)
    XCTAssertNotNil(signature)
    XCTAssertTrue(key.verifySignature(signature, forHash: hash))

    // Test that verification fails for a signature created by another key.
    let key1 = ECKey()
    XCTAssertFalse(key1.verifySignature(signature, forHash: hash))

    // Test that verification fails for different data.
    let data1 = NSData(bytes: [0x1, 0x2, 0x3, 0x4] as [UInt8], length: 4)
    let hash1 = data1.SHA256Hash()
    XCTAssertFalse(key.verifySignature(signature, forHash: hash1))
  }
}
