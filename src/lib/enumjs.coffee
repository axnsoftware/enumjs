

class Enum
	constructor: () ->
		throw new TypeError("enums cannot be instantiated nor derived from."); 

	name: () ->
		return @_name

	ordinal: () ->
		return @_ordinal

	valueOf: () ->
		return @_ordinal


Enum.create = (decl) ->
	oargs = arguments
	_ = ->
		if decl is null or oargs.length == 0 or decl.length or typeof decl isnt 'object'
			throw new TypeError("Illegal argument.") 

		dict = {}
		values = []
		finalized = false

		class clazz extends Enum
			constructor: (name, ordinal) ->
				throw new TypeError("enums cannot be instantiated nor derived from.") if finalized
				@_name = name
				@_ordinal = ordinal

		# we must delete the create method
		delete clazz.create

		# make it node compatible
		clazz.super_ = Enum

		clazz.valueOf = (value) ->
			throw new TypeError("'#{value}' is not a constant of this.") unless value in dict
			dict[value] if value in dict

		clazz.values = () ->
			value for value in values

		rule = /^[A-Za-z_\$]+[A-Za-z0-9\$_]*$/
		ord = 1
		for key, spec of decl
			key = key.trim()

			if key.match(rule) is null
				throw new TypeError("Constant literal must match production '#{rule}'.")

			newOrd = -1
			specType = typeof spec
			if specType is 'object'
				specType = 'number'
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
			dict[ord] = dict[key] = clazz[key] = clazz.prototype[key] = instance
			values.push instance
			ord += 1

		if values.length == 0
			throw new TypeError("Enums require at least one literal constant.");

		finalized = true;

		clazz
		
	_()


exports.Enum = Enum;

c = Enum.create( { A : 0, B : 0 } )

