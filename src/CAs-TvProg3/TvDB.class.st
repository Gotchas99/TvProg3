Class {
	#name : 'TvDB',
	#superclass : 'Object',
	#instVars : [
		'db',
		'conn',
		'writeQ',
		'writeProcess'
	],
	#classVars : [
		'Default'
	],
	#category : 'CAs-TvProg3-DB',
	#package : 'CAs-TvProg3',
	#tag : 'DB'
}

{ #category : 'accessing' }
TvDB class >> default [
^Default ifNil:[Default:= self new].
]

{ #category : 'class initialization' }
TvDB class >> initialize [

	SessionManager default registerUserClassNamed: self name
	"SessionManager default unregisterClassNamed:#TuDB.
	SessionManager default currentSession runList: SessionManager default  startupList.
	SessionManager default startupList.
	"
]

{ #category : 'accessing' }
TvDB class >> reset [
Default ifNotNil:[self default close.
	Default := nil]
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

{ #category : 'connection handling' }
TvDB >> close [
writeQ ifNotNil:[writeQ flush.writeQ :=nil].
			db ifNotNil: [
		writeProcess terminate.
		db close.
		"self traceCr: 'db closed'."
		db := nil ]
]

{ #category : 'schema-util' }
TvDB >> colExists: colName inTable: tableName [

	| tbl |
	tbl := db tables detect: [ :t | t name = tableName ].
	^tbl columnNames includes: colName
]

{ #category : 'accessing' }
TvDB >> conn [ ^conn
]

{ #category : 'schema' }
TvDB >> createContent [
	self deprecated: 'Tu'.
	(self tableExists: #content) ifTrue: [ ^ self ].
	conn execute: 'create table content(
		id TEXT PRIMARY KEY
		, post_id INTEGER
		, type TEXT
		, disp_order INTEGER DEFAULT (999)
	 )'
]

{ #category : 'schema' }
TvDB >> createMedia [
	self deprecated: 'Tu'.
	(self tableExists: #media) ifTrue: [ ^ self ].
	conn execute: 'create table media(
		id TEXT PRIMARY KEY
		, content_id TEXT
		, type TEXT
		, path TEXT
		, width INTEGER
		, height INTEGER
		, cropped BOOLEAN
		, origDimension BOOLEAN
	 )'
]

{ #category : 'schema' }
TvDB >> createPosts [
	self deprecated: 'Tu'.
	(self tableExists: #posts) ifTrue: [ ^ self ].
	conn execute: 'create table posts(
		id INTEGER PRIMARY KEY
		, blog_id TEXT
		, tags TEXT
	 )'
]

{ #category : 'accessing' }
TvDB >> db [

	^ db
]

{ #category : 'accessing' }
TvDB >> dbFilename [
self deprecated: 'no file'
	"^ TuLibrary default basePath / 'TuDatabase.db'"
]

{ #category : 'schema' }
TvDB >> dropContent [
	self deprecated: 'Tu'.
	self halt.
	(self tableExists: #content) ifFalse: [ ^ self ].
	conn execute: 'DROP TABLE content'
]

{ #category : 'schema' }
TvDB >> dropPosts [
	self deprecated: 'Tu'.
	self halt.
	(self tableExists: #posts) ifFalse: [ ^ self ].
	conn execute: 'DROP TABLE posts'
]

{ #category : 'schema-util' }
TvDB >> ensureColumn: colName type: colType default: defValue inTable: tblName [

	(self colExists: colName inTable: tblName) ifTrue: [ ^ self ].
				self flag:#todo.
	db execute:
		'ALTER TABLE ' , tblName , ' ADD COLUMN ' , colName , ' ' , colType
		, ' DEFAULT (' , defValue , ')'
]

{ #category : 'schema-util' }
TvDB >> ensureColumn: colName type: colType inTable: tblName [

	self
		ensureColumn: colName
		type: colType
		default: 'NULL' 
		inTable: tblName
]

{ #category : 'initialization' }
TvDB >> ensureLibrary [

	| fromName toName dll |self deprecated: 'no sqlite'.
	dll := 'sqlite3.dll'.
	toName := Smalltalk imageDirectory asFileReference / dll.
	toName exists ifTrue: [ ^ self ].
	fromName := Smalltalk imageDirectory asFileReference / 'pharo-local'
	            / 'iceberg' / 'pharo-rdbms' / 'Pharo-SQLite3' / 'bin'
	            / 'windows' / '64bit' / dll.
	fromName copyTo: toName
]

{ #category : 'operations' }
TvDB >> getWrite [

	| msg |
	msg := writeQ next.
	self traceCr: 'get, writeQ: ' , writeQ size asString.
	msg sendTo: self.
	^ Processor yield
]

{ #category : 'initialization' }
TvDB >> initialize [


]

{ #category : 'connection handling' }
TvDB >> open [

	db ifNotNil: [ db connection isOpen ifTrue: [ ^ self ] ].
	writeQ := AtomicSharedQueue new.
	self flag: #todo.
	"	db := SQLite3Database openOn: self dbFilename pathString."
	"conn := db connection".
	writeProcess := [
		                [ self getWrite ] repeat.
		                self traceCr: 'writeProcess died' ]
		                forkAt: 33
		                named: #dbWriter
	"self traceCr: 'db opened'"
]

{ #category : 'testing' }
TvDB >> postExists: aPostId [

	| sql tmp |
	self deprecated: 'Tu'.
	sql := 'select count(0) from posts where id=' , aPostId asString.
	db execute: sql doing: [ :cursor | tmp := cursor onlyValue = 1 ].
	^ tmp
]

{ #category : 'operations' }
TvDB >> queueWrite: aMsg [

	writeQ nextPut: aMsg.
	"self traceCr: 'add, writeQ: ' , writeQ size asString."
	Processor yield
]

{ #category : 'schema' }
TvDB >> setupContent [
	self deprecated: 'Tu'.
	self createContent
]

{ #category : 'schema' }
TvDB >> setupMedia [
	self deprecated: 'Tu'.
	self createMedia
]

{ #category : 'schema' }
TvDB >> setupPosts [
	self deprecated: 'Tu'.
	self createPosts.
	self ensureColumn: #tags type: #TEXT inTable: #posts.
	self
		ensureColumn: #hidden
		type: #INTEGER
		default: 'FALSE'
		inTable: #posts
]

{ #category : 'schema' }
TvDB >> setupSchema [
	self deprecated: 'Tu'.
	self setupPosts.
	self setupContent.
	self setupMedia
]

{ #category : 'testing' }
TvDB >> tableExists: tableName [

	^ db tables anySatisfy: [ :t | t name = tableName ] 
]

{ #category : 'accessing' }
TvDB >> tables [

	^ db tables 
]

{ #category : 'operations' }
TvDB >> writeContent: aContent [

	| sql |
	sql := 'INSERT INTO content
			(id, post_id, type, disp_order) VALUES (:id, :post_id, :type, :disp_order)
		ON CONFLICT (id) DO
		UPDATE SET 
			post_id=excluded.post_id, type=excluded.type, disp_order=excluded.disp_order;'.
			self flag:#todo.
	db connection execute: sql with: aContent
]

{ #category : 'operations' }
TvDB >> writePost: aPostData [

	| sql |
	sql := 'INSERT INTO posts(id, blog_id, tags) VALUES (:id, :blog_id, :tags)
		ON CONFLICT (id) DO
		UPDATE SET blog_id=excluded.blog_id, tags=excluded.tags;'.			self flag:#todo.
	db connection execute: sql with: aPostData
]
