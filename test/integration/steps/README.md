# Integration step definitions

Step definitions for corpus scenarios that cross the file system. By their strongest boundary they are integration
level, so they live here, outside `test/features` (unit). Their scenarios carry the `@integration` tag and run only in
`mix test:integration`.
