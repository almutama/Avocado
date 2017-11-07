//
//  CardManagerTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 3..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class CardManagerTests: XCTestCase {
  
  var sut: CardManager!
  
  override func setUp() {
    super.setUp()
    sut = CardManager()
  }
  
  override func tearDown() {
    sut.removeAll()
    sut = nil
    super.tearDown()
  }
  
  //toDoCount
  func test_ToDoCount_Initially_IsZero() {
    XCTAssertEqual(sut.toDoCount, 0)
  }
  
  //addCard
  func test_AddCard_IncreaseToDoCountToOne() {
    let newCard = WordCard(word: "news")
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  func test_WhenSameCardAdded_NotIncreaseToDoCount() {
    let newCard = WordCard(word: "same")
    let card = WordCard(word: "same")
    sut.addCard(newCard: newCard)
    sut.addCard(newCard: card)
    XCTAssertEqual(sut.toDoCount, 1)
  }
  
  //cardAt
  func test_CardAt_AfterAddingCard_ReturnsThatCard() {
    let newCard = WordCard(word: "new")
    sut.addCard(newCard: newCard)
    
    XCTAssertEqual(newCard.word, sut.cardAt(index: 0).word)
  }
  
  //completeCardAt
  func test_CompleteCardAt_ChangesCounts() {
    let newCard = WordCard(word: "temp")
    sut.addCard(newCard: newCard)
    XCTAssertEqual(sut.toDoCount, 1)
    
    sut.completeCardAt(index: 0)
    XCTAssertEqual(sut.toDoCount, 0)
  }
  
  func test_CompleteCardAt_RemoveItFromToDoCards() {
    let first = WordCard(word: "one")
    let second = WordCard(word: "two")
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    
    sut.completeCardAt(index: 0)
    XCTAssertNotEqual(first, sut.cardAt(index: 0))
  }
  
  //removeAll
  func test_removeAll_CountsToBeZero() {
    let first = WordCard(word: "one")
    let second = WordCard(word: "two")
    sut.addCard(newCard: first)
    sut.addCard(newCard: second)
    sut.completeCardAt(index: 0)
    
    sut.removeAll()
    XCTAssertEqual(sut.toDoCount, 0)
  }
}
