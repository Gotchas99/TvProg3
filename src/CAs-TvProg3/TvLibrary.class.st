Class {
	#name : 'TvLibrary',
	#superclass : 'Object',
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
