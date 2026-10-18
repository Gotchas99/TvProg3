Class {
	#name : 'TgMessage',
	#superclass : 'Object',
	#instVars : [
		'dict'
	],
	#category : 'CAs-TvProg3-Telegram',
	#package : 'CAs-TvProg3',
	#tag : 'Telegram'
}

{ #category : 'instance creation' }
TgMessage class >> fromDict: aMessageDict [ 
	^self new fromDict: aMessageDict 
]

{ #category : 'converting' }
TgMessage >> asDict [ 
^	dict 
]

{ #category : 'converting' }
TgMessage >> chatid [ 
	^ (dict at: #chat)at:#id
]

{ #category : 'converting' }
TgMessage >> chatid: aChatId [ 
	^ dict at: 'chat_id' put: aChatId 
]

{ #category : 'converting' }
TgMessage >> format: aString [ 
	dict at:'parse_mode' put: aString
]

{ #category : 'converting' }
TgMessage >> fromDict: aMessageDict [ 
	dict := aMessageDict.
	self traceCr: 'aMessage: ', self text
]

{ #category : 'converting' }
TgMessage >> initialize [ 
	dict:= Dictionary new.
]

{ #category : 'converting' }
TgMessage >> text [ 
	^ dict at: 'text' ifAbsent:['<tomt>']
]

{ #category : 'converting' }
TgMessage >> text:aText [ 
	dict at: 'text' put: aText 
]
