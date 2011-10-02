#!/usr/bin/env node

var Enum = require("enumjs").Enum;

var EErrors = Enum.create( {
	NO_ERROR : 0, 
	IO_ERROR : 0, 
	IO_READ_ERROR : 0,
	IO_WRITE_ERROR : 0,
	DB_ERROR : 0, 
} );


var con = {
	executeSqlQuery: function(sqlQueryString) {

		var e = new Error();
		e.code = EErrors.valueOf(1 + Math.floor(Math.random() * 10) % 5);
		if (e.code != EErrors.NO_ERROR) {
			throw e;
		}		
	}
}; 

function getFromDB(con) {
	try {
		con.executeSqlQuery( "SELECT * FROM DB" );
	} catch (e) {
		switch (e.code)
		{
			case EErrors.IO_READ_ERROR:
				console.error("unable to read data from db connection.");
				break;
			default:
				console.warn("unhandled error");
		}
	}
}


console.log(EErrors.NO_ERROR <= EErrors.IO_WRITE_ERROR);

console.log(EErrors.NO_ERROR == 1);
