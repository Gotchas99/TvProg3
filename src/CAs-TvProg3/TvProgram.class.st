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
		'seasons',
		'interest',
		'viewStatus',
		'tmdbJsonSeasons',
		'watchProviders'
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
TvProgram >> genres [

	^ (tmdbJson at:#genres)collect:[:g|g at:#name]
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

	seasons := OrderedCollection new.
	interest:=#new
]

{ #category : 'accessing' }
TvProgram >> interest [

	^ interest ifNil:[interest:=#new]
]

{ #category : 'accessing' }
TvProgram >> name [
^tmdbJson at:#name
]

{ #category : 'accessing' }
TvProgram >> number_of_seasons [
self assert: type = #tv.
	^ tmdbJson at: #number_of_seasons
]

{ #category : 'parsing' }
TvProgram >> parseOmdb [
]

{ #category : 'parsing' }
TvProgram >> parseTmdb [

	name := tmdbJson at: #name.
	seasons := (tmdbJson at: #seasons) collect: [ :s |
			           TvSeason new
				           program: self;
				           tmdbJson: s; 
				           tmdbId: (s at: #id);
				           season_number: (s at: #season_number) ]
]

{ #category : 'printing' }
TvProgram >> printOn: aStream [

	super printOn: aStream.
	aStream << '(' << type << ':' << tmdbId << '* ' << name << ')' 
]

{ #category : 'accessing' }
TvProgram >> productionStatus [

		^ tmdbJson at:#status
]

{ #category : 'retrieve' }
TvProgram >> retrieve [

	self retrieveTmdb .
	self retrieveOmdb 
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

{ #category : 'retrieve' }
TvProgram >> retrieveViewability [
	"do this for show and for seasons"

	| cl |
	cl := TmdbClient new.
	watchProviders := cl watch_providers: tmdbId.
	seasons do: [ :s |
		s watchProviders: (cl watch_providers: tmdbId season: s season_number) ]
]

{ #category : 'accessing' }
TvProgram >> seasons [

	self assert: type = #tv.
	^ seasons
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

{ #category : 'accessing' }
TvProgram >> viewStatus [
self flag:'ska beräknas från säsonger'.
	^ viewStatus ifNil: [ viewStatus := #new ]
]

{ #category : 'accessing' }
TvProgram >> viewable [

	"If any seasons are viewable"
	^ viewStatus ifNil: [ viewStatus := #new ]
]
