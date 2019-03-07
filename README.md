# Node-Express-TypeScript in one

This is a sample boilerplate for a nodejs express web api developed using typescript.

I used vscode because debugging and development experience is really great, it left other IDEs (WebStorm, IntelliJ ..) miles away. 

Vscode has out-of-the-box support for typescript, its command palette, multiple plugins are really powerful and offer great productivity boost with zero-configuration.

> clone this repo then run `npm i` and you're ready to debug in vscode.

## VSCode

Here are some awesome links:

- Best of extensions : <https://github.com/viatsko/awesome-vscode#javascript>
- Recommended extensions: Debugger for Chrome, Jest, TSLint
- [Debug VueJs https://fr.vuejs.org/v2/cookbook/debugging-in-vscode.html

## Project's tree

By convention all of the sources ts,js are put in src folder. dist folder is not tracked by git and it's the build output of typescript.

.vscode contains debug configurations/tasks for vscode these are based on npm tasks defined in tasks.json

Above some npm commands:

- `npm run clean` cleans output files and node_modules
- `npm run debug` run/debug the program, watching in background for source code change with incremental/on-the-fly typescript compilation, you're able to directly debug ts in Chrome inspector.
- `npm run start` runs release distribution
- `npm run doc` generates html documentation for the project
- `npm run test` runs unit tests using jest (jest extension for vscode is recommended)
- `npm run lint` run linting based on `tslint.json` rules (ts-lint extention for vscode is strongly recommended for nice IDE experience)
- `npm run watch` allows automatically restarting the node application when file changes in the directory are detected, tsc is put in _watch_ mode so that any change to ts file fires compilation in background and restart of node is then done automatically. It's similar to webpack hot reload mode.

For debuggng in vscode it's quite straightforward and debuggng experience is much better than in Chrome. It's the option i prefer

## Some remarks about tests 

Test files are side-by-side with production code, by convention they have suffix .test.ts or .spec.ts (see 'testMatch' regexp in jest.config.js). 

I see in a lot of projects a sepration of tests in a dedicated 'test' folder, i personally don't like this pattern because it causes painful navigation between test code and production code and it forces to maintain the same source files tree in 'test'.

It's up to CI process to skip copying test files to target production artifacts. We'll se this in Dockerfile.

## Express + Node.js + routing-controllers = Sexy stuff

_routing-controllers_ allows implemnting MVC pattern. Express framework does not ship this pattern by default and as production code grows it could turn out to complete mess.

For .NET, ruby and Scala developers you'll find that the implemenation is quite familiar with famous WebAPI framework using the same logic (ASP.NET Core, Play, Rails..)

MVC controllers have the advantage of sperating cross-cutting concerns from business code and make tests easier and decouple them from network/security middleware.


## Dockerfile

Dockerfile in this sample projects follows the [best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) in official docker documentation.

There are some tricks i've learned the hard way from personal experience i'll detail below.

### Handling Kernel signals and 'clean stop'

Node.js was not designed to run as PID 1 which leads to unexpected behaviour when running inside of Docker. 

> For example, a Node.js process running as PID 1 will not respond to SIGTERM (CTRL-C) and similar signals. As of Docker 1.13, you can use the --init flag to wrap your Node.js process with a lightweight init system that properly handles running as PID 1.

I included [Tini](https://github.com/krallin/tini#using-tini) directly in the base image, ensuring your process is always started with an init wrapper (run as an ENTRYPOINT)

A proper handling of SIGTERM and other Kernel signals ensures that all of the messages in the node event loop are processed before the application stops.

### Node environment variables

Current Dockerfile has `NODE_ENV` set to production. It could be overriding using the `-e "NODE_ENV=development"`
for example when running a docker image.

This is the way you would pass in secrets and other runtime configurations to your application as well.

### Run node as non-root user

By default, Docker runs containers as root which inside of the container can be a security issue. 

We must run containers as an unprivileged user wherever possible. The official node images provide the node `user` for such purpose. In the current dockerfile the node process is ran under _node_ user. It can also be set in docker `run -u <custom_user>`

### CMD

I chose to bypass package.json `npm run serve` command. First off this reduces the number of processes running inside of container, and package.json is needed only in development process and never in production. I admit this causes more maintenance in Dockerfiles however this have other benefits.

It causes exit signals such as SIGTERM and SIGINT to be received by the Node.js process instead of npm swallowing them.


### Use lean base images and embed only the needed dependencies

Here some of my recommendations :

- Use node alpine base images, these images are lean and efficient. 
- Skip unnecessary assets for your production artifacts:
unit test code, dev dependencies, linux packages etc..
- Reduce docker build context using a wise .dockerignore configuration. This makes docker build faster.
- Use [Docker bench security](https://github.com/docker/docker-bench-security) to inspect you docker images for production.
- Never put secrets in build `ARG` or inside dockerfiles, use environment variables or a secured kv store for this purpose (etcd, vault are great for this purpose..)


### use Multistaged docker builds

With Docker multi-stage build feature, it’s possible to implement an advanced Docker image build pipeline using a single Dockerfile.

The multi-stage build allows using multiple FROM commands in the same Dockerfile. The last FROM command produces the final Docker image, all other images are intermediate images (no final Docker image is produced, but all layers are cached).

In the example is used 4 stages:
- Base image (node:alpine + tini)
- Build
- Test
- Release


### Memory & CPU


By default, any Docker Container may consume as much of the hardware such as CPU and RAM. If you are running multiple containers on the same host you should limit how much memory they can consume.

``` console
 -m "300M" --memory-swap "1G" 
```

### Container HEALTHCHECK

Add a custom and wise heatlhcheck to your container, a good practice for http(s) services is to expose a _health route and probe it. 

This is essential for HA, load balancing, docker daemon built in helthcheck and container orchestration systems : Swarm, K8s.

## Data management

containers are immutable, never store data in. You should use named docker volumes.

## CI/CD

These are some considerations:

- Include your git revision as a part of the docker image's tag. this gets the latest git revision (uuid4):
 `$(git log -1 --format=%h)`

 - Beware of docker build cache. If you're not confident with it you can disable it by passing ` --no-cache` to `docker build`

**Use Makefile because it's great**

 In this sample project i've written a Makefile for docker images CI. It support docker image build, tag, push.

 To show supported commands type `make help` or simply `make` in the terminal (currenr directory must be the root project directory)

Make is a build automation tool created in 1976, designed to solve dependency problems of the build process.

It was originally used to get compiled files from source code, for instance for C language. It's really powerful and very generic, it's often used to build "meta commands" and DRY runs.
