Class {
	#name : 'OmdbClient',
	#superclass : 'Object',
	#classVars : [
		'ApiKey'
	],
	#category : 'CAs-TvProg3',
	#package : 'CAs-TvProg3'
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
