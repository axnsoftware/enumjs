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


# The exception StackOverflowError will be thrown whenever a limited size
# stack exceeds its maximum storage capacity.
class StackOverflowError extends Error


# The exception StackUnderflowError will be thrown whenever pop() was
# called while the stack was empty.
class StackUnderflowError extends Error


# This is the holder for our private data.
class StackPrivate

	constructor: (@stackSize, @elements=[]) ->



# The class Stack models a LIFO list of elements.
class Stack

	constructor: (stackSize = Number.POSITIVE_INFINITY) ->
		throw new RangeError("0 < stackSize:#{stackSize} <= #{Number.POSITIVE_INFINITY}") if stackSize <= 0
		Object.defineProperty @, 'private', { value: new StackPrivate(stackSize), writable: false, enumerable: false }
		self = @
		Object.defineProperty @, 'stackSize', { 
			get: -> 
				self.private.stackSize
			enumerable: true
		}
		Object.defineProperty @, 'length', { 
			get: -> 
				self.private.elements.length
			enumerable: true
		}
		Object.defineProperty @, 'empty', { 
			get: -> 
				self.length == 0
			enumerable: true
		}

	clear: ->
		@private.elements = []
		@

	peek: (offset = 0) ->
		throw new RangeError("0 <= offset:#{offset} < #{@length}") if 0 > offset or offset >= @length
		@private.elements[offset]

	poke: (value, offset = 0) ->
		throw new RangeError("0 <= offset:#{offset} < #{@length}") if 0 > offset or offset >= @length
		@private.elements[offset] = value
		@

	pop: ->
		throw new StackUnderflowError if @length == 0
		@private.elements.pop()

	push: (value) ->
		throw new StackOverflowError if (@length) == @stackSize
		@private.elements.push value
		@


#
# exports
#
exports.Stack = Stack
exports.StackOverflowError = StackOverflowError
exports.StackUnderflowError = StackUnderflowError

