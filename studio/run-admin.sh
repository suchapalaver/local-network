#!/bin/sh
set -euf

if [ ! -d "build/edgeandnode/subgraph-studio" ]; then
    mkdir -p build/edgeandnode/subgraph-studio
    git clone git@github.com:edgeandnode/subgraph-studio build/edgeandnode/subgraph-studio --branch 'v0.16.13'
fi

. ./.env
host="${DOCKER_GATEWAY_HOST:-host.docker.internal}"

cd build/edgeandnode/subgraph-studio
cp ../../../studio/create-users.ts packages/shared/src/database/seeds/test-users.ts
yarn setup

cd packages/admin-api

export NODE_ENV=test
export JWT_SIGNING_SECRET=supersecret

if [ ! -f ../../keys/test-private.pem ]; then
    mkdir -p ../../keys/
    openssl ecparam -genkey -name secp256k1 -out ../../keys/test-private.pem
fi

auth_token="$(yarn issue-auth-token | grep Bearer | awk '{print $2}')"
echo "auth_token=${auth_token}"
curl "http://${host}:${CONTROLLER}/studio_admin_auth" -d "${auth_token}"

export DB_HOST="${host}"
export DB_NAME=subgraph_studio
export DB_PASS=
export DB_PORT="${POSTGRES}"
export DB_USER=dev

cd ../shared && yarn build
cd ../..
yarn knex seed:run --specific test-users.ts
yarn dev:admin-api
