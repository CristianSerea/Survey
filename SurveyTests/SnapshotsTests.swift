//
//  SnapshotsTests.swift
//  SurveyTests
//
//  Created by Cristian Serea on 04.04.2024.
//

import XCTest
import PreviewSnapshotsTesting
@testable import Survey

final class SnapshotsTests: XCTestCase {
    func testLoadingButtonSnapshots() {
        LoadingButton_Previews.previewSnapshots.assertSnapshots()
    }
    
    func testToastViewSnapshots() {
        ToastView_Previews.previewSnapshots.assertSnapshots()
    }
    
    func testQuestionsViewSnapshots() {
        QuestionsView_Previews.previewSnapshots.assertSnapshots()
    }
    
    func testSurveyViewSnapshots() {
        SurveyView_Previews.previewSnapshots.assertSnapshots()
    }
}

extension SnapshotsTests {    
    func testLoadingButtonSnapshotsiPhone13Pro() {
        LoadingButton_Previews.previewSnapshots.assertSnapshots(as: .image(layout: .device(config: .iPhone13Pro)))
    }
    
    func testToastViewSnapshotsiPhone13Pro() {
        ToastView_Previews.previewSnapshots.assertSnapshots(as: .image(layout: .device(config: .iPhone13Pro)))
    }
    
    func testQuestionsViewSnapshotsiPhone13Pro() {
        QuestionsView_Previews.previewSnapshots.assertSnapshots(as: .image(layout: .device(config: .iPhone13Pro)))
    }
    
    func testSurveyViewSnapshotsiPhone13Pro() {
        SurveyView_Previews.previewSnapshots.assertSnapshots(as: .image(layout: .device(config: .iPhone13Pro)))
    }
}
