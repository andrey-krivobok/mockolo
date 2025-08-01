# Stubbing Feature для Mockolo

## Описание

Добавлен функционал стаббинга в фреймворк Mockolo, который позволяет инициализировать моки с реальным объектом для проксирования вызовов методов и доступа к свойствам по умолчанию.

## Функциональность

### Основные возможности

1. **Опциональный stub параметр в инициализаторах**: Все сгенерированные моки теперь имеют дополнительный инициализатор с параметром `stub`
2. **Проксирование методов**: Если handler не установлен и stub предоставлен, вызовы методов проксируются к реальному объекту
3. **Проксирование свойств**: Если stub предоставлен, геттеры свойств проксируются к реальному объекту
4. **Обратная совместимость**: Существующий код продолжает работать без изменений

### Пример использования

```swift
/// @mockable
protocol UserService {
    func getUserName() -> String
    var userCount: Int { get }
}

class RealUserService: UserService {
    func getUserName() -> String {
        return "John Doe"
    }
    
    var userCount: Int = 42
}

// Использование со стаббингом
let realService = RealUserService()
let mock = UserServiceMock(stub: realService)

// Проксирование к реальному объекту
print(mock.getUserName()) // "John Doe"
print(mock.userCount)     // 42

// Переопределение через handler
mock.getUserNameHandler = { "Mocked User" }
print(mock.getUserName()) // "Mocked User"

// Обычное использование без стаббинга
let normalMock = UserServiceMock()
print(normalMock.getUserName()) // "" (значение по умолчанию)
```

## Сгенерированный код

### С включенным стаббингом (enableStubbing: true)

```swift
class UserServiceMock: UserService {
    private var _stub: UserService?
    init() { }
    init(stub: UserService? = nil) { self._stub = stub }

    public private(set) var getUserNameCallCount = 0
    public var getUserNameHandler: (() -> String)?
    public func getUserName() -> String {
        getUserNameCallCount += 1
        if let getUserNameHandler = getUserNameHandler {
            return getUserNameHandler()
        } else if let _stub = _stub {
            return _stub.getUserName()
        }
        return ""
    }

    private var _userCount: Int = 0
    public var userCount: Int {
        get { 
            if let _stub = _stub { return _stub.userCount }
            return _userCount 
        }
        set { _userCount = newValue }
    }
}
```

### С выключенным стаббингом (enableStubbing: false)

```swift
class UserServiceMock: UserService {
    init() { }

    public private(set) var getUserNameCallCount = 0
    public var getUserNameHandler: (() -> String)?
    public func getUserName() -> String {
        getUserNameCallCount += 1
        if let getUserNameHandler = getUserNameHandler {
            return getUserNameHandler()
        }
        return ""
    }

    private var _userCount: Int = 0
    public var userCount: Int = 0
}
```

## Конфигурация

Функционал стаббинга контролируется параметром `enableStubbing` в `GenerationArguments`:

- **По умолчанию**: `false` (для обратной совместимости)
- **Для включения**: передать `enableStubbing: true` в параметрах генерации

## Архитектурные изменения

### Измененные файлы

1. **ParsedEntity.swift**: Добавлен параметр `enableStubbing` в `GenerationArguments`
2. **NominalTemplate.swift**: Добавлена генерация stub свойства и инициализатора
3. **ClosureTemplate.swift**: Добавлена логика проксирования к stub объекту
4. **VariableTemplate.swift**: Добавлена логика проксирования свойств к stub объекту
5. **Generator.swift**: Передача параметра `enableStubbing`
6. **MockoloTestCase.swift**: Поддержка параметра в тестах

### Новые тесты

- **TestStubbing/**: Директория с тестами функционала стаббинга
- **StubbingTests.swift**: Основные тесты стаббинга
- **FixtureStubbing.swift**: Фикстуры для тестов

## Преимущества

1. **Частичное мокирование**: Возможность мокировать только часть методов, оставляя остальные делегированными реальному объекту
2. **Упрощение тестов**: Меньше кода для настройки моков в простых случаях
3. **Гибкость**: Можно комбинировать реальную логику с мокированными частями
4. **Обратная совместимость**: Существующий код не требует изменений

## Ограничения

1. Stub объект должен реализовывать тот же протокол что и мок
2. Изменения свойств в моке не отражаются на stub объекте
3. Функционал доступен только при включенном флаге `enableStubbing`