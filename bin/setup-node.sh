#!/bin/sh

nodenv install -s

npm i -g npm
npm i -g yarn
npm i -g npm-check-updates

nodenv which node
nodenv which yarn
