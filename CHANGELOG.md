## 0.6.2
- FIX: do not generate if nothing is annotated

## 0.6.1
- FIX: update readme

## 0.6.0

- FEAT: add `NotNull` annotation 
- FEAT: add `assertRequiredOnInsert` method for annotated class instance that checks required values for nulls on inserting
- FEAT: add `toCompanion` method for annotated class instance
- BREAKING: using as part directive 

## 0.5.3

- FEAT: add computed field using `Computed` annotation

## 0.5.2

- FEAT: provide foreign keys without model importing using `UseDrift`.`foreignKeys` annotation 

## 0.5.1

- FIX: change versions: build: ^2.3.1, analyzer: ^5.0.0, source_gen: ^1.2.3

## 0.5.0

- FIX: change versions: `build` >=2.0.0 <3.0.0, `analyzer` >=4.0.0 <6.0.0, `sdk` >=2.17.0 <3.0.0

## 0.4.1

- FEAT: resume support `UniqueKey` annotation for single fields
- FIX: comma is missing when using multiple composite unique keys

## 0.4.0

- BREAKING: no longer support `UniqueKey` annotation, use `uniqueKeys` param of `UseDrift` annotation instead
- BREAKING: no longer support `Nullable` annotation, `nullable` values will be auto-dectected

## 0.3.1

- FEAT: support BigInt (autoincrement for int64 does not support by drift at 20.12.22)

## 0.3.0

- FEAT: exclude automaticly referenced by fields
- FIX: do not import enums in generated code

## 0.2.1

- FIX: clear additional imports when library changes

## 0.2.0

- BREAKING: fix `exludeFields` > `excludeFields`
- FIX: do not import excluded fields related classes

## 0.1.2

- FIX: add import only for single relation

## 0.1.1

- FIX: add imports for related files

## 0.1.0

- FEAT: add `autoReferenceEnums` for `@UseDrift`, all enums can be automaticly referenced

## 0.0.3

- FEAT: add support for classes without fields, using main constructor
- FEAT: add a `freezed` annotated class to example

## 0.0.2

- BREAKING: change generated files extension to `.driftm`
- FIX: do not generate if nothing is annotated

## 0.0.1

- Initial version.