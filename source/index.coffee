stream = require 'stream'
triangleNormal = require 'triangle-normal'


module.exports = class FaceNormalBuilder extends stream.Transform
	constructor: (@options = {}) ->
		@options.writableObjectMode ?= true
		@options.readableObjectMode ?= true
		@options.overwrite ?= true
		super @options


	_parse: (chunk) ->
		if @options.writableObjectMode
			return chunk

		return JSON.parse chunk.toString()


	_serialize: (jsonEvent) ->
		if @options.readableObjectMode
			return jsonEvent

		return JSON.stringify(jsonEvent) + '\n'


	_flush: (done) ->
		done()


	_transform: (chunk, encoding, done) ->

		jsonEvent = @_parse chunk

		if jsonEvent.vertices
			if jsonEvent.normal and not @options.overwrite
				return done()

			{vertices} = jsonEvent

			normalCoordinates = triangleNormal(
				vertices[0].x, vertices[0].y, vertices[0].z,
				vertices[1].x, vertices[1].y, vertices[1].z,
				vertices[2].x, vertices[2].y, vertices[2].z,
			)

			jsonEvent.normal =
				x: normalCoordinates[0]
				y: normalCoordinates[1]
				z: normalCoordinates[2]

		done null, @_serialize jsonEvent
