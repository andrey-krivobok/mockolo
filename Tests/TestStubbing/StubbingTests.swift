import Foundation

class StubbingTests: MockoloTestCase {
    func testBasicStubbingEnabled() {
        verify(srcContent: basicStubbingProtocol,
               dstContent: basicStubbingMockEnabled,
               enableStubbing: true)
    }
    
    func testStubbingWithMethodsEnabled() {
        verify(srcContent: stubbingWithMethodsProtocol,
               dstContent: stubbingWithMethodsMockEnabled,
               enableStubbing: true)
    }
    
    func testStubbingWithPropertiesEnabled() {
        verify(srcContent: stubbingWithPropertiesProtocol,
               dstContent: stubbingWithPropertiesMockEnabled,
               enableStubbing: true)
    }
    
    func testStubbingDisabled() {
        verify(srcContent: basicStubbingProtocol,
               dstContent: basicStubbingMockDisabled)
    }
}