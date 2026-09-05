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

{ #category : 'class initialization' }
TvAPI class >> initialize [

	AlwaysRestart := true.
	SessionManager default registerUserClassNamed: self name
]

{ #category : 'services' }
TvAPI class >> restartDefault [

	<script>
	self stopDefault.
	^ self startDefault
]

{ #category : 'startup - shutdown' }
TvAPI class >> shutDown: quitting [
	"Our system shutDown hook: stop all servers we manage"

	(quitting or: [ AlwaysRestart ]) ifTrue: [ self stopDefault ]
]

{ #category : 'services' }
TvAPI class >> startDefault [
<script>
	^ self default start
]

{ #category : 'startup - shutdown' }
TvAPI class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	(resuming or: [ AlwaysRestart ]) ifTrue: [
		SessionManager default currentSession addDeferredStartupAction: [
			self startDefault ] ]
]

{ #category : 'services' }
TvAPI class >> stopAll [
	<script>
	Teapot stopAll 
]

{ #category : 'services' }
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

	| res showIDs programs |
	res := Dictionary new.
	res at: #status put: 'ok'.
	showIDs := { 1408. 5920. 63174 }.
	programs := showIDs collect: [ :id | TmdbClient new tv_details: id ].
	TvLibrary default allPrograms.
	res at: #programs put: programs.
	^ res
]

{ #category : 'as yet unclassified' }
TvAPI >> showNamesSamples [

	| res dict  |
	res := Dictionary new.
	res at: #status put: #ok.	dict := Dictionary new.
	dict := NeoJSONReader fromString: self showNamesSamplesJSON.
	res at: #programs put: dict.
	^ res
]

{ #category : 'as yet unclassified' }
TvAPI >> showNamesSamplesJSON [

	^ ' [
    {
      "id": 1408,
      "imdb_id": "tt0412142",
      "name": "House",
      "tagline": "Everybody lies.",
      "status": "Ended",
      "number_of_episodes": 176,
      "number_of_seasons": 8,
      "overview":
        "Dr. Gregory House, a drug-addicted, unconventional, misanthropic medical genius, leads a team of diagnosticians at the fictional Princeton–Plainsboro Teaching Hospital in New Jersey.",
      "vote_average": 8.566,
      "poster_thumbnail":
        "https://image.tmdb.org/t/p/w92/3Cz7ySOQJmqiuTdrc6CY0r65yDI.jpg",
      "title_type": "Show"
    },
    {
      "id": 5920,
      "imdb_id": "tt1196946",
      "name": "The Mentalist",
      "tagline": "Let the mind games begin.",
      "overview":
        "Patrick Jane, a former celebrity psychic medium, uses his razor sharp skills of observation and expertise at \reading\" people to solve serious crimes with the California Bureau of Investigation.",
      "status": "Ended",
      "number_of_episodes": 151,
      "number_of_seasons": 7,
      "vote_average": 8.4,
      "poster_thumbnail":
        "https://image.tmdb.org/t/p/w92/acYXu4KaDj1NIkMgObnhe4C4a0T.jpg",
      "title_type": "Show"
    },
    {
      "id": 63174,
      "imdb_id": "03",
      "name": "Lucifer",
      "tagline": "It''s good to be bad.",
      "overview":
        "Bored and unhappy as the Lord of Hell, Lucifer Morningstar abandoned his throne and retired to Los Angeles, where he has teamed up with LAPD detective Chloe Decker to take down criminals. But the longer he''s away from the underworld, the greater the threat that the worst of humanity could escape.",
      "status": "Ended",
      "number_of_episodes": 93,
      "number_of_seasons": 6,
      "vote_average": 8.43,
      "poster_thumbnail":
        "https://image.tmdb.org/t/p/w92/ekZobS8isE6mA53RAiGDG93hBxL.jpg",
      "title_type": "Show"
    }
  ]'
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

{ #category : 'as yet unclassified' }
TvAPI >> status [

	| raw |
	raw := 'Up and running'.
	^ raw
]

{ #category : 'accessing' }
TvAPI >> stop [

	teapot ifNotNil: [
		teapot stop.
		teapot := nil ]
]
