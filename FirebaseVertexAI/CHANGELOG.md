# 11.4.0
- [changed] **Breaking Change**: The `HarmCategory` enum is no longer nested
  inside the `SafetySetting` struct and the `unspecified` case has been
  removed. (#13686)
- [changed] **Breaking Change**: The `BlockThreshold` enum in `SafetySetting`
  has been renamed to `HarmBlockThreshold`. (#13696)
- [changed] **Breaking Change**: The `unspecified` case has been removed from
  the `FinishReason`, `BlockReason` and `HarmProbability` enums; this scenario
  is now handled by the existing `unknown` case. (#13699)
- [changed] **Breaking Change**: The `data` case in the `Part` enum has been
  renamed to `inlineData`; no functionality changes. (#13700)
- [changed] **Breaking Change**: The property `citationSources` of
  `CitationMetadata` has been renamed to `citations`. (#13702)
- [changed] **Breaking Change**: The constructor for `Schema` is now deprecated;
  use the new static methods `Schema.string(...)`, `Schema.object(...)`, etc.,
  instead. (#13616)
- [changed] **Breaking Change**: The constructor for `FunctionDeclaration` now
  accepts an array of *optional* parameters instead of a list of *required*
  parameters; if a parameter is not listed as optional it is assumed to be
  required. (#13616)
- [changed] **Breaking Change**: `CountTokensResponse.totalBillableCharacters`
  is now optional (`Int?`); it may be `null` in cases such as when a
  `GenerateContentRequest` contains only images or other non-text content.
  (#13721)
- [changed] **Breaking Change**: The `ImageConversionError` enum is no longer
  public; image conversion errors are still reported as
  `GenerateContentError.promptImageContentError`. (#13735)
- [changed] **Breaking Change**: The `CountTokensError` enum has been removed;
  errors occurring in `GenerativeModel.countTokens(...)` are now thrown directly
  instead of being wrapped in a `CountTokensError.internalError`. (#13736)
- [changed] The default request timeout is now 180 seconds instead of the
  platform-default value of 60 seconds for a `URLRequest`; this timeout may
  still be customized in `RequestOptions`. (#13722)
- [changed] The response from `GenerativeModel.countTokens(...)` now includes
  `systemInstruction`, `tools` and `generationConfig` in the `totalTokens` and
  `totalBillableCharacters` counts, where applicable. (#13813)

# 11.3.0
- [added] Added `Decodable` conformance for `FunctionResponse`. (#13606)
- [changed] **Breaking Change**: Reverted refactor of `GenerativeModel` and
  `Chat` as Swift actors (#13545) introduced in 11.2; The methods
  `generateContentStream`, `startChat` and `sendMessageStream` no longer need to
  be called with `await`. (#13703)

# 11.2.0
- [fixed] Resolved a decoding error for citations without a `uri` and added
  support for decoding `title` fields, which were previously ignored. (#13518)
- [changed] **Breaking Change**: The methods for starting streaming requests
  (`generateContentStream` and `sendMessageStream`) are now throwing and
  asynchronous and must be called with `try await`. (#13545, #13573)
- [changed] **Breaking Change**: Creating a chat instance (`startChat`) is now
  asynchronous and must be called with `await`. (#13545)
- [changed] **Breaking Change**: The source image in the
  `ImageConversionError.couldNotConvertToJPEG` error case is now an enum value
  instead of the `Any` type. (#13575)
- [added] Added support for specifying a JSON `responseSchema` in
  `GenerationConfig`; see
  [control generated output](https://cloud.google.com/vertex-ai/generative-ai/docs/multimodal/control-generated-output)
  for more details. (#13576)

# 10.29.0
- [feature] Added community support for watchOS. (#13215)

# 10.28.0
- [changed] Removed uses of the `gemini-1.5-flash-preview-0514` model in docs
  and samples. Developers should now use the auto-updated versions,
  `gemini-1.5-pro` or `gemini-1.5-flash`, or a specific stable version; see
  [available model names](https://firebase.google.com/docs/vertex-ai/gemini-models#available-model-names)
  for more details. (#13099)
- [feature] Added community support for tvOS and visionOS. (#13090, #13092)

# 10.27.0
- [changed] Removed uses of the `gemini-1.5-pro-preview-0409` model in docs and
  samples. Developers should now use `gemini-1.5-pro-preview-0514` or
  `gemini-1.5-flash-preview-0514`; see
  [available model names](https://firebase.google.com/docs/vertex-ai/gemini-models#available-model-names)
  for more details. (#12979)
- [changed] Logged additional details when required APIs for Vertex AI are
  not enabled or response payloads when requests fail. (#13007, #13009)

# 10.26.0
- [feature] Initial release of the Vertex AI for Firebase SDK (public preview).
  Learn how to
  [get started](https://firebase.google.com/docs/vertex-ai/get-started?platform=ios)
  with the SDK in your app.
