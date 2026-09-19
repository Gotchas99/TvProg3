Class {
	#name : 'TvSeason',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'program',
		'season_number',
		'tmdbJson',
		'viewStatus',
		'watchProviders'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'converting' }
TvSeason >> asDict [

	| dict |
	dict := Dictionary new.
	dict
		at: #id put: (tmdbJson at: #id);
		at: #season_number put: (tmdbJson at: #season_number);
		at: #name put: (tmdbJson at: #name);
		at: #overview put: (tmdbJson at: #overview);
		at: #poster_path put: (tmdbJson at: #poster_path);
		at: #vote_average put: (tmdbJson at: #vote_average);
		at: #viewStatus put: self viewStatus;
		at: #watchProviders put: self watchProviders;
		at:#viewable put: self viewable.


	^ dict
]

{ #category : 'accessing' }
TvSeason >> name [ 
^tmdbJson at:#name
]

{ #category : 'accessing' }
TvSeason >> overview [

	^ tmdbJson at: #overview
]

{ #category : 'accessing' }
TvSeason >> program: aTvProgram [ 
program := aTvProgram 
]

{ #category : 'accessing' }
TvSeason >> season_number [
^
	season_number 
]

{ #category : 'accessing' }
TvSeason >> season_number:aNumber [ 
season_number := aNumber 
]

{ #category : 'accessing' }
TvSeason >> seen [ 

	 viewStatus:=#seen
]

{ #category : 'accessing' }
TvSeason >> tmdbId: anId [

	tmdbId := anId 
]

{ #category : 'accessing' }
TvSeason >> tmdbJson: aJsonDictionary [
tmdbJson := aJsonDictionary 
]

{ #category : 'accessing' }
TvSeason >> viewStatus [ 
^viewStatus ifNil: [ viewStatus:=#new ]
]

{ #category : 'accessing' }
TvSeason >> viewable [

	| tmp |
	tmp := true.
	self viewStatus = #seen ifTrue: [ tmp := false ].
	self watchProviders isEmptyOrNil ifTrue: [ tmp := false ]. 
	^ tmp
]

{ #category : 'accessing' }
TvSeason >> watchProviders [

	^ watchProviders ifNil: [ watchProviders := #() ]
]

{ #category : 'as yet unclassified' }
TvSeason >> watch_providers: aList [
watchProviders := aList 
]
