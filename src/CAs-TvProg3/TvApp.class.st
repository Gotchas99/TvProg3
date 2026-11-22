Class {
	#name : 'TvApp',
	#superclass : 'SBSRootComponent',
	#category : 'CAs-TvProg3-Web',
	#package : 'CAs-TvProg3',
	#tag : 'Web'
}

{ #category : 'accessing' }
TvApp class >> contextRoot [

	^ 'tvprog3'
]

{ #category : 'accessing' }
TvApp class >> initialize [

	self register
]

{ #category : 'accessing' }
TvApp class >> register [

	| app |
	app := super register.
	"app addLibrary: SBSExamplesLibrary"
]

{ #category : 'hooks' }
TvApp >> children [

	^ #()
]

{ #category : 'hooks' }
TvApp >> initialize [

	super initialize.
]

{ #category : 'hooks' }
TvApp >> renderContentOn: html [
	"self renderNavigationbarOn: html.
	self isDisplayingIntro
		ifTrue: [ self renderIntroOn: html ]
		ifFalse: [ browser renderOn: html ]"

	html container: [html jumbotron: [html heading:'TvProgram #3']]
]

{ #category : 'hooks' }
TvApp >> updateRoot: htmlRoot [

	super updateRoot: htmlRoot.
	htmlRoot title: 'TvProgram-3' 
]
