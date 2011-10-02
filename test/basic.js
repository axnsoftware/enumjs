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
	'Enum.create() must fail': {
		topic: function() { return require('../lib/enumjs.js').Enum; },
		'with a TypeError on an empty arguments list' : function(topic) {
			assert.throws(function() { topic.create(); }, TypeError);
		},
		'with a TypeError on an empty declaration' : function(topic) {
			assert.throws(function() { topic.create({}); }, TypeError);
		},
		'with a TypeError on an invalid declaration' : function(topic) {
			assert.throws(function() { topic.create("invalid"); }, TypeError);
			assert.throws(function() { topic.create(["invalid"]); }, TypeError);
			assert.throws(function() { topic.create({ CONST1 : "invalid" }); }, TypeError);
		},
		'with a TypeError on duplicate ordinals' : function(topic) {
			assert.throws(function() { topic.create({ CONST1 : 5, CONST2 : 4, CONST3 : 0 }); }, TypeError);
			assert.throws(function() { topic.create({ CONST1 : 1, CONST2 : 2, CONST3 : 1 }); }, TypeError);
			assert.throws(function() { topic.create({ CONST1 : 1, CONST2 : 1 }); }, TypeError);
			assert.throws(function() { topic.create({ CONST1 : { ordinal : 1 }, CONST2 : 2, 
				CONST3 : { ordinal : 1 } }); }, TypeError);
			assert.throws(function() { topic.create({ CONST1 : { ordinal : "a2" }, CONST2 : 1, 
				CONST3 : { ordinal : 0 } }); }, TypeError);
		},
		'with a TypeError on invalid constant literals' : function(topic) {
			assert.throws(function() { topic.create({ "CON ST1" : 0 }); }, TypeError);
			assert.throws(function() { topic.create({ "53CONST1" : 0 }); }, TypeError);
		},
	},		
	'When an enum is create()d properly using only integers': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : 1, B : 0, C : 0 } );
		},
		'The enum class cannot be instantiated' : function(topic) {
			assert.throws(function() { topic(); }, TypeError);
		},
		'The minimum ordinal is one (1)' : function(topic) {
			assert.isTrue(topic.A.ordinal() == 1);
		},
		'The ordinals are all in sequence' : function(topic) {
			assert.isTrue(
				topic.A.ordinal() == 1
				&& topic.B.ordinal() == 2
				&& topic.C.ordinal() == 3
                  	); 
		},
	},
	'When an enum is create()d properly using object notation only': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : 0, B : 0, C : 0 } );
		},
		'The enum class cannot be instantiated' : function(topic) {
			assert.throws(function() { topic(); }, TypeError);
		},
		'The minimum ordinal is one (1)' : function(topic) {
			assert.isTrue(topic.A.ordinal() == 1);
		},
		'The ordinals are all in sequence' : function(topic) {
			assert.isTrue(
				topic.A.ordinal() == 1
				&& topic.B.ordinal() == 2
				&& topic.C.ordinal() == 3
                  	); 
		},
	},
	'When an enum is create()d properly mixing object notation and integers': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : 0, B : { ordinal : 2 }, C : 0 } );
		},
		'The minimum ordinal is one (1)' : function(topic) {
			assert.isTrue(topic.A.ordinal() == 1);
		},
		'The ordinals are all in sequence' : function(topic) {
			assert.isTrue(
				topic.A.ordinal() == 1
				&& topic.B.ordinal() == 2
				&& topic.C.ordinal() == 3
                  	); 
		},
	},
	'When an enum is create()d properly with custom ordinals': {
		topic: function() {
			var Enum = require('../lib/enumjs.js').Enum;
			return Enum.create( { A : 100, B : { ordinal : 49 }, C : 0 } );
		},
		'The minimum ordinal is one (100)' : function(topic) {
			assert.isTrue(topic.B.ordinal() == 49
				&& topic.A.ordinal() > topic.B.ordinal()
				&& topic.C.ordinal() > topic.B.ordinal());
		},
		'There is a gap of 50 between the ordinals of A and C, with B and C being in sequence' : function(topic) {
			assert.isTrue(
				(topic.A.ordinal() - topic.C.ordinal() == 50)
				&& (topic.C.ordinal() - topic.B.ordinal()) == 1
                  	); 
		},
	},
}).export(module);

