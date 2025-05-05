## 0.4.0 - unreleased

- Added colored diff output when readme build/yard commands finish, showing changes to README.md using the Diffy gem

## 0.3.0 - 2025-05-04

- Update dependencies: upgraded yard-readme to 0.5.0, Ruby requirement to >= 3.0
- Add TagRegistry class to centralize tag management
- Update bundler and various gem dependencies
- Improve command-line argument handling in the readme executable
- Extract YardOptsManager to improve code organization
- Rename ObjectTag to SourceTag and rename old SourceTag to CodeTag
- Add new ValueTag and StringTag
- Add standalone tag support: enable embedding yard content in README without yard tags in the source code
- Rename format methods for consistency
- Rename `readme doc` command to `readme yard` for clarity and improved memorability

## 0.2.0 - 2021-08-08

- Add new readme tag types - `comment`, `source`, and `object`. Log warnings and raise errors when helpful. Update README. 51997f24d5209fd8f0e5e11511352f6457bb9dbe

## 0.1.2 - 2021-08-06

- Fix error message markdown parsing. 0f1c3fa4f39c6d7a1628f81e1ea41489b7021254
- Improve error message when the object path isn't found. 9bdcabd2a90ba94a7e7a1fbbfe872550034c83c3
- Fix links in documentation + small copy edits. 63d5608fdee6757f314a315509dda31710087f60

## 0.1.1 - 2021-07-30

- First Implementation, the README will hopefully get you started. Please open an issue if it doesn't 🙂.


## 0.1.0 - 2021-07-25

- Initial release
