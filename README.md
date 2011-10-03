# enumjs

## Introduction

The enumjs package is both a learning project, see motivation below, and it serves as a
starting point for creating a bundle that combines many of the commonly used data types
into a single package.

The package currently provides you with only an enum class that can be used basically just
like the enum classes you know from Java. Declared enum constants can be used in 
comparisons (==, ===, >, >=, <, <=, !=) and switch statements. Enum constants are, just 
like Java, instances of their declaring class and they are assigned as fields to that 
declaring class.

## License

    Copyright 2011 axn software UG (haftungsbeschränkt)
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

See [License](http://github.com/axnsoftware/enumjs/wiki/License) for more details.

## Motivation

This is mainly a simple learning project with the goals being set on 

 * CommonJS Package Descriptors (http://wiki.commonjs.org/wiki/Packages/1.1)
 * GNU/Make and its application with node/Javascript projects (http://www.gnu.org/software/make/)
 * vowsjs TDD Framework (http://vowsjs.org/)
 * coffeescript (http://jashkenas.github.com/coffee-script/)
 * JSCoverage (http://siliconforks.com/jscoverage/)
 * node-jscoverage (https://github.com/visionmedia/node-jscoverage)

## Compatibility 

### coffee-script
enumjs' original sources are written in coffee-script. They can be found inside the src/* folders.
coffee-script is being used in favour of plain Javascript due to the fact that the overall number of
lines of executable code could be reduced by approx. 25-33% when using coffee-script.

### user agents
Since the removal of a dependency towards node's util module, and by compiling the Javascript sources
from the coffee-script sources, the generated Javascript should be compatible with the existing 
user agents.

### node
enumjs has been tested with node >= 0.5.5pre but it should work with previous version as well.
Please note that console.dir() seems to be bugged in very early versions of node, causing
constructs like 

    var t = function() {};
    t.f = function() { throw new Error(); }; 
    console.dir(t);

to throw the exception due to t.f() being called during console.dir(). It mainly showed itself
when outputting instances of enums or enum classes themselves to the console, as per default,
the constructor of the enum class will throw a TypeError in order to prevent it from being
instantiated or derived from. There is a check for that in the Makefile.

## Installation

1. clone the repository
2. make all
3. [sudo] make install
4. export NODE_PATH=${NODE_PATH}:/usr/local/share/node_modules

## Usage

    var Enum = require("enumjs").Enum;
    // simple notation (LIT1 .. LIT2 will be assigned the ordinals 1..2)
    var EMyEnum = Enum.create( { LIT1 : 0, LIT2 : 0 } );
    // simple notation (LIT1 .. LIT2 will be assigned the ordinals 3..4)
    var EMyEnum = Enum.create( { LIT1 : 3, LIT2 : 0 } );
    // simple notation (LIT1 .. LIT2 will be assigned the ordinals 3,19)
    var EMyEnum = Enum.create( { LIT1 : 3, LIT2 : 19 } );
    // object notation (empty for defaults)
    var EMyEnum = Enum.create( { LIT1 : {}, LIT2 : {} } );
    // object notation (LIT1 .. LIT2 will be assigned the ordinals 10,49)
    var EMyEnum = Enum.create( { LIT1 : { ordinal: 10 }, LIT2 : { ordinal: 49 } } );
    var v = EMyEnum.LIT1;
    switch(v) {
        case EMyEnum.LIT1: {
            console.log("matched LIT1"); 
            break;
        }
        case EMyEnum.LIT2: {
            console.log("matched LIT2");
            break;
        }
        default: {
            throw new Error("no match");
        }
    }

## TODO

- proper README and documentation
- custom constructors, class and instance methods
- more data types
