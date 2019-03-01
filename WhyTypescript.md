## Why typescript ?

- Typescript is javascript that scales. Many university papers prove that Strongly typed language scale better. Very large codebases require Domain structuring and a strong type System. Typing provides better safety and documentation.

- Improved IDE support: Intellisence, auto-suggestion/completion, big refactorings made with ease, compile-time checking, improved code readability, better static code checking.

- It bring the best of the two worlds : dynamic typing (js) and optional static/strong typing.

- Provides great OOP paradigms, type checking on compile, and advanced js features (>=es7), no need for Babel or any other transpiler.

- Is a superset of js, it means that **any valid js file is still a valid ts file**. plain vanilla javascript is also typescript!
**No code migration required!** : once a transpiler is set up in you project, you can use your legacy js code as it is. 
Migration to typed code is smooth and requires only adding type definition and interfaces (those are only used in compile-time)

- Offical language in GAFA companies and great support by Microsoft and Google. Tsc compiler is blazing fast,it has watch mode (transpiling done in background as ts file change), ts debugging with dive into js, source maps and many more options. It's open-source.

- Typescript has great type definitions support for with [definitely typed project](https://github.com/DefinitelyTyped/DefinitelyTyped) with >8k contributors and great support for all of the popular js frameworks.

## What are the alternatives ?

Even it's hard to hate Typescript. Maybe the additional transpiling layer could 


- [flow](https://github.com/facebook/flow): a static type checker developed by _Facebook_. I think this tool was primilary built for React, it's poorly documented and supported by other frameworks/libs. It also has much smaller community than typescript as shown by [npm trends](https://www.npmtrends.com/typescript-vs-flow-bin)

- [JsDoc](http://usejsdoc.org/) : JSDoc provides type annotations as comments in JavaScript, so in that sense it is more similar to Flow than TypeScript. The difference is that JSDoc comments are standard JavaScript comments. So, no need for a build step to transpile to JavaScript or a plugin to strip the comments out like Flow. When you minify your code, the JSDoc comments get removed automatically.
In fact, the great IntelliSense that TypeScript provides through d.ts files is because these also include JSDoc comments.

> JsDoc is standard and provides comprenhensive type information, however : it remains an annotation tool, it's verbose, it does not empower javascripts with new features.

In Typescript you just need to write classes,interfaces and OOP/Functional paradigms and have no distraction by annotations, comments. Your documentation is implicit and code is 'self documented'
