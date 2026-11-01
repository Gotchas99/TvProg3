Class {
	#name : 'TvConsoleServer',
	#superclass : 'NeoConsoleTelnetServer',
	#category : 'CAs-TvProg3-Core',
	#package : 'CAs-TvProg3',
	#tag : 'Core'
}

{ #category : 'private' }
TvConsoleServer >> initializeServerSocket [

	serverSocket := Socket newTCP.
	serverSocket setOption: 'TCP_NODELAY' value: 1.
	serverSocket 
		listenOn: self port
		backlogSize: 10
		interface: #[ 0 0 0 0 ].
	serverSocket isValid ifFalse: [
		self error: 'Cannot create socket on port ' , self port printString ]
]
