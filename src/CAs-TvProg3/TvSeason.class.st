Class {
	#name : 'TvSeason',
	#superclass : 'Object',
	#instVars : [
		'tmdbId',
		'program',
		'season_number',
		'tmdbJson',
		'viewStatus'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

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
TvSeason >> season_number:aNumber [ 
season_number := aNumber 
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
