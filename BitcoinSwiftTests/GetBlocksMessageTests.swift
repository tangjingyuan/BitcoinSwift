//
//  GetBlocksMessageTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 9/27/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class GetBlocksMessageTests: XCTestCase {

  let getBlocksMessageWithHashStopBytes: [UInt8] = [
      0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
      0x02,                                             // Number of block locator hashes (2)
      0x0b, 0x73, 0x25, 0x7c, 0x50, 0x9b, 0xf0, 0xa1,
      0xc6, 0xc4, 0x72, 0xbc, 0xae, 0xa9, 0x64, 0x26,
      0x48, 0xae, 0xf3, 0x80, 0x24, 0xe4, 0x64, 0x15,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // blockLocatorHash0
      0x70, 0x73, 0x28, 0x8d, 0xd7, 0xd6, 0x38, 0x22,
      0x43, 0x0d, 0x14, 0x03, 0x29, 0x56, 0xbc, 0x3f,
      0xff, 0xc7, 0xb4, 0x38, 0xd4, 0x8e, 0x90, 0x15,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // blockLocatorHash1
      0x24, 0xf7, 0xd8, 0x44, 0xa7, 0x0b, 0x48, 0x33,
      0x25, 0x4c, 0x47, 0xe4, 0x1e, 0x92, 0x51, 0x3c,
      0x6f, 0x71, 0x4a, 0x63, 0xe6, 0xd2, 0x72, 0x0a,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]   // blockHashStop

  let getBlocksMessageWithoutHashStopBytes: [UInt8] = [
      0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
      0x02,                                             // Number of block locator hashes (2)
      0x0b, 0x73, 0x25, 0x7c, 0x50, 0x9b, 0xf0, 0xa1,
      0xc6, 0xc4, 0x72, 0xbc, 0xae, 0xa9, 0x64, 0x26,
      0x48, 0xae, 0xf3, 0x80, 0x24, 0xe4, 0x64, 0x15,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // blockLocatorHash0
      0x70, 0x73, 0x28, 0x8d, 0xd7, 0xd6, 0x38, 0x22,
      0x43, 0x0d, 0x14, 0x03, 0x29, 0x56, 0xbc, 0x3f,
      0xff, 0xc7, 0xb4, 0x38, 0xd4, 0x8e, 0x90, 0x15,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // blockLocatorHash1
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]   // blockHashStop

  var getBlocksMessageWithHashStopData: NSData!
  var getBlocksMessageWithoutHashStopData: NSData!

  var getBlocksMessageWithHashStop: GetBlocksMessage!
  var getBlocksMessageWithoutHashStop: GetBlocksMessage!

  override func setUp() {
    super.setUp()
    let blockLocatorHash0Bytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
        0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
        0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b]
    let blockLocatorHash1Bytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
        0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
        0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70]
    let blockHashStopBytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0a, 0x72, 0xd2, 0xe6, 0x63, 0x4a, 0x71, 0x6f,
        0x3c, 0x51, 0x92, 0x1e, 0xe4, 0x47, 0x4c, 0x25,
        0x33, 0x48, 0x0b, 0xa7, 0x44, 0xd8, 0xf7, 0x24]
    let blockLocatorHash0 = SHA256Hash(bytes: blockLocatorHash0Bytes)
    let blockLocatorHash1 = SHA256Hash(bytes: blockLocatorHash1Bytes)
    let blockHashStop = SHA256Hash(bytes: blockHashStopBytes)
    getBlocksMessageWithHashStop =
        GetBlocksMessage(protocolVersion: 70001,
                         blockLocatorHashes: [blockLocatorHash0, blockLocatorHash1],
                         blockHashStop: blockHashStop)
    getBlocksMessageWithoutHashStop =
        GetBlocksMessage(protocolVersion: 70001,
                         blockLocatorHashes: [blockLocatorHash0, blockLocatorHash1])
    getBlocksMessageWithHashStopData = NSData(bytes: getBlocksMessageWithHashStopBytes,
                                              length: getBlocksMessageWithHashStopBytes.count)
    getBlocksMessageWithoutHashStopData = NSData(bytes: getBlocksMessageWithoutHashStopBytes,
                                                 length: getBlocksMessageWithoutHashStopBytes.count)
  }

  func testGetBlocksMessageEncodingWithHashStop() {
    XCTAssertEqual(getBlocksMessageWithHashStop.bitcoinData, getBlocksMessageWithHashStopData)
  }

  func testGetBlocksMessageEncodingWithoutHashStop() {
    XCTAssertEqual(getBlocksMessageWithoutHashStop.bitcoinData, getBlocksMessageWithoutHashStopData)
  }

  func testGetBlocksMessageDecodingWithHashStop() {
    let stream = NSInputStream(data: getBlocksMessageWithHashStopData)
    stream.open()
    if let testGetBlocksMessage = GetBlocksMessage.fromBitcoinStream(stream) {
      XCTAssertEqual(testGetBlocksMessage, getBlocksMessageWithHashStop)
    } else {
      XCTFail("Failed to parse GetBlocksMessage")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }

  func testGetBlocksMessageDecodingWithoutHashStop() {
    let stream = NSInputStream(data: getBlocksMessageWithoutHashStopData)
    stream.open()
    if let testGetBlocksMessage = GetBlocksMessage.fromBitcoinStream(stream) {
      XCTAssertEqual(testGetBlocksMessage, getBlocksMessageWithoutHashStop)
    } else {
      XCTFail("Failed to parse GetBlocksMessage")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }
}
