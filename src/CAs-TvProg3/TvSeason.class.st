Class {
	#name : 'TvSeason',
	#superclass : 'Object',
	#instVars : [
		'program',
		'season_number',
		'tmdbId',
		'tmdbJson',
		'viewStatus',
		'watchProviders'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
TvSeason class >> instancesNotInLibrary [
self flag:#todo.
	^self allInstances reject:[:p|p isInLibrary ].
]

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
		at: #viewable put: self isViewable.


	^ dict
]

{ #category : 'as yet unclassified' }
TvSeason >> dbData [ 
self halt.
]

{ #category : 'testing' }
TvSeason >> isAvailable [
	
	^self watchProviders isEmptyOrNil not
]

{ #category : 'testing' }
TvSeason >> isSeen [ 
^viewStatus =#seen.
]

{ #category : 'testing' }
TvSeason >> isViewable [

	self isSeen ifTrue: [ ^ false ].
	^self isAvailable 
]

{ #category : 'accessing' }
TvSeason >> name [ 
^tmdbJson at:#name
]

{ #category : 'accessing' }
TvSeason >> overview [

	^ tmdbJson at: #overview
]

{ #category : 'printing' }
TvSeason >> printOn: aStream [

super printOn: aStream.
	aStream << '('  << program name <<':'<< season_number asString <<')'
]

{ #category : 'accessing' }
TvSeason >> program [ ^

	program
]

{ #category : 'accessing' }
TvSeason >> program: aTvProgram [ 
program := aTvProgram 
]

{ #category : 'as yet unclassified' }
TvSeason >> saveToDb [

	| msg |
	msg := Message selector: #writeSeason: argument: self dbData.
	TvDB default queueWrite: msg.
	
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
TvSeason >> watchProviders [

	^ watchProviders ifNil: [ watchProviders := #() ]
]

{ #category : 'accessing' }
TvSeason >> watch_providers: aList [
watchProviders := aList 
]
