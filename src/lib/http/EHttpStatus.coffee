
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

##INCLUDE##

{Enum} = require '../enum.coffee'

#
# http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
#

EHttpStatus = Enum.create({

	ctor: (@_description = '', @_since = '1.0') ->

	instance:
		description: ->
			@_description
		since: ->
			@_since

	# Class: Informational 1xx
	HTTP_STATUS_100:
		construct: ['Continue']
		ordinal: 100

	HTTP_STATUS_101:
		construct: ['Switching Protocols']

	# Class: Successful 2xx 
	HTTP_STATUS_200:
		construct: ['OK']
		ordinal: 200

	HTTP_STATUS_201:
		construct: ['Created']

	HTTP_STATUS_202:
		construct: ['Accepted']

	HTTP_STATUS_203:
		construct: ['Accepted']

	HTTP_STATUS_204:
		construct: ['No Content']

	HTTP_STATUS_205:
		construct: ['Reset Content']

	HTTP_STATUS_206:
		construct: ['Partial Content']

	# Class: Redirection 3xx
	HTTP_STATUS_300:
		construct: ['Multiple Choices']
		ordinal: 300

	HTTP_STATUS_301:
		construct: ['Moved Permanently']

	HTTP_STATUS_302:
		construct: ['Found']

	HTTP_STATUS_303:
		construct: ['See Other']

	HTTP_STATUS_304:
		construct: ['Not Modified']

	HTTP_STATUS_305:
		construct: ['Use Proxy']

	HTTP_STATUS_306:
		construct: ['RESERVED']

	HTTP_STATUS_307:
		construct: ['Temporary Redirect']

	# Class: Client Error 4xx
	HTTP_STATUS_400:
		construct: ['Bad Request']
		ordinal: 400

	HTTP_STATUS_401:
		construct: ['Unauthorized']

	HTTP_STATUS_402:
		construct: ['Payment Required']

	HTTP_STATUS_403:
		construct: ['Forbidden']

	HTTP_STATUS_404:
		construct: ['Not Found']

	HTTP_STATUS_405:
		construct: ['Method Not Allowed']

	HTTP_STATUS_406:
		construct: ['Not Acceptable']

	HTTP_STATUS_407:
		construct: ['Proxy Authentication Required']

	HTTP_STATUS_408:
		construct: ['Request Timeout']

	HTTP_STATUS_409:
		construct: ['Conflict']

	HTTP_STATUS_410:
		construct: ['Gone']

	HTTP_STATUS_411:
		construct: ['Length Required']

	HTTP_STATUS_412:
		construct: ['Precondition Failed']

	HTTP_STATUS_413:
		construct: ['Request Entity Too Large']

	HTTP_STATUS_414:
		construct: ['Request-URI Too Long']

	HTTP_STATUS_415:
		construct: ['Unsupported Media Type']

	HTTP_STATUS_416:
		construct: ['Request Range Not Satisfiable']

	HTTP_STATUS_417:
		construct: ['Expectation Failed']

	# Class: Server Error 5xx
	HTTP_STATUS_500:
		construct: ['Internal Server Error']
		ordinal: 500

	HTTP_STATUS_501:
		construct: ['Not Implemented']

	HTTP_STATUS_502:
		construct: ['Bad Gateway']

	HTTP_STATUS_503:
		construct: ['Service Unavailable']

	HTTP_STATUS_504:
		construct: ['Gateway Timeout']

	HTTP_STATUS_505:
		construct: ['HTTP Version Not Supported']

})

exports.EHttpStatus = EHttpStatus

