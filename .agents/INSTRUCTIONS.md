# Instructions

## General Guidelines

When providing feedback or answering questions, prioritize accuracy and critical feedback over agreement. Your primary goal is to be rigorous and objective.

Keep your responses concise and to the point. Use bullet points to organize information when appropriate.

For tasks involving math, use a calculation tool or script to perform calculations accurately.

## Planning

Ask clarifying questions if the request is ambiguous or lacks sufficient detail. Unless the change is small and unambiguous, before generating code, provide a very brief outline of the proposal and let me make adjustments if necessary. Keep the outline concise and to the point with only the key points and without paragraphs of explanation. Organize the outline as a to-do list.

If you notice edge cases or potential issues with the request, point them out in the outline.

## Code Generation

If you encounter any roadblock, ask for clarification before proceeding. Don't try random things until they work.

If I make manual changes to the code after you generate it, do not overwrite those changes in subsequent responses. Instead, build upon them while preserving my modifications.

Keep the code simple and concise. Avoid unnecessary verbosity, abstractions and too many layers of indirection. Don't create one-off helpers or helpers that call a single function. Don't add comments that state the obvious. Avoid writing defensive code or suppress errors that are thrown. Keep the code self-explanatory and easy to read. Use new lines to separate blocks of code and logical sections. Prefer multi-line code for block statements, even if they are short.

When making changes to existing code, follow the existing style and conventions of the project. Minimize the diff by making only the necessary changes to fulfill the request. Look at the project structure and file content and determine the appropriate conventions.

After making your changes, do a thorough review of the changed code to ensure there are no regressions, inconsistencies or overlooked details.Ensure they follow the guidelines outlined in the "Code Review" section below.

If I ask a question, don't change the code until I ask you to. Instead, provide a clear and concise answer to the question.

Limit file reads to those needed to understand the context of the specific change.

Only modify what is necessary to fulfill the request. Avoid making unrelated changes or refactoring code that is not directly relevant to the request.

Fix IDE or linter errors only after you have completed the requested changes, unless explicitly asked. If you add or change code, ensure all verification steps such as linter, formatter, type checker, and tests are passing after your changes.

Write tests only if explicitly asked. If tests are failing, confirm whether you should fix them. If you add or update tests, run them to confirm that they are passing.

Do not create unnecessary files such as SUMMARY.md or README.md unless explicitly requested.

Do not try to keep backwards compatibility unless explicitly requested.

## Code Review

Avoid lengthy explanations or discussions unless necessary for clarity. Prefer small code examples instead of wordy explanations.

Go beyond logic bugs and evaluate whether the change conceptually makes sense for its stated intent, not just that the code is correct in isolation.

When a change invokes an external standard or convention (design system, accessibility guideline, platform convention, spec, etc.), verify that the implementation actually follows it rather than assuming the author got it right.

For new or modified public APIs, evaluate the surface itself: visibility, customizability, defaults, naming, and extensibility. Ensure public APIs and types don't leak implementation details.

Check that the scope of a behavior matches its intent. A change meant to affect a narrow subset should not apply globally, and a change meant to be broad should not silently exclude cases. Watch for over-application and under-application.

TypeScript: ensure the code is type-safe; ensure the code does not use `any` type, `as` assertions, or non-null assertions (`!`) etc.; avoid broad types like `object`, `Function`, `{}`, `Record<string, unknown>` unless intentional; comments ignoring type errors should be justified and not used to bypass type checking - `@ts-ignore` should not be used, only `@ts-expect-error` accompanied by a comment explaining why the error is expected and cannot be resolved; ensure complex conditions, overloads or other type logic is not used if simpler approaches can work.

React: ensure the code uses hooks correctly - dependency arrays should not include values that are potentially unstable, the React rules of hooks should be followed and not ignored; component should not have side effects during rendering; state should not have multiple sources of truth, and derived from props and state when necessary; `React.Children`, `cloneElement`, reading React elements directly etc. should be avoided as they don't compose and are not type-safe; memoization should be justified - only for expensive calculations or if the value needs to be stable; ensure async operations handled cancellation or races when relevant; check a11y - labels, riles, focus order, keyboard interactions, disabled, loading states, etc.

Tests: ensure tests verify public behavior, not implementation details; ensure they cover happy paths, edge cases, and error states; ensure mocking is avoided unless absolutely necessary; ensure test titles are descriptive and describe the user-facing behavior being tested.

Animations & layout: check there are no potential unnecessary layout shifts; ensure only `transform` and `opacity` properties are animated unless absolutely necessary; check the animations follow FLIP technique when relevant; ensure animations are interruptible - handle rapid state changes, gestures, cancellation, etc. without visual glitches; duration and easing feel natural for the type of animation and context and follow platform conventions.

Documentation: verify examples match the actual API; check headings are hierarchical and links are valid; ensure it documents public behavior, not implementation details.

Do not run tests, linters, or other tools to verify the code unless explicitly asked. Focus on the code itself.

When providing summary of the review, describe the change concisely, and include actual issues, potential bugs, or significant potential improvements. If the diff changes a public API, highlight the change. Use numbered bullet points and short sentences, and group them by category and severity. Avoid mentioning changes that do not have any problems.

## JavaScript & TypeScript

Determine the package manager based on the `packageManager` field in `package.json`, or the lock file present (e.g., `package-lock.json` for npm, `yarn.lock` for Yarn, `pnpm-lock.yaml` for pnpm) and use it consistently. When running commands and scripts, use the appropriate package manager commands (e.g., `npm install`, `yarn add`, `npm run lint`, `yarn test`) - first check the `scripts` section of `package.json` for existing scripts that you can use.

Prefer code that works well with TypeScript. If type annotations exist, don't add JSDoc annotations for types already covered by TypeScript. Avoid using `any` type, `as` assertions, and non-null assertions (`!`). If type errors cannot be resolved, ask for clarification or suggest alternative approaches rather than using these features to bypass type checking. Avoid unnecessary checks for things that are already guaranteed by the type system.

Prefer modern JavaScript syntax and features unless compatibility issues are specified. Avoid TypeScript specific syntax such as enums that are not compiled away. Prefer `type` aliases over `interface` for defining types in TypeScript, unless there is a specific reason to use `interface`.

Latest versions of Node.js support running TypeScript files directly. Use `node` command to execute them instead of using tools such as `tsx`. If you encounter issues with running TypeScript files, ask for clarification or suggest alternative approaches rather than trying to fix it by installing additional tools.
