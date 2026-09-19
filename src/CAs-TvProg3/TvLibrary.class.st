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

{ #category : 'adding' }
TvLibrary >> addProgramImdbID: aProgramID [

	| findRes tc prog |
	
	tc:=TmdbClient new .
	findRes:= tc find_by_id: aProgramID .
	self assert: (findRes size = 1).
	prog := findRes first.
	self addProgram: prog.
]

{ #category : 'adding' }
TvLibrary >> addProgramTmdbID: aProgramID [

	self halt.
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

{ #category : 'as yet unclassified' }
TvLibrary >> refreshViewability [

	programs do: [ :p | p retrieveViewability ]
]
