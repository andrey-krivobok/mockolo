# Исправление ошибки компиляции

## Проблема
```
/Users/andrey/mockolo/Sources/Mockolo/Executor.swift:205:82: error: missing argument for parameter 'enableStubbing' in call
                         disableCombineDefaultValues: disableCombineDefaultValues,
```

## Причина
При добавлении функционала стаббинга был добавлен новый параметр `enableStubbing` в функцию `generate()` в `Generator.swift`, но соответствующий параметр не был добавлен в CLI интерфейс в `Executor.swift`.

## Решение

### 1. Добавлен флаг командной строки в Executor.swift

```swift
@Flag(name: .long,
      help: "Whether to enable stubbing functionality in generated mocks (default = false). When enabled, mocks can be initialized with a real object for proxying method calls and property access.")
private var enableStubbing: Bool = false
```

### 2. Добавлен параметр в вызов generate()

```swift
try generate(sourceDirs: srcDirs,
             sourceFiles: srcs,
             parser: SourceParser(),
             exclusionSuffixes: exclusionSuffixes,
             mockFilePaths: mockFilePaths,
             annotation: annotation,
             header: header,
             macro: macro,
             declType: mockAll ? .all : .protocolType,
             useTemplateFunc: useTemplateFunc,
             allowSetCallCount: allowSetCallCount,
             enableFuncArgsHistory: enableArgsHistory,
             disableCombineDefaultValues: disableCombineDefaultValues,
             enableStubbing: enableStubbing,  // ← Добавлено
             mockFinal: mockFinal,
             testableImports: testableImports,
             customImports: customImports,
             excludeImports: excludeImports,
             to: outputFilePath,
             loggingLevel: loggingLevel,
             concurrencyLimit: concurrencyLimit)
```

## Использование

Теперь функционал стаббинга можно включить через командную строку:

```bash
# Без стаббинга (по умолчанию)
mockolo --sourcedirs Sources --destination Mocks.swift

# С включенным стаббингом
mockolo --sourcedirs Sources --destination Mocks.swift --enable-stubbing
```

## Проверка

После этих изменений проект должен компилироваться без ошибок. Функционал стаббинга будет доступен через флаг `--enable-stubbing` в командной строке.

## Измененные файлы

- `Sources/Mockolo/Executor.swift` - добавлен флаг `--enable-stubbing` и передача параметра в функцию generate()

## Статус

✅ **Ошибка компиляции исправлена**
✅ **CLI интерфейс обновлен**  
✅ **Функционал доступен через командную строку**
✅ **Обратная совместимость сохранена** (по умолчанию стаббинг выключен)