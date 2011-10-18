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



class StackOverflowError extends Error


class StackUnderflowError extends Error


# The class Stack models a LIFO list of elements.
class Stack

	constructor: (stackSize = Number.POSITIVE_INFINITY) ->
		throw new RangeError("0 < stackSize:#{stackSize} <= #{Number.POSITIVE_INFINITY}") if stackSize <= 0
		Object.defineProperty @, '_elements', { value: [], writable: false, enumerable: false }
		Object.defineProperty @, 'stackSize', { value: stackSize, writable: false, enumerable: true }
		self = @
		Object.defineProperty @, 'length', { 
			get: -> 
				self._elements.length
			enumerable: true
		}

	peek: (offset = 0) ->
		throw new RangeError("0 <= offset:#{offset} < #{@length}") if 0 > offset or offset >= @length
		@_elements[offset]

	poke: (value, offset = 0) ->
		throw new RangeError("0 <= offset:#{offset} < #{@length}") if 0 > offset or offset >= @length
		@_elements[offset] = value
		@

	pop: ->
		throw new StackUnderflowError if @length == 0
		@_elements.pop()

	push: (value) ->
		throw new StackOverflowError if (@length) == @stackSize
		@_elements.push value
		@


#
# exports
#
exports.Stack = Stack
exports.StackOverflowError = StackOverflowError
exports.StackUnderflowError = StackUnderflowError

