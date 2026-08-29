Class {
	#name : 'TmdbClient',
	#superclass : 'Object',
	#classVars : [
		'ApiKey',
		'Token'
	],
	#category : 'CAs-TvProg3',
	#package : 'CAs-TvProg3'
}

{ #category : 'accessing' }
TmdbClient class >> token [

	^ Token 
]

{ #category : 'accessing' }
TmdbClient class >> token:aToken [

 Token :=aToken 
]

{ #category : 'private' }
TmdbClient >> client [

	| zn |
	zn := ZnClient new setBearerAuthentication:self class token;
	url: 'https://api.themoviedb.org/3/';forJsonREST.
	^zn
]

{ #category : 'as yet unclassified' }
TmdbClient >> tvDetails: series_id [

	|  raw flds dict |
	raw := self tvDetails: series_id.
	flds := { #id. #name.#tagline }.
	dict := Dictionary new.
	flds do:[:fld|dict a.fld put:(raw at:fld)].
	^dict
]

{ #category : 'as yet unclassified' }
TmdbClient >> tvDetails_raw: series_id [

	| cl |
	cl := self client
		      addPath: #tv;
		      addPath: series_id asString.
	cl get.
	^ cl contents
]
