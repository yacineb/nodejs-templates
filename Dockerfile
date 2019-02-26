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
COPY --from=dependencies /app/package.json package.json
# TODO add exclusion rule for tests
# expose port and define CMD
EXPOSE 5000
CMD npm run serve

