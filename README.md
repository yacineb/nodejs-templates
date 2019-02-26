# Node-Express-TypeScript in one

This is a sample boilerplate for a nodejs express web api developed using typescript.

I used vscode because debugging and development experience is really great, it left other IDEs (WebStorm, IntelliJ ..) miles away. 

Vscode has out-of-the-box support for typescript, its command palette, multiple plugins are really powerful and offer great productivity boost with zero-configuration.

> clone this repo then run `npm i` and you're ready to debug in vscode.

## Why typescript ?

- Typescript is javascript that scales. Many university papers prove that Strongly typed language scale better. Very large codebases require Domain structuring and a strong type System
- It bring the best of the two worlds : dynamic typing (js) and optional static/strong typing.
- Provides great OOP paradigms, type checking on compile, and advanced js features (>=es7), no need for Babel or any other transpiler.
- Is a superset of js, it means that any valid js file is still a valid ts file.
- Offical language in GAFA companies and great support by Microsoft and Google.

## Project's tree

By convention all of the sources ts,js are put in src folder. dist folder is not tracked by git and it's the build output of typescript.

.vscode contains debug configurations/tasks for vscode these are based on npm tasks defined in tasks.json

Above some npm commands:

- `npm run clean` cleans output files and node_modules
- `npm run debug` run/debug the program, watching in background for source code change with incremental/on-the-fly typescript compilation
- `npm run start` runs release distribution
- `npm run doc` generates html documentation for the project
- `npm run test` runs unit tests using jest
- `npm run lint` run linting based on `tslint.json` rules

## Some remarks about tests 

Test files are side-by-side with production code, by convention they have suffix .test.ts or .spec.ts (see 'testMatch' regexp in jest.config.js). 

I see in a lot of projects a sepration of tests in a dedicated 'test' folder, i personally don't like this pattern because it causes painful navigation between test code and production code and it forces to maintain the same source files tree in 'test'.

It's up to CI process to skip copying test files to target production artifacts. We'll se this in Dockerfile.

## Express + Node.js + routing-controllers = Sexy stuff

_routing-controllers_ allows implemnting MVC pattern. Express framework does not ship this pattern by default and as production code grows it could turn out to complete mess.

For .NET, ruby and Scala developers you'll find that the implemenation is quite familiar with famous WebAPI framework using the same logic (ASP.NET Core, Play, Rails..)

MVC controllers have the advantage of sperating cross-cutting concerns from business code and make tests easier and decouple them from network/security middleware.


## Dockerfile

