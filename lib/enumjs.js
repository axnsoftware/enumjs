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
 * TBD Use Enum.create() to create new enum classes.
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

		var i = 0;
		for (var key in decl) {

			var instance = new clazz();
			instance._name = key;
			instance._ordinal = ++i;
			dict[i] = dict[key] = clazz[key] = clazz.prototype[key] = instance;
			values.push(instance);
		}

		finalized = true;

		return clazz;
	})();
};

exports.Enum = Enum;

