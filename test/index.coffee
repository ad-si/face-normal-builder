fs = require 'fs'
assert = require 'assert'

stlModels = require 'stl-models'
stlParser = require 'stl-parser'
StreamTester = require 'streamtester'

FaceNormalBuilder = require '../source/index'


describe 'Face Normal Builder', ->
	it 'calculates the normals for a model stream', (done) ->
		counter = 0
		streamTester = new StreamTester {test: (chunk) ->
			if counter is 0
				assert.deepEqual chunk, {name: 'tetrahedron', type: 'ascii'}

			if counter is 1 then assert.deepEqual chunk, {
				number: 1
				normal:
					x: 0.5773502691896258
					y: 0.5773502691896258
					z: 0.5773502691896258
				vertices: [{x:1,y:0,z:0}, {x:0,y:1,z:0}, {x:0,y:0,z:1}]
			}

			if counter is 2 then assert.deepEqual chunk, {
				number: 2
				normal: {x:0, y:-1, z:0}
				vertices: [{x:0,y:0,z:0}, {x:1,y:0,z:0}, {x:0,y:0,z:1}]
			}

			if counter is 3 then assert.deepEqual chunk, {
				number: 3
				normal: {x:-1, y:0, z:0}
				vertices: [{x:0,y:0,z:0}, {x:0,y:0,z:1}, {x:0,y:1,z:0}]
			}

			if counter is 4 then assert.deepEqual chunk, {
				number: 4
				normal: {x:0, y:0, z:-1}
				vertices: [{x:0,y:0,z:0}, {x:0,y:1,z:0}, {x:1,y:0,z:0}]
			}

			counter++
		}

		streamTester.on 'finish', ->
			done()

		stlModels
			.getReadStreamByPath 'broken/wrongNormals.ascii.stl'
			.pipe stlParser()
			.pipe new FaceNormalBuilder {readableObjectMode: true}
			.pipe streamTester
