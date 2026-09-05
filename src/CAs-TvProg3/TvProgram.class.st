Class {
	#name : 'TvProgram',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'imdbId',
		'seasons',
		'tmdbJson',
		'omdbJson',
		'name',
		'type'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'accessing' }
TvProgram >> id [ 
^tmdbId 
]

{ #category : 'accessing' }
TvProgram >> id:aTmdbID [
tmdbId:=aTmdbID 
]

{ #category : 'accessing' }
TvProgram >> imdbId [
^
	imdbId 
]

{ #category : 'accessing' }
TvProgram >> imdbId: aImdbID [

	imdbId := aImdbID
]

{ #category : 'initialization' }
TvProgram >> initialize [

	seasons:= OrderedCollection new.
]

{ #category : 'accessing' }
TvProgram >> name [
^tmdbJson at:#name
]

{ #category : 'parsing' }
TvProgram >> parseOmdb [
]

{ #category : 'parsing' }
TvProgram >> parseTmdb [

	name:= tmdbJson at:#name.
]

{ #category : 'printing' }
TvProgram >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
]

{ #category : 'retrieve' }
TvProgram >> retrieveOmdb [

	| cl |
	self assert: imdbId notNil.
	self assert: type notNil.
	cl := OmdbClient new.
	omdbJson := cl tv_details: imdbId.
	self parseOmdb
]

{ #category : 'retrieve' }
TvProgram >> retrieveTmdb [

	| cl extIDs |
	self assert: tmdbId notNil.
	self assert: type notNil.
	cl := TmdbClient new.
	tmdbJson := type = #tv 
		            ifTrue: [ cl tv_details: tmdbId ]
		            ifFalse: [ cl movie_details: tmdbId ].
	self parseTmdb.
	extIDs := type = #tv
		          ifTrue: [ cl tv_external_ids: tmdbId ]
		          ifFalse: [ cl movie_external_ids: tmdbId ].
	imdbId := extIDs at: #imdb_id
]

{ #category : 'accessing' }
TvProgram >> tmdbId [
 
	^ tmdbId
]

{ #category : 'accessing' }
TvProgram >> tmdbId: aTmdbID [

	tmdbId := aTmdbID asString
]

{ #category : 'accessing' }
TvProgram >> type [ ^type
]

{ #category : 'accessing' }
TvProgram >> type: aType [

	 type:=aType
]
