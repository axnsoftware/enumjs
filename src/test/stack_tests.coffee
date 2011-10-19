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

vows.describe('Stack Tests').addBatch({

	'When require()d':
		topic: () -> 
			require '../lib/stack.coffee' 
		'the source must compile': (topic) ->
			assert.isNotNull topic
		'the Stack export must be available': (topic) ->
			assert.isTrue 'Stack' of topic
		'Stack must be a class function': (topic) -> 
			assert.isFunction topic.Stack
		'StackOverflowError must be available': (topic) ->
			assert.isTrue 'StackOverflowError' of topic
		'StackOverflowError must be a class function': (topic) -> 
			assert.isFunction topic.StackOverflowError
		'StackUnderflowError must be available': (topic) ->
			assert.isTrue 'StackUnderflowError' of topic
		'StackUnderflowError must be a class function': (topic) -> 
			assert.isFunction topic.StackUnderflowError

	'When instantiated':
		topic: () -> 
			require '../lib/stack.coffee' 
		'Stack must be default instantiatable and must be an instanceof Stack': (topic) ->
			assert.isTrue new topic.Stack instanceof topic.Stack
		'length must be enumerable': (topic) ->
			for key of new topic.Stack
				assert.strictEqual(key, 'length') if key == 'length'
		'stackSize must be enumerable': (topic) ->
			for key of new topic.Stack
				assert.strictEqual(key, 'stackSize') if key == 'stackSize'
		'empty must be enumerable': (topic) ->
			for key of new topic.Stack
				assert.strictEqual(key, 'empty') if key == 'empty'
		'private must not be enumerable': (topic) ->
			for key of new topic.Stack
				assert.notStrictEqual key, 'private'
		'initial length must be zero': (topic) ->
			assert.strictEqual new topic.Stack().length, 0
		'default stackSize must be positive infinity': (topic) ->
			assert.strictEqual new topic.Stack().stackSize, Number.POSITIVE_INFINITY
		'Stack must be customly instantiatable and must be an instanceof Stack': (topic) ->
			assert.isTrue new topic.Stack(10) instanceof topic.Stack
		'initial length must be zero': (topic) ->
			assert.strictEqual new topic.Stack(10).length, 0
		'custom stackSize must be set': (topic) ->
			assert.strictEqual new topic.Stack(10).stackSize, 10
		'Stack must not be instantiatable with a zero stackSize': (topic) ->
			assert.throws (-> topic.Stack(0)), RangeError
		'Stack must not be instantiatable with a negative stackSize': (topic) ->
			assert.throws (-> topic.Stack(-1)), RangeError
		'Stack must not be instantiatable with negative infinity stackSize': (topic) ->
			assert.throws (-> topic.Stack(Number.NEGATIVE_INFINITY)), RangeError

	'When derived':
		topic: () -> 
			stack = require '../lib/stack.coffee'
			class TestStack extends stack.Stack

			{TestStack: TestStack, stack: stack}
		'TestStack must be default instantiatable and must be an instanceof TestStack': (topic) ->
			assert.isTrue new topic.TestStack instanceof topic.TestStack
		'TestStack must be default instantiatable and must be an instanceof Stack': (topic) ->
			assert.isTrue new topic.TestStack instanceof topic.stack.Stack
		'TestStack must be customly instantiatable and must be an instanceof TestStack': (topic) ->
			assert.isTrue new topic.TestStack(10) instanceof topic.TestStack
		'TestStack must be customly instantiatable and must be an instanceof Stack': (topic) ->
			assert.isTrue new topic.TestStack(10) instanceof topic.stack.Stack

	'When used':
		topic: () -> 
			require '../lib/stack.coffee'
		'must throw StackUnderflowException when pop() was called on empty stack': (topic) ->
			assert.throws (-> new topic.Stack().pop()), topic.StackUnderflowError
		'must throw StackUnderflowException when last element was pop()ed from non empty stack': (topic) ->
			assert.throws (->
				s = new topic.Stack
				s.push(1).push(2)
				s.pop()
				s.pop()
				s.pop()), topic.StackUnderflowError
		'must throw StackOverflowException when push() was called twice on stack of stackSize one': (topic) ->
			assert.throws (-> new topic.Stack(1).push(1).push(2)), topic.StackOverflowError
		'LIFO contract must be met': (topic) ->
			s = new topic.Stack
			s.push(1).push(2)
			assert.strictEqual s.pop(), 2
			assert.strictEqual s.pop(), 1
		'peek()ing out of range is not allowed': (topic) ->
			assert.throws (-> new topic.Stack().peek -1), RangeError
			assert.throws (-> new topic.Stack().peek 0), RangeError
			assert.throws (-> new topic.Stack().peek 2), RangeError
		'poke()ing out of range is not allowed': (topic) ->
			assert.throws (-> new topic.Stack().poke 0, -1), RangeError
			assert.throws (-> new topic.Stack().poke 0, 0), RangeError
			assert.throws (-> new topic.Stack().poke 0, 2), RangeError
		'when poke()d the new value must be returned in order': (topic) ->
			s = new topic.Stack
			s.push(1).push(2)
			s.poke 3, 1
			assert.strictEqual s.pop(), 3
			assert.strictEqual s.pop(), 1
		'when peek()ing the correct value must be returned': (topic) ->
			s = new topic.Stack
			s.push(1).push(2)
			assert.strictEqual s.peek(1), 2
			assert.strictEqual s.peek(0), 1
			assert.strictEqual s.peek(), 1
			s.poke(2, 0).poke(1, 1)
			assert.strictEqual s.peek(1), 1
			assert.strictEqual s.peek(0), 2
			assert.strictEqual s.peek(), 2
		'clearing an empty stack must not result in an error': (topic) ->
			s = new topic.Stack
			assert.doesNotThrow (-> s.clear()), Error
		'clearing a non empty stack must result in an empty stack': (topic) ->
			s = new topic.Stack
			s.push 1
			s.clear()
			assert.strictEqual s.length, 0
		'empty property must be true if the stack is empty': (topic) ->
			s = new topic.Stack
			assert.isTrue s.empty
		'empty must be false if the stack is not empty': (topic) ->
			s = new topic.Stack
			s.push 1
			assert.isFalse s.empty

}).export(module)

