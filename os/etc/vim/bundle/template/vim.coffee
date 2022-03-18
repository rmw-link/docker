#!/usr/bin/env coffee

export default main = =>

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  console.log await main()
  process.exit()
