###
 * Copyright 2011 axn software UG (haftungsbeschränkt)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
###

vows = require 'vows'
assert = require 'assert'

vows.describe('enumjs Tests').addBatch({

	'When require()d':
		topic: () -> 
			require '../lib/enum.coffee' 
		'the source must compile': (topic) ->
			assert.isNotNull topic
		'the Enum export must be available': (topic) ->
			assert.isTrue 'Enum' of topic
		'Enum must be a class function': (topic) -> 
			assert.isFunction topic.Enum
		'Enum must not be instantiatable': (topic) ->
			assert.throws (-> topic.Enum()), TypeError
		'Enum.create() must be available': (topic) ->
			assert.isFunction topic.Enum.create
		'The Enum class cannot be instantiated' : (topic) ->
			assert.throws (-> topic.Enum()), TypeError

	'Enum.create() must fail':
		topic: () ->
			require('../lib/enum.coffee').Enum
		'with a TypeError on an empty arguments list' : (topic) ->
			assert.throws (-> topic.create()), TypeError
		'with a TypeError on an empty declaration' : (topic) ->
			assert.throws (-> topic.create {}), TypeError
		'with a TypeError on an invalid declaration' : (topic) ->
			assert.throws (-> topic.create "invalid"), TypeError
			assert.throws (-> topic.create ["invalid"]), TypeError
			assert.throws (-> topic.create { CONST1 : "invalid" }), TypeError
		'with a TypeError on duplicate ordinals' : (topic) ->
			assert.throws (-> topic.create { CONST1 : 5, CONST2 : 4, CONST3 : 0 }), TypeError
			assert.throws (-> topic.create { CONST1 : 1, CONST2 : 2, CONST3 : 1 }), TypeError
			assert.throws (-> topic.create { CONST1 : 1, CONST2 : 1 }), TypeError
			assert.throws (-> topic.create { CONST1 : { ordinal : 1 }, CONST2 : 2, CONST3 : { ordinal : 1 } }), TypeError
			assert.throws (-> topic.create { CONST1 : { ordinal : "a2" }, CONST2 : 1, CONST3 : { ordinal : 0 } }), TypeError
		'with a TypeError on invalid constant literals' : (topic) ->
			assert.throws (-> topic.create { "CON ST1" : 0 }), TypeError
			assert.throws (-> topic.create { "53CONST1" : 0 }), TypeError

	'Inheritance and prevention of instantiation':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : 1, B : 0, C : 0 }
		'The enum class cannot be instantiated' : (topic) ->
			assert.throws (-> topic()), TypeError
		'values() must not be an instance method' : (topic) ->
			assert.isUndefined topic.A.values
			assert.isUndefined topic.B.values
			assert.isUndefined topic.C.values
			assert.typeOf topic.values, 'function'
		'enum is a subclass of Enum' : (topic) ->
			Enum = require('../lib/enum.coffee').Enum
			assert.equal topic.super_, Enum
		'enum constants are instances of enum' : (topic) ->
			Enum = require('../lib/enum.coffee').Enum
			assert.instanceOf topic.A, topic
			assert.instanceOf topic.A, Enum 
			assert.instanceOf topic.B, topic
			assert.instanceOf topic.B, Enum 
			assert.instanceOf topic.C, topic
			assert.instanceOf topic.C, Enum 
		'valueOf() class method is different from valueOf() instance method' : (topic) ->
			assert.notStrictEqual topic.valueOf, topic.A.valueOf 
			assert.notStrictEqual topic.valueOf, topic.B.valueOf 
			assert.notStrictEqual topic.valueOf, topic.C.valueOf 
		'subclasses of Enum have no create() factory method' : (topic) ->
			assert.isUndefined topic.create
			assert.isUndefined topic.A.create
			assert.isUndefined topic.B.create
			assert.isUndefined topic.C.create
# nice to have but not possible with existing implementations of extends/inherits
#		'subclasses of Enum cannot be inherited from' : (topic) ->
#			assert.throws (-> class t extends topic), TypeError
#			util = require "util"
#			assert.throws (-> f = -> {}; util.inherits f, Enum), TypeError

	'Instance and class methods valueOf() and class method values()':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : 1, B : 0, C : 0 }
		'values() returns array of length 3' : (topic) ->
			assert.equal 3, topic.values().length
		'array returned by values() contains all of the declared enum constants in arbitrary order' : (topic) ->
			values = topic.values()
			assert.isTrue topic.A in values
			assert.isTrue topic.B in values
			assert.isTrue topic.C in values
		'valueOf() class method returns correct constants' : (topic) ->
			assert.strictEqual topic.valueOf('A'), topic.A
			assert.strictEqual topic.valueOf(1), topic.A
			assert.strictEqual topic.valueOf(topic.A), topic.A
			assert.strictEqual topic.valueOf('B'), topic.B
			assert.strictEqual topic.valueOf(2), topic.B
			assert.strictEqual topic.valueOf(topic.B), topic.B
			assert.strictEqual topic.valueOf('C'), topic.C
			assert.strictEqual topic.valueOf(3), topic.C
			assert.strictEqual topic.valueOf(topic.C), topic.C
		'valueOf() and ordinal() instance methods returns correct values' : (topic) ->
			assert.strictEqual topic.A.valueOf(), topic.A.ordinal
			assert.strictEqual topic.B.valueOf(), topic.B.ordinal
			assert.strictEqual topic.C.valueOf(), topic.C.ordinal
		'name() instance method returns correct values' : (topic) ->
			assert.strictEqual topic.A.name, 'A'
			assert.strictEqual topic.B.name, 'B'
			assert.strictEqual topic.C.name, 'C'
		'class method valueOf() must throw TypeError on undefined, unknown ordinal or unknown constant literal' : (topic) ->
			assert.throws (-> topic.valueOf()), TypeError
			assert.throws (-> topic.valueOf(0)), TypeError
			assert.throws (-> topic.valueOf('Z')), TypeError

	'When an enum is create()d properly using only integers':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : 1, B : 0, C : 0 }
		'valueOf() must comply to the official protocol' : (topic) ->
			assert.doesNotThrow (-> topic.A.valueOf()), TypeError
			assert.isNumber topic.A.valueOf()
			assert.equal 1, topic.A.valueOf()
		'The minimum ordinal is one (1)' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
		'The ordinals are all in sequence' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
			assert.isTrue topic.B.ordinal == 2
			assert.isTrue topic.C.ordinal == 3

	'When an enum is create()d properly using object notation only':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : { ordinal : 0 }, B : { ordinal : 0 }, C : {} }
		'The minimum ordinal is one (1)' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
		'The ordinals are all in sequence' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
			assert.isTrue topic.B.ordinal == 2
			assert.isTrue topic.C.ordinal == 3

	'When an enum is create()d properly mixing object notation and integers':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : { ordinal : 0 }, B : 2, C : { ordinal : 0 } }
		'The minimum ordinal is one (1)' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
		'The ordinals are all in sequence' : (topic) ->
			assert.isTrue topic.A.ordinal == 1
			assert.isTrue topic.B.ordinal == 2
			assert.isTrue topic.C.ordinal == 3

	'When an enum is create()d properly with custom ordinals':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : 100, B : { ordinal : 49 }, C : 0 }
		'The minimum ordinal is 49' : (topic) ->
			assert.isTrue topic.B.ordinal == 49
			assert.isTrue topic.A.ordinal > topic.B.ordinal
			assert.isTrue topic.C.ordinal > topic.B.ordinal
		'There is a gap of 50 between the ordinals of A and C, with B and C being in sequence' : (topic) ->
			assert.isTrue (topic.A.ordinal - topic.C.ordinal) == 50
			assert.isTrue (topic.C.ordinal - topic.B.ordinal) == 1

	'When an enum is create()d properly':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create { A : 100, B : { ordinal : 49 }, C : 0 }
		' its instance\'s name property must be read only' : (topic) ->
			topic.A.name = 'test'
			assert.isTrue topic.A.name == 'A'
		' its instance\'s ordinal property must be read only' : (topic) ->
			topic.A.ordinal = -1
			assert.isTrue topic.A.ordinal == 100

	'Custom constructor':
		topic: () ->
			Enum = require('../lib/enum.coffee').Enum
			Enum.create({ 
				ctor: (inverse) ->
					try
						@_inverse = this.self.valueOf(inverse)
					catch e
						@_inverse = this
					this
				statics :
					inverse : (value) ->
						self.valueOf(value).inverse()
					staticProp : {}
				instance :
					inverse : () ->
						@_inverse
					instanceProp : { a : 1 }
				A : 
					construct : ['B']
					ordinal : 0
				B :
					construct : ['A']
					ordinal : 2
				C : 0
			})
		'Custom static class fields are available' : (topic) ->
			assert.isTrue 'inverse' of topic
			assert.isTrue 'staticProp' of topic
		'Custom static class fields work as expected' : (topic) ->
			assert.strictEqual topic.inverse(topic.A.name), topic.B
			assert.strictEqual topic.inverse(topic.A.ordinal), topic.B
			assert.strictEqual topic.inverse(topic.A), topic.B
			assert.strictEqual topic.inverse(topic.B.name), topic.A
			assert.strictEqual topic.inverse(topic.B.ordinal), topic.A
			assert.strictEqual topic.inverse(topic.B), topic.A
			assert.strictEqual topic.inverse(topic.C.name), topic.C
			assert.strictEqual topic.inverse(topic.C.ordinal), topic.C
			assert.strictEqual topic.inverse(topic.C), topic.C
			assert.deepEqual topic.staticProp, {}
		'Custom instance fields are available' : (topic) ->
			assert.isTrue 'inverse' of topic.A
			assert.isTrue 'inverse' of topic.B
			assert.isTrue 'inverse' of topic.C
			assert.isTrue '_inverse' of topic.A
			assert.isTrue '_inverse' of topic.B
			assert.isTrue '_inverse' of topic.C
			assert.isTrue 'staticProp' not of topic.A
			assert.isTrue 'instanceProp' of topic.A
			assert.isTrue 'staticProp' not of topic.B
			assert.isTrue 'instanceProp' of topic.B
			assert.isTrue 'staticProp' not of topic.C
			assert.isTrue 'instanceProp' of topic.C
		'Custom instance method works as expected' : (topic) ->
			assert.strictEqual topic.A.inverse(), topic.B
			assert.strictEqual topic.B.inverse(), topic.A
			assert.strictEqual topic.C.inverse(), topic.C
			assert.deepEqual topic.A.instanceProp, { a: 1 }
			assert.strictEqual topic.A.instanceProp, topic.B.instanceProp
			assert.strictEqual topic.B.instanceProp, topic.C.instanceProp

}).export(module)

