import MockoloFramework

// MARK: - Basic Stubbing Test

let basicStubbingProtocol = """
/// @mockable
protocol BasicService {
    func performAction() -> String
    var title: String { get set }
}
"""

let basicStubbingMockEnabled = """
class BasicServiceMock: BasicService {
    private var _stub: BasicService?
    init() { }
    init(stub: BasicService? = nil) { self._stub = stub }


    private var _title: String = ""
    public var titleSetCallCount = 0
    public var title: String {
        get { 
            if let _stub = _stub { return _stub.title }
            return _title 
        }
        set { _title = newValue }
    }

    public private(set) var performActionCallCount = 0
    public var performActionHandler: (() -> String)?
    public func performAction() -> String {
        performActionCallCount += 1
        if let performActionHandler = performActionHandler {
            return performActionHandler()
        } else if let _stub = _stub {
            return _stub.performAction()
        }
        return ""
    }
}
"""

// MARK: - Stubbing with Methods Test

let stubbingWithMethodsProtocol = """
/// @mockable
protocol ServiceWithMethods {
    func calculate(x: Int, y: Int) -> Int
    func process(data: String) async throws -> Bool
}
"""

let stubbingWithMethodsMockEnabled = """
class ServiceWithMethodsMock: ServiceWithMethods {
    private var _stub: ServiceWithMethods?
    init() { }
    init(stub: ServiceWithMethods? = nil) { self._stub = stub }


    public private(set) var calculateCallCount = 0
    public var calculateHandler: ((Int, Int) -> Int)?
    public func calculate(x: Int, y: Int) -> Int {
        calculateCallCount += 1
        if let calculateHandler = calculateHandler {
            return calculateHandler(x, y)
        } else if let _stub = _stub {
            return _stub.calculate(x: x, y: y)
        }
        return 0
    }

    public private(set) var processCallCount = 0
    public var processHandler: ((String) async throws -> Bool)?
    public func process(data: String) async throws -> Bool {
        processCallCount += 1
        if let processHandler = processHandler {
            return try await processHandler(data)
        } else if let _stub = _stub {
            return try await _stub.process(data: data)
        }
        return false
    }
}
"""

// MARK: - Stubbing with Properties Test

let stubbingWithPropertiesProtocol = """
/// @mockable
protocol ServiceWithProperties {
    var name: String { get }
    var count: Int { get set }
    var isEnabled: Bool { get }
}
"""

let stubbingWithPropertiesMockEnabled = """
class ServiceWithPropertiesMock: ServiceWithProperties {
    private var _stub: ServiceWithProperties?
    init() { }
    init(stub: ServiceWithProperties? = nil) { self._stub = stub }


    private var _name: String = ""
    public var name: String {
        get { 
            if let _stub = _stub { return _stub.name }
            return _name 
        }
        set { _name = newValue }
    }

    private var _count: Int = 0
    public var countSetCallCount = 0
    public var count: Int {
        get { 
            if let _stub = _stub { return _stub.count }
            return _count 
        }
        set { _count = newValue }
    }

    private var _isEnabled: Bool = false
    public var isEnabled: Bool {
        get { 
            if let _stub = _stub { return _stub.isEnabled }
            return _isEnabled 
        }
        set { _isEnabled = newValue }
    }
}
"""

// MARK: - Stubbing Disabled Test

let basicStubbingMockDisabled = """
class BasicServiceMock: BasicService {
    init() { }


    private var _title: String = ""
    public var titleSetCallCount = 0
    public var title: String {
        get { 
            return _title 
        }
        set { _title = newValue }
    }

    public private(set) var performActionCallCount = 0
    public var performActionHandler: (() -> String)?
    public func performAction() -> String {
        performActionCallCount += 1
        if let performActionHandler = performActionHandler {
            return performActionHandler()
        }
        return ""
    }
}
"""