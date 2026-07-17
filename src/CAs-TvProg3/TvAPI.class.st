Class {
	#name : 'TvAPI',
	#superclass : 'Object',
	#instVars : [
		'teapot'
	],
	#classVars : [
		'AlwaysRestart',
		'Default'
	],
	#category : 'CAs-TvProg3-API',
	#package : 'CAs-TvProg3',
	#tag : 'API'
}

{ #category : 'accessing' }
TvAPI class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
TvAPI class >> initialize [

	AlwaysRestart := true.
	SessionManager default registerUserClassNamed: self name
]

{ #category : 'accessing' }
TvAPI class >> restartDefault [

	<script>
	self stopDefault.
	^ self startDefault
]

{ #category : 'accessing' }
TvAPI class >> shutDown: quitting [
	"Our system shutDown hook: stop all servers we manage"

	(quitting or: [ AlwaysRestart ]) ifTrue: [ self stopDefault ]
]

{ #category : 'accessing' }
TvAPI class >> startDefault [
<script>
	^ self default start
]

{ #category : 'accessing' }
TvAPI class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	(resuming or: [ AlwaysRestart ]) ifTrue: [
		SessionManager default currentSession addDeferredStartupAction: [
			self startDefault ] ]
]

{ #category : 'accessing' }
TvAPI class >> stopDefault [
<script>
	Default ifNotNil: [
		Default stop.
		Default := nil ]
]

{ #category : 'as yet unclassified' }
TvAPI >> cors: req [

	| resp |
	resp := TeaResponse code: 204.
	resp headerName: 'Access-Control-Allow-Origin' value: '*'.
	resp
		headerName: 'Access-Control-Allow-Methods'
		value: 'POST, GET, OPTIONS, PUT'.
	resp headerName: 'Access-Control-Allow-Headers' value: 'content-type'.
	self traceCr: 'options'.
	^ resp
]

{ #category : 'as yet unclassified' }
TvAPI >> showNames [
| res tmp3 tmp2 dict raw |
raw := Dictionary new.
raw at:#names put: #(#house #bigBang #wire).
res := OrderedCollection new.
	"tmp3 := tmp2 asBag sortedElements do: [ :assoc |
		        dict := Dictionary new.
		        dict at: #tag put: assoc key.
		        dict at: #count put: assoc value.
		        res add: dict ].
"
	^ raw
]

{ #category : 'as yet unclassified' }
TvAPI >> start [

	teapot := Teapot configure: {
			          (#defaultOutput -> #json).
			          (#debugMode -> true) }.
	teapot
		after: '*' -> [ :req :resp |
				resp headers at: 'Access-Control-Allow-Origin' put: '*' ];
		OPTIONS: '*' -> [ :req | self cors: req ];
		GET: '/' -> 'asd';
		GET: '/shows' ->  [ :req | self showNames ]
		"serveStatic: '/statics' from: TuLibrary default postPath;
		GET: '/tags' -> [ :req | TuLibrary default tags ];
		GET: '/posts' -> [ :req |
				TuLibrary default
					postsHaving: (req at: #having)
					butNot: (req at: #not) ];
		GET: '/post' -> [ :req | TuLibrary default postDict: (req at: #id) ];
		GET:
			'/inspect' -> [ :req | TuLibrary default inspect: (req at: #id) ];
		PUT: '/post'
			-> [ :req | TuLibrary default updatePost: (req at: #id) with: req ];
		PUT: '/content' -> [ :req |
				TuLibrary default
					updateContentInPost: (req at: #post_id)
					id: (req at: #id)
					with: req ]."
	"before:
			'*' -> [ :req | self traceCr: 'Teapot: ' , req uri asString ];"
	.teapot start
]

{ #category : 'accessing' }
TvAPI >> stop [

	teapot ifNotNil: [
		teapot stop.
		teapot := nil ]
]
