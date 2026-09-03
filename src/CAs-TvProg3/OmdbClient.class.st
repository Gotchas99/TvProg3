Class {
	#name : 'OmdbClient',
	#superclass : 'Object',
	#classVars : [
		'ApiKey'
	],
	#category : 'CAs-TvProg3-API',
	#package : 'CAs-TvProg3',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
OmdbClient class >> apiKey [
^ApiKey
]

{ #category : 'as yet unclassified' }
OmdbClient class >> apiKey:aKey [
"API key is in mail
sample request:
http://www.omdbapi.com/?i=tt3896198&apikey=xxxxxxxx"
ApiKey:=aKey 
]

{ #category : 'private' }
OmdbClient >> client [
"sample call:
http://www.omdbapi.com/?i=tt3896198&apikey=xxxxxxxx"
	| zn |
	zn := ZnClient new
		     		      url: 'http://www.omdbapi.com';
				queryAt: 'apikey' put: self class apiKey ;
		      forJsonREST.
	^ zn
]

{ #category : 'as yet unclassified' }
OmdbClient >> tvDetails: series_id [
	"ideas for more fields: genres (list),seasons (with episode count)) "

	| raw  cl |
	cl := self client queryAt: 'i' put: series_id asString.
	cl get.
	raw :=  cl contents.	
	^ raw
]
