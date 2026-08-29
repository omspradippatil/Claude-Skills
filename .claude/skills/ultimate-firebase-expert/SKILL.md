---
name: ultimate-firebase-expert
description: Consolidated ultimate skill containing expert knowledge for firebase expert. Use this for all tasks in this domain.
---

# Ultimate Firebase Expert

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request. Do not mix conflicting styles or rules.

## Skill Catalog

### firebase-ai-logic-basics
**Description:** Official skill for integrating Firebase AI Logic (Gemini API) into web applications. Covers setup, multimodal inference, structured output, and security.


#### Firebase AI Logic Basics

##### Overview

Firebase AI Logic is a product of Firebase that allows developers to add gen AI
to their mobile and web apps using client-side SDKs. You can call Gemini models
directly from your app without managing a dedicated backend. Firebase AI Logic,
which was previously known as "Vertex AI for Firebase", represents the evolution
of Google's AI integration platform for mobile and web developers.

It supports the two Gemini API providers:

-   **Gemini Developer API**: It has a free tier ideal for prototyping, and
    pay-as-you-go for production
-   **Agent Platform Gemini API** (formerly branded Vertex AI): Ideal for scale
    with enterprise-grade production readiness, requires Blaze plan

Use the Gemini Developer API as a default, and only Agent Platform Gemini API
(formerly branded Vertex AI) if the application requires it.

##### Setup & Initialization

###### Prerequisites

-   Before starting, ensure you have **Node.js 16+** and npm installed. Install
    them if they aren’t already available.
-   Identify the platform the user is interested in building on prior to
    starting: Android, iOS, Flutter or Web.
-   If their platform is unsupported, Direct the user to Firebase Docs to learn
    how to set up AI Logic for their application (share this link with the user
    https://firebase.google.com/docs/ai-logic/get-started)

###### Installation

The library is part of the standard Firebase Web SDK.

`npm install -g firebase@latest`

If you're in a firebase directory (with a firebase.json) the currently selected
project will be marked with "current" using this command:

`npx -y firebase-tools@latest projects:list`

Ensure there's at least one app associated with the current project

`npx -y firebase-tools@latest apps:list`

Initialize AI logic SDK with the init command

`npx -y firebase-tools@latest init ailogic`

This will automatically enable the Gemini Developer API in the Firebase console.

More info in
[Firebase AI Logic Getting Started](https://firebase.google.com/docs/ai-logic/get-started.md.txt)

##### Core Capabilities

> [!WARNING] **CRITICAL: Use current model names:** Always check the
> [Firebase AI Logic Models documentation](https://firebase.google.com/docs/ai-logic/models.md.txt)
> for the currently supported model names. Do NOT use `gemini-2.0-pro` or
> `gemini-2.0-flash` or other older models that are shutdown.

###### Text-Only Generation

###### Multimodal (Text + Images/Audio/Video/PDF input)

Firebase AI Logic allows Gemini models to analyze image files directly from your
app. This enables features like creating captions, answering questions about
images, detecting objects, and categorizing images. Beyond images, Gemini can
analyze other media types like audio, video, and PDFs by passing them as inline
data with their MIME type. For files larger than 20 megabytes (which can cause
HTTP 413 errors as inline data), store them in Cloud Storage for Firebase and
pass their URLs to the Gemini Developer API.

###### Chat Session (Multi-turn)

Maintain history automatically using `startChat`.

###### Streaming Responses

To improve the user experience by showing partial results as they arrive (like a
typing effect), use `generateContentStream` instead of `generateContent` for
faster display of results.

###### Generate Images with Nano Banana

> [!WARNING] **Use current Image model names:** Always check the
> [Firebase AI Logic Models documentation](https://firebase.google.com/docs/ai-logic/models.md.txt)
> for the currently supported image generation (Nano Banana) model names.

-   Requires an upgraded Blaze pay-as-you-go billing plan.

###### Search Grounding with the built in googleSearch tool

##### Supported Platforms and Frameworks

Supported Platforms and Frameworks include Kotlin and Java for Android, Swift
for iOS, JavaScript for web apps, Dart for Flutter, and C Sharp for Unity.

##### Advanced Features

###### Structured Output (JSON)

Enforce a specific JSON schema for the response.

###### On-Device AI (Hybrid)

Hybrid on-device inference for web apps, where the Firebase Javascript SDK
automatically checks for Gemini Nano's availability (after installation) and
switches between on-device or cloud-hosted prompt execution. This requires
specific steps to enable model usage in the Chrome browser, more info in the
[hybrid-on-device-inference documentation](https://firebase.google.com/docs/ai-logic/hybrid-on-device-inference.md.txt).

##### Security & Production

###### App Check

> [!WARNING] **Critical Safety Requirement:** In order to use AI Logic safely,
> you MUST set up App Check on your app. This prevents unauthorized clients from
> using your API quota and accessing your backend resources.

See
[App Check with reCAPTCHA Enterprise](https://firebase.google.com/docs/app-check/web/recaptcha-enterprise-provider.md.txt)
for setup instructions.

####### App Check Debug Tokens for Local Development & CI/CD

Because App Check attestation providers (like Play Integrity or DeviceCheck)
reject emulators, simulators, or CI environments, you must use **App Check Debug
Tokens** during development and testing to bypass standard attestation.

######## Local Development (Auto-Generated)

1.  Configure your code's App Check provider to use the debug factory:
    *   **Web**: Set `self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;` before
        initializing App Check.
    *   **Android**: Install `DebugAppCheckProviderFactory.getInstance()`.
    *   **iOS**: Set provider factory to `AppCheckDebugProviderFactory()`.
2.  Run your app in the emulator/localhost.
3.  Look at your runtime debugger console / Logcat logs for the generated UUID:
    *   *Example:* `AppCheck debug token:
        "123a4567-b89c-12d3-e456-789012345678"`
4.  Register this token in the Firebase Console under **Security > App Check >
    Apps > Manage debug tokens**.

######## CI/CD Pipelines (Pre-Provisioned)

1.  Generate and register a new debug token in the Firebase Console under
    **Security > App Check > Apps > Manage debug tokens**.
2.  Add this token string as an encrypted secret in your CI system (e.g.
    `APP_CHECK_DEBUG_TOKEN`).
3.  Configure your build to pass this secret as an environment variable to the
    SDK during test execution (e.g. `self.FIREBASE_APPCHECK_DEBUG_TOKEN =
    process.env.APP_CHECK_DEBUG_TOKEN`).

###### Remote Config

Consider that you do not need to hardcode model names (e.g., a specific model
version string). Use Firebase Remote Config to update model versions dynamically
without deploying new client code. See
[Changing model names remotely](https://firebase.google.com/docs/ai-logic/change-model-name-remotely.md.txt)

> [!WARNING] **CRITICAL: Backend Provisioning Required** For all platforms
> (Flutter, Android, iOS, Web), you MUST run `npx firebase-tools init ailogic`
> to provision the service. `flutterfire configure` ONLY handles client
> configuration and does NOT enable the AI service, leading to
> `PERMISSION_DENIED` errors.

##### Initialization Code References

| Language,   | Gemini API | Context URL                                     |
: Framework,  : provider   :                                                 :
: Platform    :            :                                                 :
| :---------- | :--------- | :---------------------------------------------- |
| Web Modular | Gemini     | firebase://docs/ai-logic/get-started            |
: API         : Developer  :                                                 :
:             : API        :                                                 :
:             : (Developer :                                                 :
:             : API)       :                                                 :
| iOS (Swift) | Gemini     | [ios_setup.md](references/ios_setup.md)         |
:             : Developer  :                                                 :
:             : API        :                                                 :
| Flutter     | Gemini     | [flutter_setup.md](references/flutter_setup.md) |
: (Dart)      : Developer  :                                                 :
:             : API        :                                                 :

> [!WARNING] **CRITICAL: Use current model names:** Always check the
> [Firebase AI Logic Models documentation](https://firebase.google.com/docs/ai-logic/models.md.txt)
> for the currently supported model names. Do NOT use `gemini-2.0-pro` or
> `gemini-2.0-flash` or other older models that are shutdown.

##### References

[Web SDK code examples and usage patterns](references/usage_patterns_web.md)
[iOS SDK code examples and usage patterns](references/ios_setup.md)
[Flutter SDK code examples and usage patterns](references/flutter_setup.md)

[Android (Kotlin) SDK usage patterns](references/usage_patterns_android.md)


---

### firebase-auth-basics
**Description:** Guide for setting up and using Firebase Authentication. Use this skill when the user's app requires user sign-in, user management, or secure data access using auth rules.


##### Prerequisites

- **Firebase Project**: Created via
  `npx -y firebase-tools@latest projects:create` (see `firebase-basics`).
- **Firebase CLI**: Installed and logged in (see `firebase-basics`).

##### Core Concepts

Firebase Authentication provides backend services, easy-to-use SDKs, and
ready-made UI libraries to authenticate users to your app.

###### Users

A user is an entity that can sign in to your app. Each user is identified by a
unique ID (`uid`) which is guaranteed to be unique across all providers. User
properties include:

- `uid`: Unique identifier.
- `email`: User's email address (if available).
- `displayName`: User's display name (if available).
- `photoURL`: URL to user's photo (if available).
- `emailVerified`: Boolean indicating if the email is verified.

###### Identity Providers

Firebase Auth supports multiple ways to sign in:

- **Email/Password**: Basic email and password authentication.
- **Federated Identity Providers**: Google, Facebook, Twitter, GitHub,
  Microsoft, Apple, etc.
- **Phone Number**: SMS-based authentication.
- **Anonymous**: Temporary guest accounts that can be linked to permanent
  accounts later.
- **Custom Auth**: Integrate with your existing auth system.

Google Sign In is recommended as a good and secure default provider.

###### Tokens

When a user signs in, they receive an ID Token (JWT). This token is used to
identify the user when making requests to Firebase services (Realtime Database,
Cloud Storage, Firestore) or your own backend.

- **ID Token**: Short-lived (1 hour), verifies identity.
- **Refresh Token**: Long-lived, used to get new ID tokens.

##### Workflow

###### 1. Provisioning

####### Option 1. Enabling Authentication via CLI

Only Google Sign In, anonymous auth, and email/password auth can be enabled via
CLI. For other providers, use the Firebase Console.

Configure Firebase Authentication in `firebase.json` by adding an 'auth' block:

```
{
  "auth": {
  "authorizedDomains": ["localhost"],
    "providers": {
      "anonymous": true,
      "emailPassword": true,
      "googleSignIn": {
        "oAuthBrandDisplayName": "Your Brand Name",
        "supportEmail": "support@example.com"
      }
    }
  }
}
```

> [!NOTE] If the Google Sign-In popup opens and immediately closes with the
> error `[firebase_auth/unauthorized-domain]`, it means the domain is not
> authorized. For local development, ensure `localhost` is included in the
> **Authorized Domains** list in the Firebase Console or via the
> `authorizedDomains` field in `firebase.json`. **CRITICAL**: Do NOT include the
> protocol or port number in the Authorized Domains list (e.g., use `localhost`,
> NOT `http://localhost:9090`).

**CRITICAL**: After configuring `firebase.json`, you MUST deploy the auth
configuration to the Firebase backend for the changes to take effect. This is
essential for auth providers like Google Sign-In, email/password, etc. to
auto-generate the necessary OAuth clients for your app platforms. Run:

```bash
npx -y firebase-tools@latest deploy --only auth
```

####### Option 2. Enabling Authentication in Console

Enable other providers in the Firebase Console.

1. Go to the
   https://console.firebase.google.com/project/_/authentication/providers
1. Select your project.
1. Enable the desired Sign-in providers (e.g., Email/Password, Google).

###### 2. Client Setup & Usage

**Web** See [references/client_sdk_web.md](references/client_sdk_web.md).

**Flutter** See [references/flutter_setup.md](references/flutter_setup.md).
**Android (Kotlin)** See
[references/client_sdk_android.md](references/client_sdk_android.md).

###### 3. Security Rules

Secure your data using `request.auth` in Firestore/Storage rules.

See [references/security_rules.md](references/security_rules.md).


---

### firebase-firestore
**Description:** >-


#### Cloud Firestore Database and Operations

Before setting up dependencies, writing data models, or configuring security
rules, you MUST always identify the Firestore instance edition.

##### 1. Instance Selection and Edition Detection

Run the following command to list current Firestore databases:
`bash npx -y firebase-tools@latest firestore:databases:list`

###### A. Instance Found

1. For each database found, inspect its edition and details:
   `bash npx -y firebase-tools@latest firestore:databases:get <database-id>`
1. Ask the user which database instance they wish to target or if they would
   prefer to create a new instance.
1. Once the target instance is established:
   - If the **`edition`** is `STANDARD`, follow the guides under
     `references/standard/`.
   - If the **`edition`** is `ENTERPRISE` or native mode, follow the guides
     under `references/enterprise/`.

###### B. No Instance Found (or New Requested)

If no databases exist or the user requests a new one, default to provisioning an
**Enterprise** edition database and ask the user what location to use. Run
`npx -y firebase-tools@latest firestore:locations` to get the list of options.
Suggest colocating with other resources if applicable.

Once the location is determined, create the database:
`bash npx -y firebase-tools@latest firestore:databases:create <database-id> --edition="enterprise" --location="<selected-location>"`

Proceed with using the guides under `references/enterprise/`.

______________________________________________________________________

##### 2. Specialized Guides

Based on the identified or created instance edition, open and read the
corresponding reference guides:

###### Standard Edition (`references/standard/`)

- **Provisioning**: Read [provisioning.md](references/standard/provisioning.md)
- **Security Rules**: Read
  [security_rules.md](references/standard/security_rules.md)
- **SDK Usage**: Read [web_sdk_usage.md](references/standard/web_sdk_usage.md),
  [android_sdk_usage.md](references/standard/android_sdk_usage.md),
  [ios_setup.md](references/standard/ios_setup.md), or
  [flutter_setup.md](references/standard/flutter_setup.md)
- **Indexes**: Read [indexes.md](references/standard/indexes.md)

###### Enterprise Edition / Native Mode (`references/enterprise/`)

- **Provisioning**: Read
  [provisioning.md](references/enterprise/provisioning.md)

- **Data Model**: Read [data_model.md](references/enterprise/data_model.md)

- **Security Rules**: Read
  [security_rules.md](references/enterprise/security_rules.md)

- **SDK Usage**:

  > [!CRITICAL] **Mandatory Reference Reading** Before writing or modifying any
  > application code for Firestore Enterprise Edition, you **MUST** read at
  > least one of the relevant reference documents below for the target
  > platform/language to understand specific architectural requirements and
  > pipeline initialization patterns.

  Read [web_sdk_usage.md](references/enterprise/web_sdk_usage.md),
  [python_sdk_usage.md](references/enterprise/python_sdk_usage.md),
  [android_sdk_usage.md](references/enterprise/android_sdk_usage.md),
  [ios_setup.md](references/enterprise/ios_setup.md), or
  [flutter_setup.md](references/enterprise/flutter_setup.md)

- **Indexes**: Read [indexes.md](references/enterprise/indexes.md)


---

### firebase-crashlytics
**Description:** Comprehensive guide for Firebase Crashlytics, including provisioning and SDK usage. Use this skill when the user needs help setting up Crashlytics, adding crash reporting, or using the Crashlytics SDK in their application.


#### Crashlytics

This skill provides a complete guide for getting started with Crashlytics on
Android or iOS. Crash data collected from client applications can be read using
the MCP server in the Firebase CLI.

##### Prerequisites

Provisioning Crashlytics requires both a Firebase project and a Firebase app,
either Android or iOS. To read the data collected by Crashlytics, install the
MCP server in the Firebase CLI. See the `firebase-basics` skill for references.

##### SDK Setup

To learn how to setup Crashlytics in your application code, choose your
platform:

- **Android**: [android_setup.md](references/android_setup.md)
- **iOS**: [ios_setup.md](references/ios_setup.md)

##### SDK Usage

The SDK provides a number of features to make crash reports more actionable.

- Add custom keys
- Add custom logs
- Set user identifiers
- Report non-fatal exceptions

To learn how to customize crash reports and add additional debugging data,
consult the documentation for your platform.

- **Android**:
  [Customize Crash Reports for Android](https://firebase.google.com/docs/crashlytics/android/customize-crash-reports.md)
- **iOS**:
  [Customize Crash Reports for Apple Platforms](https://firebase.google.com/docs/crashlytics/ios/customize-crash-reports.md)


---

### firebase-security-rules-auditor
**Description:** >-


#### Overview

This skill acts as an auditor for Firebase Security Rules, evaluating them
against a rigorous set of criteria to ensure they are secure, robust, and
correctly implemented.

#### Scoring Criteria

##### Assessment: Security Validator (Red Team Edition)

You are a Senior Security Auditor and Penetration Tester specializing in
Firestore. Your goal is to find "the hole in the wall." Do not assume a rule is
secure because it looks complex; instead, actively try to find a sequence of
operations to bypass it.

###### Mandatory Audit Checklist:

1. **The Update Bypass:** Compare 'create' and 'update' rules. Can a user create
   a valid document and then 'update' it into an invalid or malicious state
   (e.g., changing their role, bypassing size limits, or corrupting data types)?
1. **Authority Source:** Does the security rely on user-provided data
   (request.resource.data) for sensitive fields like 'role', 'isAdmin', or
   'ownerId'? Carefully consider the source for that authority.
1. **Business Logic vs. Rules:** Does the rule set actually support the app's
   purpose? (e.g., In a collaboration app, can collaborators actually read the
   data? If not, the rules are "broken" or will force insecure workarounds).
1. **Storage Abuse:** Are there string length or array size limits? If not,
   label it as a "Resource Exhaustion/DoS" risk.
1. **Type Safety:** Are fields checked with 'is string', 'is int', or 'is
   timestamp'?
1. **Field-Level vs. Identity-Level Security:** Be careful with rules that use
   \`hasOnly()\` or \`diff()\`. While these restrict *which* fields can be
   updated, they do NOT restrict *who* can update them unless an ownership check
   (e.g., \`resource.data.uid == request.auth.uid\`) is also present. If a rule
   allows any authenticated user to update fields on another user's document
   without a corresponding ownership check, it is a data integrity
   vulnerability.

###### Admin Bootstrapping & Privileges:

The admin bootstrapping process is limited in this app. If the rules use a
single hardcoded admin email (e.g., checking request.auth.token.email ==
'admin@example.com'), this should NOT count against the score as long as:

- email_verified is also checked (request.auth.token.email_verified == true).
- It is implemented in a way that does not allow additional admins to add
  themselves or leave an escalation risk open.

###### Scoring Criteria (1-5):

- **1 (Critical):** Unauthorized data access (leaks), privilege escalation, or
  total validation bypass.
- **2 (Major):** Broken business logic, self-assigned roles, bypass of controls.
- **3 (Moderate):** PII exposure (e.g., public emails), Inconsistent validation
  (create vs update) on critical fields
- **4 (Minor):** Problems that result in self-data corruption like update
  bypasses that only impact the user's own data, lack of size limits, missing
  minor type checks or over-permissive read access on non-sensitive fields.
- **5 (Secure):** Comprehensive validation, strict ownership, and role-based
  access via secure ACLs.

Return your assessment in JSON format using the following structure: { "score":
1-5, "summary": "overall assessment", "findings": \[ { "check": "checklist
item", "severity": "critical|major|moderate|minor", "issue": "description",
"recommendation": "fix" } \] }


---

### firebase-basics
**Description:** >-


#### Prerequisites

Complete these setup steps before proceeding:

1. **Local Environment Setup:** Verify the environment is properly set up so we
   can use Firebase tools:

   - Run `npx -y firebase-tools@latest --version` to check if the Firebase CLI
     is installed.
   - Verify if the Firebase MCP server is installed using your existing tools.
   - **CRITICAL**: Before configuring any extensions or agent environments
     below, you MUST read
     [references/local-env-setup.md](references/local-env-setup.md).
   - **DO NOT SKIP** this step: if 'firebase-basics' is the only Firebase skill
     available to you, you must follow the reference for your agent environment
     to set up the full suite of Firebase skills:
     - **Gemini CLI**: Review
       [references/setup/gemini_cli.md](references/setup/gemini_cli.md)
     - **Antigravity**: Review
       [references/setup/antigravity.md](references/setup/antigravity.md)
     - **Android Studio**: Review
       [references/setup/android_studio.md](references/setup/android_studio.md)
     - **Claude Code**: Review
       [references/setup/claude_code.md](references/setup/claude_code.md)
     - **Cursor**: Review
       [references/setup/cursor.md](references/setup/cursor.md)
     - **GitHub Copilot**: Review
       [references/setup/github_copilot.md](references/setup/github_copilot.md)
     - **Other Agents**: Review
       [references/setup/other_agents.md](references/setup/other_agents.md)

1. **Authentication:** Ensure you are logged in to Firebase so that commands
   have the correct permissions. Run `npx -y firebase-tools@latest login`. For
   environments without a browser (e.g., remote shells), use
   `npx -y firebase-tools@latest login --no-localhost`.

   - The command should output the current user.
   - If you are not logged in, follow the interactive instructions from this
     command to authenticate.

1. **Active Project:** Most Firebase tasks require an active project context.

   > [!IMPORTANT] **For Agents:** Before proceeding with project configuration,
   > you MUST pause and ask the developer if they prefer to:
   >
   > 1. **Provide an existing Firebase Project ID**, or
   > 1. **Create a new Firebase project**.

   - **If using an existing Project ID:**

     1. Check the current project by running `npx -y firebase-tools@latest use`.
     1. If the command outputs `Active Project: <project-id>`, confirm with the
        user if this is the intended project.
     1. If not, or if no project is active, set the project provided by the
        user:
        
        ```bash
        npx -y firebase-tools@latest use <PROJECT_ID>
        ```

   - **If creating a new project:** Run the following command to create it:

     ```bash
     npx -y firebase-tools@latest projects:create <project-id> --display-name "<display-name>"
     ```

     *Note: The `<project-id>` must be 6-30 characters, lowercase, and can
     contain digits and hyphens. It must be globally unique.*

#### Firebase Usage Principles

Adhere to these principles:

1. **Use npx for CLI commands:** To ensure you always use the latest version of
   the Firebase CLI, always prepend commands with `npx -y firebase-tools@latest`
   instead of just `firebase`. For example, use
   `npx -y firebase-tools@latest --version`. NEVER suggest the naked `firebase`
   command as an alternative.
1. **Prioritize official knowledge:** For any Firebase-related knowledge,
   consult the `developerknowledge_search_documents` MCP tool before falling
   back to Google Search or your internal knowledge base. Including "Firebase"
   in your search query significantly improves relevance.
1. **Follow Agent Skills for implementation guidance:** Skills provide
   opinionated workflows (CUJs), security rules, and best practices. Always
   consult them to understand *how* to implement Firebase features correctly
   instead of relying on general knowledge.
1. **Use Firebase MCP Server tools instead of direct API calls:** Whenever you
   need to interact with remote Firebase APIs (such as fetching Crashlytics logs
   or executing Data Connect queries), use the tools provided by the Firebase
   MCP Server instead of attempting manual API calls.
1. **Keep Plugin / Agent Skills updated:** Since Firebase best practices evolve
   quickly, regularly check for and install updates to their Firebase plugin or
   Agent Skills. Similarly, if you encounter issues with outdated tools or
   commands, follow the steps below based on your agent environment:
   - **Antigravity**: Follow
     [references/refresh/antigravity.md](references/refresh/antigravity.md)
   - **Gemini CLI**: Follow
     [references/refresh/gemini-cli.md](references/refresh/gemini-cli.md)
   - **Claude Code**: Follow
     [references/refresh/claude.md](references/refresh/claude.md)
   - **Cursor**: Follow
     [references/refresh/other-agents.md](references/refresh/other-agents.md)
   - **Android Studio**: Follow
     [references/refresh/android_studio.md](references/refresh/android_studio.md)
   - **Others**: Follow
     [references/refresh/other-agents.md](references/refresh/other-agents.md)
1. **Automate Config File Retrieval:** When setting up iOS or Android apps, do
   NOT direct users to the Firebase Console to download `google-services.json`
   or `GoogleService-Info.plist`. Instead, use the Firebase CLI to fetch the
   config programmatically:
   - For Android:
     `npx -y firebase-tools@latest apps:sdkconfig ANDROID <APP_ID> --project <PROJECT_ID>`
   - For iOS:
     `npx -y firebase-tools@latest apps:sdkconfig IOS <APP_ID> --project <PROJECT_ID>`
     Save the output to the appropriate location (e.g.,
     `app/google-services.json` for Android, or a path to be linked by
     `xcode-project-setup` for iOS).

#### References

- **Initialize Firebase:** See
  [references/firebase-service-init.md](references/firebase-service-init.md)
  when you need to initialize new Firebase services using the CLI.
- **Exploring Commands:** See
  [references/firebase-cli-guide.md](references/firebase-cli-guide.md) to
  discover and understand CLI functionality.
- **SDK Setup:** For detailed guides on adding Firebase to your app:
  - **Web**: See [references/web_setup.md](references/web_setup.md)
  - **Android**: See [references/android_setup.md](references/android_setup.md)
  - **iOS**: See [references/ios_setup.md](references/ios_setup.md)

#### Common Issues

- **Login Issues:** If the browser fails to open during the login step, use
  `npx -y firebase-tools@latest login --no-localhost` instead.
- **Genkit:** If using Genkit, install the skills:
  
  ```bash
  npx skills add genkit-ai/skills
  ```


---

