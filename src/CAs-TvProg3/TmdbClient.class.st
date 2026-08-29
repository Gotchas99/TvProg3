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
"ideas for more fields: genres (list),seasons (with episode count)) "
	| raw flds dict |
	raw := self tvDetails_raw: series_id.
	flds := { #id. #name. #tagline. #overview. .#status. #vote_average. #number_of_seasons. #number_of_episodes. }.
	dict := Dictionary new.
	flds do: [ :fld | dict at: fld put: (raw at: fld) ].
	dict
		at: #poster_path
		put: 'https://image.tmdb.org/t/p/w92' , (raw at: #poster_path).
	^ dict
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
