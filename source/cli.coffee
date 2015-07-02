fs = require 'fs'
path = require 'path'

ndjson = require 'ndjson',

FaceNormalBuilder = require './index.js'


module.exports = (options) ->

	options.readableObjectMode = false

	if process.stdin.isTTY
		console.error 'face-normal-builder must be used by piping into it'

	else
		process.stdin
			.pipe ndjson.parse()
			.pipe new FaceNormalBuilder options
			.pipe process.stdout
