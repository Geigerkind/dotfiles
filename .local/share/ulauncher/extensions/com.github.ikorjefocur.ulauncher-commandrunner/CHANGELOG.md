# Changelog

## 1.1.0 (01-03-2022)

### New features
- Added support for setting additional commands that not listed in $PATH, such as aliases, functions or anything else.

## 1.0.1 (28-02-2022)

### Bug fixes
- Fixed script lock by subprocess, which makes plugin unavilable while some command already running.

## 1.0.0 (23-02-2022)

### Breaking changes
- Changed terminal preference syntax from simple string to pattern.
- Now input commands passing without any additional formatting, except escaping quotes for shell or/and terminal wrapping.

### New features
- Added shell wrapper preference. That means possibility to use any shell features like enviroment variables, special characters, etc..