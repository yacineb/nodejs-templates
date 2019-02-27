# ---- Base Node ----
ARG NODE_TAG='10-alpine'

FROM node:${NODE_TAG} AS base
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
# then install ALL node_modules, including 'devDependencies'
RUN npm set progress=false \
    && npm config set depth 0 \
    && npm i --only=production \
    && cp -R node_modules prod_node_modules \
    && npm i

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

# ports exposed
EXPOSE 5000
#node in production
ENV NODE_ENV production
#run under 'node' user for security reasons
USER node

#same as npm run serve but better for Handling Kernel signals
CMD ["node","./dist/server.js"]