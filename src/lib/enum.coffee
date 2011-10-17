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

# The class Enum models the root of a hierarchy of derived classes.
#
# The hierarchy itself is shallow, as enums cannot be derived from
# existing other enums except for when being created when they are
# initially subclassed from Enum.
class Enum
	# Default constructor. Prevents instantiation of the class.
	constructor: () ->
		throw new TypeError("enums cannot be instantiated and must not be inherited from.")

	# Same as ordinal().
	#
	# @return the integer ordinal
	valueOf: () ->
		return @ordinal

exports.Enum = Enum


# The factory used for creating new enum classes.
# TBD
Enum.create = (decl) ->
	oargs = arguments
	declare = ->
		if decl is null or oargs.length == 0 or typeof decl == 'array' or typeof decl isnt 'object'
			throw new TypeError("Illegal argument.") 

		dict = {}
		values = []
		finalized = false

		class clazz extends Enum
			constructor: (name, ordinal) ->
				throw new TypeError("enums cannot be instantiated and must not be inherited from.") if finalized
				Object.defineProperty @, 'name', { value: name, writable: false, enumerable: true }
				Object.defineProperty @, 'ordinal', { value: ordinal, writable: false, enumerable: true }

		# we must delete the create method
		delete clazz.create

		# make it node compatible
		clazz.super_ = Enum

		# Returns the constant for either name or ordinal.
		#
		# @throws TypeError in case that the value does not match any one of the ordinals or names (case sensitive)
		# @return enum constant
		clazz.valueOf = (value) ->
			if value instanceof clazz
				return value
			if value of dict
				return dict[value]
			throw new TypeError("'#{value}' is not a constant of this.")

		# Returns the enum constants.
		#
		# @return array containing the enum constants defined by the enum class.
		clazz.values = () ->
			value for value in values

		# Do we have a custom constructor?
		ctor = null
		if 'ctor' of decl
			ctor = decl.ctor
			delete decl.ctor

		# Do we have custom static class fields?
		self = clazz
		regexp = /^function[^(]*[(]([^)]*)[)](.*)$/
		if 'statics' of decl
			for name, field of decl.statics
				if typeof field == 'function'
					# must eval()uate here to overcome scope limitations
					source = field.toString()
					eval "clazz[name] = " + source
				else
					clazz[name] = field
			delete decl.statics

		# bind custom instance fields if avail
		if 'instance' of decl
			for name, field of decl.instance
				if typeof field == 'function'
					fun = (field) ->
						method = field
						-> 
							method.apply this, arguments
					clazz.prototype[name] = fun field
				else
					clazz.prototype[name] = field
			delete decl.instance

		# we bind custom ctors later
		lateBoundCtorArgs = []
		rule = /^[A-Za-z_\$]+[A-Za-z0-9\$_]*$/
		ord = 1
		for key, spec of decl
			key = key.trim()

			if key.match(rule) is null
				throw new TypeError("Constant literal must match production '#{rule}'.")

			ctorArgs = []
			newOrd = -1
			specType = typeof spec
			if specType is 'object'
				specType = 'number'
				if 'construct' of spec
					ctorArgs = spec.construct
				if 'ordinal' of spec
					specType = typeof spec.ordinal
					spec = spec.ordinal
			if specType is 'number'
				newOrd = spec
			else
				throw new TypeError("Ordinal must be a number. (literal='#{key}', type='#{specType}', value='#{spec}'")
			ord = newOrd if newOrd > 0
			if ord of dict
				throw new TypeError("Duplicate ordinals. (ordinal='#{ord}', literal='#{dict[ord].name()}', duplicate='#{key}'.)")

			instance = new clazz key, ord
			instance.self = clazz
			lateBoundCtorArgs.push ctorArgs

			dict[ord] = dict[key] = clazz[key] = clazz.prototype[key] = instance
			values.push instance
			ord += 1

		if values.length == 0
			throw new TypeError("Enums require at least one literal constant.");

		# bind custom ctor if avail
		if ctor?
			i = 0
			len = values.length
			while i < len
				ctor.apply values[i], lateBoundCtorArgs[i]
				i++

		# prevent instantiation of the enum class
		finalized = true;

		clazz
		
	declare()

