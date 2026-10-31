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

{ #category : 'accessing' }
TgMessage >> chatid [ 
	^ (dict at: #chat)at:#id
]

{ #category : 'accessing' }
TgMessage >> chatid: aChatId [ 
	^ dict at: 'chat_id' put: aChatId 
]

{ #category : 'converting' }
TgMessage >> format: aString [ 
	dict at:'parse_mode' put: aString
]

{ #category : 'initialization' }
TgMessage >> fromDict: aMessageDict [ 
	dict := aMessageDict.
	self traceCr: 'aMessage: ', self text
]

{ #category : 'initialization' }
TgMessage >> initialize [ 
	dict:= Dictionary new.
]

{ #category : 'accessing' }
TgMessage >> text [ 
	^ dict at: 'text' ifAbsent:['<tomt>']
]

{ #category : 'accessing' }
TgMessage >> text:aText [ 
	dict at: 'text' put: aText 
]
