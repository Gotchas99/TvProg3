Class {
	#name : 'TgBot',
	#superclass : 'Object',
	#instVars : [
		'offset',
		'process',
		'token'
	],
	#classVars : [
		'CommandTable',
		'Default'
	],
	#category : 'CAs-TvProg3-Telegram',
	#package : 'CAs-TvProg3',
	#tag : 'Telegram'
}

{ #category : 'accessing' }
TgBot class >> default [ 
	^ Default
		ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
TgBot class >> initialize [ 
	self initializeCommandTable.
	SessionManager default registerUserClassNamed: self name.
	self startDefault .

]

{ #category : 'accessing' }
TgBot class >> initializeCommandTable [ 
	CommandTable := Dictionary new.
	CommandTable at: '/fortune' put: #fortune:.
	CommandTable at: '/help' put: #help:.
]

{ #category : 'accessing' }
TgBot class >> selectorForCommand: aCmd [ 
^CommandTable at: aCmd ifAbsent:[nil].	
]

{ #category : 'accessing' }
TgBot class >> shutDown: quiting [ 
	"Our system shutDown hook: stop all servers we manage"

	(quiting )
		ifTrue: [ self stopDefault  ]
]

{ #category : 'accessing' }
TgBot class >> startDefault [ 
Default:= nil.
	self default start
]

{ #category : 'accessing' }
TgBot class >> startUp: resuming [
	"Our system startUp hook: start all servers we manage.
	We do this using deferred startup actions to allow normal error handling."

	resuming ifTrue: [
			SessionManager default currentSession addDeferredStartupAction: [
				self startDefault ] ]
]

{ #category : 'accessing' }
TgBot class >> stopDefault [ 
self default stop.
]

{ #category : 'accessing' }
TgBot >> apiUrl [

	^ ('https://api.telegram.org/bot' , self token) asZnUrl 
]

{ #category : 'commands' }
TgBot >> fortune: aMsg [ 
	| txt msg |
	txt := ZnClient new
		url: 'https://helloacm.com/api/fortune/';
		headerAt: 'User-Agent' put: 'Gecko';loggingOff;
		get.
	txt := txt allButFirst allButLast: 3.
	txt := txt copyReplaceAll: '\n' with: String crlf.
	txt := txt copyReplaceAll: '\"' with: '"'.
	txt := txt copyReplaceAll: '\t' with: '        '.
	msg := TgMessage new.
	msg text: txt.
	^ msg
]

{ #category : 'request handling' }
TgBot >> getUpdates [ 
	| req u resp |
	req := self request.
	u := self apiUrl / 'getUpdates'.
	u queryAt: #offset put: offset + 1.
	u queryAt: #timeout put: req timeout - 5.
	resp := req
		url: u;
		get.
	(resp at: #ok)
		ifTrue: [ self processResult: (resp at: #result) ]
		ifFalse: [ self traceCr: 'Error in response: ' , resp printString ]
	"	^ resp"
]

{ #category : 'request handling' }
TgBot >> help: aMsg [ 
	| txt msg |
	txt := 'Just nu kan jag bara en sak:
	/fortune
	(och /help ;-) )'.
	msg := TgMessage new.
	msg text: txt.
	^ msg
]

{ #category : 'initialization' }
TgBot >> initialize [ 
offset:=0	
]

{ #category : 'testing' }
TgBot >> isRunning [ 

	"Return true when I am running"

	^ self process notNil
]

{ #category : 'accessing' }
TgBot >> process [ 
	"Return the process that is running my main listening loop.
	Will be nil when I am not running"

	^ process
]

{ #category : 'request handling' }
TgBot >> processMessage: aMsg [ 
	| msg first cmd reply |
	msg := TgMessage fromDict: aMsg.
	first := msg text substrings first.
	cmd := self class selectorForCommand: first.
	cmd
		ifNotNil: [ reply := self perform: cmd with: msg ]
		ifNil: [ reply := TgMessage new text: 'Förstår inte |-(' ].
	reply chatid: msg chatid.
	self sendReply: reply
]

{ #category : 'request handling' }
TgBot >> processResult: aResultList [ 
	aResultList
		do: [ :res | 
			self updateUpdateId: (res at: #update_id).
			[ self processMessage: (res at: #message) ] forkAt: Processor userBackgroundPriority ].
	self traceCr: '-----------------------'
]

{ #category : 'request handling' }
TgBot >> request [ 
	^ ZnClient new
		contentReader: [ :entity | NeoJSONReader fromString: entity contents ];
		numberOfRetries: 3;
		timeout: 60;

			loggingOff
			
				"		logToTranscript"
]

{ #category : 'request handling' }
TgBot >> sendReply: aMsg [ 
	| req u resp |
	req := self request.
	u := self apiUrl / 'sendMessage'.
	aMsg asDict keysAndValuesDo: [ :param :val | u queryAt: param put: val ].
	resp := req
		url: u;
		get.
	(resp at: #ok)
		ifTrue: [ self traceCr: 'Sending ok' ]
		ifFalse: [ self traceCr: 'Error in response: ' , resp printString ]

]

{ #category : 'public' }
TgBot >> start [ 
	"If I am running, I will first stop and thus effectively restart"

	self stop.
	process := [ [ self getUpdates ] repeat ]
		forkAt: Processor userBackgroundPriority
		named: 'TelegramBot'
]

{ #category : 'public' }
TgBot >> stop [ 
	self isRunning
		ifFalse: [ ^ self ].
	process terminate.
	process := nil.
"	self closeDelegate."
]

{ #category : 'public' }
TgBot >> token [ 
	^ token
]

{ #category : 'public' }
TgBot >> updateUpdateId: anId [ 
	(anId>offset)ifTrue: [ offset:=anId  ]
]
