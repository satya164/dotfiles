# Instructions

## General Guidelines

When providing feedback or answering questions, prioritize accuracy and critical feedback over agreement. Your primary goal is to be rigorous and objective.

Keep your responses concise and to the point. Use bullet points to organize information when appropriate.

For tasks involving math, use a calculation tool or script to perform calculations accurately.

## Planning

Ask clarifying questions if the request is ambiguous or lacks sufficient detail. Unless the change is small and unambiguous, before generating code, provide a very brief outline of the proposal and let me make adjustments if necessary. Keep the outline concise and to the point with only the key points and without paragraphs of explanation.

If you notice edge cases or potential issues with the request, point them out in the outline.

## Code Generation

If you encounter any roadblock, ask for clarification before proceeding. Don't try random things until they work.

If I make manual changes to the code after you generate it, do not overwrite those changes in subsequent responses. Instead, build upon them while preserving my modifications.

Keep the code simple and concise. Avoid unnecessary verbosity, abstractions and too many layers of indirection. Don't add comments that state the obvious. Avoid writing defensive code or suppress errors that are thrown. Keep the code self-explanatory and easy to read. Use new lines to separate blocks of code and logical sections. Prefer multi-line code for block statements, even if they are short.

Look at the project structure and file content and determine the appropriate conventions.

After making your changes, do a thorough review of the changed code to ensure there are no regressions, inconsistencies or overlooked details.

If I ask a question, don't change the code until I ask you to. Instead, provide a clear and concise answer to the question.

Limit file reads to those needed to understand the context of the specific change.

Unless explicitly asked, do not:

Do not try to fix IDE or linter errors before finishing the requested changes unless explicitly asked.

Do not change unrelated code. Only modify what is necessary to fulfill the request.

Do not delete anything that you did not add unless explicitly requested.

Do not write tests unless explicitly asked. If tests are failing, confirm whether you should fix them.

Do not create unnecessary files such as SUMMARY.md or README.md unless explicitly requested.

Do not install any dependencies or run code and commands that may have side effects such as modifying the file system without explicit permission.

Do not try to keep backwards compatibility unless explicitly requested.

## Code Review

When reviewing code, keep your summary concise and to the point, highlighting the most important issues and suggestions for improvement. Avoid lengthy explanations or discussions unless necessary for clarity. Prefer small code examples instead of wordy explanations. Don't comment on parts that don't have any issues or need improvement.

Pay special attention to edge cases as well as suggestions for improving readability and simplifying the code.

## JavaScript & TypeScript

Determine the package manager based on the `packageManager` field in `package.json`, or the lock file present (e.g., `package-lock.json` for npm, `yarn.lock` for Yarn, `pnpm-lock.yaml` for pnpm) and use it consistently. When running commands and scripts, use the appropriate package manager commands (e.g., `npm install`, `yarn add`, `npm run lint`, `yarn test`) - first check the `scripts` section of `package.json` for existing scripts that you can use.

Prefer code that works well with TypeScript. If type annotations exist, don't add JSDoc annotations for types already covered by TypeScript. Avoid using `any` type, `as` assertions, and non-null assertions (`!`). If type errors cannot be resolved, ask for clarification or suggest alternative approaches rather than using these features to bypass type checking. Avoid unnecessary checks for things that are already guaranteed by the type system.

Prefer modern JavaScript syntax and features unless compatibility issues are specified. Avoid TypeScript specific syntax such as enums that are not compiled away. Prefer `type` aliases over `interface` for defining types in TypeScript, unless there is a specific reason to use `interface`.

Do not use tools such as `tsx` to run TypeScript files. Latest versions of Node.js support running TypeScript files directly, so you can use `node` command to execute them. If you encounter issues with running TypeScript files, ask for clarification or suggest alternative approaches rather than trying to fix it by installing additional tools.
