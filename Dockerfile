# ---- Base Node ----
FROM node:10-alpine AS base
# install node
RUN apk add --no-cache tini
WORKDIR /app
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

# ---- Dependencies ----
FROM base AS dependencies
#copy current context
COPY . .
#for faster install
# install and copy production node_modules aside
# install ALL node_modules, including 'devDependencies'
RUN npm set progress=false \
    && npm config set depth 0 \
    && npm i --only=production \
    && cp -R node_modules prod_node_modules \
    && npm i

# run tsc transpiler
RUN npm run build 

# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test
RUN  npm run lint && npm run test

# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies /app/prod_node_modules ./node_modules
COPY --from=dependencies /app/dist ./dist

#clean up test files from production dist
RUN find ./dist -type f \( -name '*.test.js' -o -name '*.test.js.map' \) -exec rm {} \;

# TODO add exclusion rule for tests
EXPOSE 5000
ENV NODE_ENV production
USER node
CMD ["node","./dist/server.js"]

