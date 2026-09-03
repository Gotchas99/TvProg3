Class {
	#name : 'TvDB',
	#superclass : 'Object',
	#classVars : [
		'Default'
	],
	#category : 'CAs-TvProg3-DB',
	#package : 'CAs-TvProg3',
	#tag : 'DB'
}

{ #category : 'class initialization' }
TvDB class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'class initialization' }
TvDB class >> initialize [

	SessionManager default registerUserClassNamed: self name
]

{ #category : 'class initialization' }
TvDB class >> reset [

	Default ifNotNil: [
		self default close.
		Default := nil ]
]

{ #category : 'class initialization' }
TvDB class >> shutDown: quitting [
	"Our system shutDown hook: stop all servers we manage"

	self default close
]

{ #category : 'class initialization' }
TvDB class >> startUp: resuming [
	"Our system startUp hook"

	"self default ensureLibrary."
	self default open
]
