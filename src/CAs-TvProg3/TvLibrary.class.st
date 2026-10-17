Class {
	#name : 'TvLibrary',
	#superclass : 'Object',
	#instVars : [
		'programs',
		'seasonIndex'
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

	(self at: aProgram tmdbId) ifNil: [ programs add: aProgram . self indexSeasons ]
]

{ #category : 'adding' }
TvLibrary >> addProgramImdbID: aProgramID [

	| findRes tc prog |
self halt.
	tc := TmdbClient new.
	findRes := tc find_by_id: aProgramID.
	self assert: findRes size = 1.
	prog := findRes first.
	self addProgram: prog
]

{ #category : 'adding' }
TvLibrary >> addProgramTmdbID: aProgramID [

	| findRes tc prog |
	tc := TmdbClient new.
	findRes := tc find_by_id: aProgramID.
	self assert: findRes size = 1.
	prog := findRes first.
	self addProgram: prog
]

{ #category : 'accessing' }
TvLibrary >> allGenres [
| allGenres |
allGenres:=self allPrograms collect:#genres.
allGenres := allGenres flattened asSet asSortedCollection .
^allGenres 
]

{ #category : 'accessing' }
TvLibrary >> allPrograms [

	^programs
]

{ #category : 'accessing' }
TvLibrary >> at: aTmdbId [

	^programs detect: [ :p | p tmdbId = aTmdbId asString] ifNone: [ nil ]
]

{ #category : 'internal' }
TvLibrary >> indexSeasons [

	seasonIndex := Dictionary new.
	programs do: [ :p | p seasons do: [ :s | 
			seasonIndex at: s tmdbId put: s ] ]
]

{ #category : 'initialization' }
TvLibrary >> initialize [

	programs := OrderedCollection new.
	self indexSeasons.
]

{ #category : 'testing' }
TvLibrary >> isTestEnv [ 
^ NetNameResolver localHostName = 'CAs1b'
]

{ #category : 'internal' }
TvLibrary >> refreshViewability [

	programs do: [ :p | p retrieveViewability ]
]

{ #category : 'accessing' }
TvLibrary >> seasonAt: aTmdbId [

	^ seasonIndex
		 at: aTmdbId asInteger
]
