Class {
	#name : 'TvProgram',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'imdbId',
		'tmdbJson',
		'omdbJson',
		'name',
		'type',
		'seasons'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'accessing' }
TvProgram >> at: aFldName [

	| res |
	res:= tmdbJson at:aFldName ifAbsent: [ omdbJson at:aFldName ].^res
]

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
	aStream << '(' << type << ':' << tmdbId << '* ' << name << ')' 
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
	type = #tv
		ifTrue: [
			extIDs :=	cl tv_external_ids: tmdbId.
				imdbId := extIDs at: #imdb_id ]
		ifFalse: [ imdbId := tmdbJson at: #imdb_id ]
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
