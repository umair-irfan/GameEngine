//
//  FlowTest.swift
//  GameEngine
//
//  Created by umair irfan on 28/11/2023.
//

import Foundation
import XCTest
@testable import GameEngine

final class FlowTest: XCTestCase {
    
    let router = RouterSpy()
    
    func test_start_withNoQuestions_deosnotRouteToQuestion() {
        // Method-Chaining
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_RouteToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_RouteToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, [ "Q2"])
    }
    
    func test_start_withTwoQuestion_RouteToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestion_RouteToFirstQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q1"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestion_RouteToSecondAndThirdQuestion() {
        // makeSUT(questions: ["Q1", "Q2", "Q3"]).start()
        /// Method chainig produces failing test results
        /// See point(6) Takeaway Notes
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        // Testing the bounds of Array
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    
    // MARK: Helpers
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallBack: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallBack = answerCallback
        }
    }
}
