// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import FirebaseCore
import FirebaseVertexAI
import XCTest

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
final class IntegrationTests: XCTestCase {
  // Set temperature, topP and topK to lowest allowed values to make responses more deterministic.
  let generationConfig = GenerationConfig(
    temperature: 0.0,
    topP: 0.0,
    topK: 1,
    responseMIMEType: "text/plain"
  )
  let systemInstruction = ModelContent(
    role: "system",
    parts: "You are a friendly and helpful assistant."
  )

  var vertex: VertexAI!
  var model: GenerativeModel!

  override func setUp() async throws {
    try XCTSkipIf(ProcessInfo.processInfo.environment["VertexAIRunIntegrationTests"] == nil, """
    Vertex AI integration tests skipped; to enable them, set the VertexAIRunIntegrationTests \
    environment variable in Xcode or CI jobs.
    """)

    let plistPath = try XCTUnwrap(Bundle.module.path(
      forResource: "GoogleService-Info",
      ofType: "plist"
    ))
    let options = try XCTUnwrap(FirebaseOptions(contentsOfFile: plistPath))
    FirebaseApp.configure(options: options)

    vertex = VertexAI.vertexAI()
    model = vertex.generativeModel(
      modelName: "gemini-1.5-flash",
      generationConfig: generationConfig,
      tools: [],
      systemInstruction: systemInstruction
    )
  }

  override func tearDown() async throws {
    if let app = FirebaseApp.app() {
      await app.delete()
    }
  }

  // MARK: - Generate Content

  func testGenerateContent() async throws {
    let prompt = "Where is Google headquarters located? Answer with the city name only."

    let response = try await model.generateContent(prompt)

    let text = try XCTUnwrap(response.text).trimmingCharacters(in: .whitespacesAndNewlines)
    XCTAssertEqual(text, "Mountain View")
  }

  // MARK: - Count Tokens

  func testCountTokens_text() async throws {
    let prompt = "Why is the sky blue?"

    let response = try await model.countTokens(prompt)

    XCTAssertEqual(response.totalTokens, 14)
    XCTAssertEqual(response.totalBillableCharacters, 51)
  }

  func testCountTokens_image_inlineData() async throws {
    guard let image = UIImage(systemName: "cloud") else {
      XCTFail("Image not found.")
      return
    }

    let response = try await model.countTokens(image)

    XCTAssertEqual(response.totalTokens, 266)
    XCTAssertEqual(response.totalBillableCharacters, 35)
  }

  func testCountTokens_image_fileData() async throws {
    let fileData = ModelContent(parts: [.fileData(
      mimetype: "image/jpeg",
      uri: "gs://ios-opensource-samples.appspot.com/ios/public/blank.jpg"
    )])

    let response = try await model.countTokens([fileData])

    XCTAssertEqual(response.totalTokens, 266)
    XCTAssertEqual(response.totalBillableCharacters, 35)
  }

  func testCountTokens_functionCalling() async throws {
    let sumDeclaration = FunctionDeclaration(
      name: "sum",
      description: "Adds two integers.",
      parameters: ["x": .integer(), "y": .integer()]
    )
    model = vertex.generativeModel(
      modelName: "gemini-1.5-flash",
      tools: [Tool(functionDeclarations: [sumDeclaration])]
    )
    let prompt = "What is 10 + 32?"
    let sumCall = FunctionCall(name: "sum", args: ["x": .number(10), "y": .number(32)])
    let sumResponse = FunctionResponse(name: "sum", response: ["result": .number(42)])

    let response = try await model.countTokens([
      ModelContent(role: "user", parts: [.text(prompt)]),
      ModelContent(role: "model", parts: [.functionCall(sumCall)]),
      ModelContent(role: "function", parts: [.functionResponse(sumResponse)]),
    ])

    XCTAssertEqual(response.totalTokens, 24)
    XCTAssertEqual(response.totalBillableCharacters, 71)
  }
}
