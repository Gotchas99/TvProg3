Class {
	#name : 'TvProgram',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'imdbId',
		'seasons',
		'tmdbJson',
		'omdbJson',
		'name'
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

{ #category : 'accessing' }
TvProgram >> parseOmdb [
]

{ #category : 'accessing' }
TvProgram >> parseTmdb [

	name:= tmdbJson at:#name.
]

{ #category : 'accessing' }
TvProgram >> retrieveOmdb [

	| cl |
	self assert: imdbId notNil.
	cl := OmdbClient new.
	omdbJson := cl tvDetails: imdbId .
	self parseOmdb.
]

{ #category : 'accessing' }
TvProgram >> retrieveTmdb [

	| cl extIDs |
	self assert: tmdbId notNil.
	cl := TmdbClient new.
	tmdbJson := cl tvDetails: tmdbId.
	self parseTmdb.
	extIDs := cl tv_external_ids: tmdbId.
	imdbId := extIDs at:#imdb_id.
]

{ #category : 'accessing' }
TvProgram >> tmdbId [
^

	tmdbId 
]

{ #category : 'accessing' }
TvProgram >> tmdbId: aTmdbID [

	tmdbId := aTmdbID asString
]
