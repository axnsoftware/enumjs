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

var vows = require("vows");
var assert = require("assert");


var Enum = require("../lib/enumjs.js").Enum;

var Et = Enum.create( { A : {}, B : {}, C : {} } );

vows.describe('Basic Tests').addBatch({
	'When require()d': {
		topic: function() { return require('../lib/enumjs.js'); },
		'the source must compile': function(topic) {
			assert.isNotNull(topic);
		},
		'the Enum export must be available': function(topic) {
			assert.isTrue('Enum' in topic);
		},
		'Enum must be a class function': function(topic) {
			assert.isFunction(topic.Enum);
		},
		'Enum must not be instantiatable': function(topic) {
			assert.throws(function() { topic.Enum(); }, TypeError);
		},
		'Enum.create() must be available': function(topic) {
			assert.isFunction(topic.Enum.create);
		}
	},
	'When Enum.create() is not called properly': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : {}, B : {}, C : {} } );
		},
		'The enum class cannot be instantiated' : function(topic) {
			assert.throws(function() { topic(); }, TypeError);
		},
		'The ordinals are all in sequence' : function(topic) {
		}
	},		
	'When a simple enum is Enum.create()d properly': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : {}, B : {}, C : {} } );
		},
		'The enum class cannot be instantiated' : function(topic) {
			assert.throws(function() { topic(); }, TypeError);
		},
		'The ordinals are all in sequence' : function(topic) {
			
		}
	}}).export(module);

