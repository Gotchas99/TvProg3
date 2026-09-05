Class {
	#name : 'TvLibrary',
	#superclass : 'Object',
	#instVars : [
		'programs'
	],
	#classVars : [
		'Default'
	],
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'accessing' }
TvLibrary class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
TvLibrary class >> reset [

 Default :=nil
]

{ #category : 'adding' }
TvLibrary >> addProgram: aProgram [

(self at: aProgram tmdbId )ifNil: [
	programs add: aProgram]
]

{ #category : 'as yet unclassified' }
TvLibrary >> allPrograms [

	^programs
]

{ #category : 'adding' }
TvLibrary >> at: aTmdbId [

	^programs detect: [ :p | p tmdbId = aTmdbId asString] ifNone: [ nil ]
]

{ #category : 'as yet unclassified' }
TvLibrary >> initialize [ 
programs := OrderedCollection new.
]
