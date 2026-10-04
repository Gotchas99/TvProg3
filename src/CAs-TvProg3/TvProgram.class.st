Class {
	#name : 'TvProgram',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'tmdbJson',
		'tmdbJsonSeasons',
		'omdbJson',
		'imdbId',
		'name',
		'type',
		'seasons',
		'interest',
		'viewStatus',
		'watchProviders'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TvProgram class >> instancesNotInLibrary [

	^self allInstances reject:[:p|p isInLibrary ].
]

{ #category : 'converting' }
TvProgram >> asDict [

	| flds dict |
	flds := { #id. #name. #tagline. #overview. #status. #vote_average.
	        #imdbRating. #number_of_seasons. #number_of_episodes }.
	dict := Dictionary new.
	flds do: [ :fld | dict at: fld put: (self at: fld) ].
	dict
		at: #viewStatus put: self viewStatus;
		at: #watchProviders put: self watchProviders;
		at: #viewable put: self isViewable;
		at: #genres put: self genres.
	^ dict
]

{ #category : 'accessing' }
TvProgram >> at: aFldName [

	| res |
	res:= tmdbJson at:aFldName ifAbsent: [ omdbJson at:aFldName ].^res
]

{ #category : 'as yet unclassified' }
TvProgram >> dbData [

	| dict |
	dict := Dictionary new.
	dict at:#tmdb_id put: tmdbId .
	dict at:#imdb_id put: imdbId .
	dict at:#name put: name .
	dict at:#type put: type .
	dict at:#interest put: interest .
	dict at:#view_status put: viewStatus .
	dict at: #watch_providers put: ('|' join: watchProviders).
	dict at: #tmdb_json put: (NeoJSONWriter toStringPretty: tmdbJson).
	dict at: #tmdb_json_seasons put: (NeoJSONWriter toStringPretty: tmdbJsonSeasons).
	dict at: #omdb_json put: (NeoJSONWriter toStringPretty: omdbJson).
	^ dict
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

{ #category : 'testing' }
TvProgram >> isInLibrary [

	^ (TvLibrary default at: self tmdbId) =self 
]

{ #category : 'testing' }
TvProgram >> isSeen [

	^seasons allSatisfy: #isSeen
]

{ #category : 'testing' }
TvProgram >> isViewable [
	"If any seasons are viewable"

	^ seasons anySatisfy: #isViewable  
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

{ #category : 'retrieve' }
TvProgram >> parseOmdb [
]

{ #category : 'retrieve' }
TvProgram >> parseTmdb [

	name := tmdbJson at: #name.
	tmdbJsonSeasons :=(tmdbJson at: #seasons).
	(tmdbJson at: #seasons) do: [ :json |
			seasons
				detect: [ :s | s season_number = (json at: #season_number) ]
				ifFound: [ :season | season tmdbJson: json ]
				ifNone: [
						seasons add: (TvSeason new
								 program: self;
								 tmdbJson: json;
								 tmdbId: (json at: #id);
								 season_number: (json at: #season_number)) ] ]
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
		s watch_providers:
			(cl watch_providers: tmdbId season: s season_number) ]
]

{ #category : 'as yet unclassified' }
TvProgram >> saveToDb [

	| msg |
	msg := Message selector: #writeProgram: argument: self dbData.
	TvDB default queueWrite: msg
.	seasons  do: [ :each | each saveToDb ]
]

{ #category : 'accessing' }
TvProgram >> seasons [

	self assert: type = #tv.
	^ seasons ifNil:[seasons :=OrderedCollection new]
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

	| allSeen |
	self flag: 'ska beräknas från säsonger'.
	(seasons allSatisfy: #isSeen )ifTrue: [^#seen]..
	^ viewStatus ifNil: [ viewStatus := #new ]
]

{ #category : 'accessing' }
TvProgram >> watchProviders [

	^ watchProviders ifNil: [ watchProviders := #(  ) ]
]
