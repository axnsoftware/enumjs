/*
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
 */

var util = require("util");

/**
 * The class Enum models the root of a (flat and wide) hierarchy of
 * derived classes.
 *
 * DOCUMENT:axn Use Enum.create() to create new enum classes.
 *
 * @throws TypeError, enums cannot be instantiated and they cannot be derived from
 */
var Enum = function() {
	throw new TypeError("enums cannot be instantiated nor derived from."); 
};

/**
 * @return the literal name of this.
 */
Enum.prototype.name = function() { return this._name; };

/**
 * @return the integer ordinal of this.
 */
Enum.prototype.ordinal = function() { return this._ordinal; };

/**
 * Creates a new enum class that inherits from Enum.
 *
 * @return the newly created enum class.
 */
Enum.create = function(decl) {

	return (function() {

		if (decl == 'undefined' || decl.length || typeof decl != 'object')
		{
			throw new TypeError("Illegal argument.");
		}

		var dict = {};
		var values = [];
		var finalized = false;

		var clazz = function() {
			if (finalized) {
				throw new TypeError("enums cannot be instantiated nor derived from.");
			}
		};
		util.inherits(clazz, Enum);

		/**
		 * Tries to get a constant for the specified value value from this.
		 * Value value can be either a string constant or an integer ordinal.
		 *
		 * @throws TypeError in case that the specified value value is not an ordinal 
                 *         or literal constant of this.
		 * @return a constant declared by this.
		 */
		clazz.prototype.valueOf = clazz.valueOf = function(value) {

			if (value in dict) {
				return dict[value];
			}

			throw new TypeError("'" + value + "' is not a constant of this.");
		};

		/**
		 * Gets the values. 
		 *
		 * @return the constants declared by this.
		 */
		clazz.prototype.values = clazz.values = function() {

			var result = [];

			for (var i in values)
			{
				result.push(values[i]);
			}

			return result;
		};

		var ord = 1;
		for (var key in decl) {
			key = key.trim();
			if (key.match(/^[A-Za-z_\$]+[A-Za-z0-9\$_]*$/) == null) {
				throw new TypeError("Constant literal must meet the following production rule "
					+ "'^[A-Za-z_\$]+[A-Za-z0-9\$_]*$'. (literal='" + key + "'.)");
			}

			var spec = decl[key];
			var newOrd = -1;
			if (typeof spec == 'number') {
				newOrd = spec;
			} else if (typeof spec == 'object' && 'ordinal' in spec 
				   && typeof spec.ordinal == 'number') {
				newOrd = spec.ordinal;
			} else {
				throw new TypeError("Ordinal must be a 'number'. (literal='" + key + "', type=" 
					+ (typeof spec == 'object' ? typeof spec.ordinal : typeof spec) 
					+ ", value=" + spec + ".)");
			}
			if (newOrd > 0) {
				ord = newOrd;
			}
			if (ord in dict) {
				throw new TypeError("Cannot declare enum with duplicate ordinals. (ordinal=" 
					+ ord + ", literal='" + dict[ord].name() + "', duplicate='" + key + "'.)"); 
			} 
			var instance = new clazz();
			instance._name = key;
			instance._ordinal = ord;
			dict[ord] = dict[key] = clazz[key] = clazz.prototype[key] = instance;
			values.push(instance);
			ord += 1;
		}

		if (values.length == 0) {
			throw new TypeError("Enums require at least one literal constant.");
		}

		finalized = true;

		return clazz;
	})();
};

exports.Enum = Enum;

