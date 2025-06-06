# Android Test Report Action Cross-platform

[![Release](https://img.shields.io/github/release/Borealin/android-test-report-action.svg)](https://github.com/Borealin/android-test-report-action/releases)
[![Marketplace](https://img.shields.io/badge/GitHub-Marketplace-orange.svg)](https://github.com/marketplace/actions/android-test-report-action-cross-platform)

GitHub Action that prints Android test xml reports.

**✨ Now with full cross-platform support!** 🪟🐧🍎

![action](./images/promo.png)

<br>

## What's New

This action has been migrated from Docker to a **composite action** using [`@actions/setup-python`](https://github.com/actions/setup-python). This brings several benefits:

- ⚡ **Faster execution** - No Docker image build/pull time
- 🏃‍♂️ **Better performance** - Runs directly on the runner OS
- 🌍 **Cross-platform support** - Works on Linux, macOS, and Windows

## Getting Started

Add the following action to your GitHub Actions workflow.

```yml
- name: Android Test Report
  uses: Borealin/android-test-report-action@v1.0.0
```

<br>

## Usage

### Basic

Once the test command has been executed, the Android Test Report action will parse all of the XML reports and output the results in a structured way.

```yml
name: Android CI
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: set up JDK 1.8
        uses: actions/setup-java@v4
        with:
          java-version: 1.8

      # Execute unit tests
      - name: Unit Test
        run: ./gradlew testDebugUnitTest

      - name: Android Test Report
        uses: Borealin/android-test-report-action@v1.0.0
        if: ${{ always() }} # IMPORTANT: run Android Test Report regardless
```
#### Note
The workflow must contain the unit test job prior to running the Android Test Report action. **The action will automatically pass or fail the job depending on the test results.**

<br>

### Alternate

If the basic usage fails to meet your requirement (running on MacOS machine or anything else), split the test and report into two jobs. The test job will run the tests and save the reports as artifacts. The report job will use the Android Test Report action to parse and print the results. Consider the following example below.

```yml
jobs:
  test:
    runs-on: macos-latest # or any other machine
    steps:
      ...
      - name: Unit Test
        run: ./gradlew testDebugUnitTest

      - name: Upload Test Reports Folder
        uses: actions/upload-artifact@v4
        if: ${{ always() }} # IMPORTANT: Upload reports regardless of status
        with:
          name: reports
          path: app/build/test-results # path to where the xml test results are stored
        
  report:
    runs-on: ubuntu-latest
    needs: test # The report job will run after test job
    if: ${{ always() }} # IMPORTANT: Execute report job regardless of status
    steps:
      - name: Download Test Reports Folder
        uses: actions/download-artifact@v4
        with:
          name: reports

      - name: Android Test Report
        uses: Borealin/android-test-report-action@v1.0.0
```

<br>

## Output

![action](./images/output.png)

<br>

## Sample Project

To learn how to use this action in an Android application, check out the following example repository:
https://github.com/asadmansr/android-test-report-action-example

- master branch: Passed pipeline as all the tests passed
- failed-pipeline branch: Failed pipeline as some of the tests failed
