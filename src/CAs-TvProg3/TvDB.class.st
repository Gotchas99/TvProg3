Class {
	#name : 'TvDB',
	#superclass : 'Object',
	#instVars : [
		'db',
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
 
	quitting ifTrue: [ self default close ]
]

{ #category : 'class initialization' }
TvDB class >> startUp: resuming [
	"Our system startUp hook"

	"self default ensureLibrary."

	resuming ifTrue: [ 
			self reset.
			self default open ]
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

{ #category : 'connection handling' }
TvDB >> connectionString [

	| dbName |
	dbName := TvLibrary default isTestEnv 
		          ifTrue: [ 'tvprog3_test' ]
		          ifFalse: [ 'tvprog3' ].
	^ 'psql://tvprog3:hokuspokus@ux8/' , dbName
]

{ #category : 'schema' }
TvDB >> createContent [

	| conn |
	self deprecated: 'Tu'.self halt.
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

	| conn |
	self deprecated: 'Tu'.self halt.
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

	| conn |
	self deprecated: 'Tu'.self halt.
	(self tableExists: #posts) ifTrue: [ ^ self ].
	conn execute: 'create table posts(
		id INTEGER PRIMARY KEY
		, blog_id TEXT
		, tags TEXT
	 )'
]

{ #category : 'schema' }
TvDB >> createProgram [

(self tableExists: #program) ifTrue: [ ^ self ].
	db execute: 'create table program(
		tmdb_id INTEGER PRIMARY KEY
		, imdb_id TEXT
		, name TEXT
		, type TEXT
		, interest TEXT
		, view_status TEXT
		, watch_providers TEXT
		, tmdb_json TEXT
		, tmdb_json_seasons TEXT
		, omdb_json TEXT
	 )'
]

{ #category : 'accessing' }
TvDB >> db [

	^ db
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
	db := P3Client new.
	db url: self connectionString.
	db connect.
	writeQ := AtomicSharedQueue new.
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
TvDB >> setupProgram [

	self flag: #todo.
	self createProgram.
"	self ensureColumn: #tags type: #TEXT inTable: #posts.
	self
		ensureColumn: #hidden
		type: #INTEGER
		default: 'FALSE'
		inTable: #posts"
]

{ #category : 'schema' }
TvDB >> setupSchema [
self flag:#todo.
self setupProgram .
	"self setupPosts.
	self setupContent.
	self setupMedia"
]

{ #category : 'schema' }
TvDB >> setupSeason [

	self flag: #todo.
	"self createPosts.
	self ensureColumn: #tags type: #TEXT inTable: #posts.
	self
		ensureColumn: #hidden
		type: #INTEGER
		default: 'FALSE'
		inTable: #posts"
]

{ #category : 'schema' }
TvDB >> setupSystem [

	self flag: #todo.
	"self ensureColumn: #tags type: #TEXT inTable: #posts.
	self
		ensureColumn: #hidden
		type: #INTEGER
		default: 'FALSE'
		inTable: #posts"
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
	self flag: #todo.
	db  execute: sql with: aContent
]

{ #category : 'operations' }
TvDB >> writePost: aPostData [

	| sql |
	sql := 'INSERT INTO posts(id, blog_id, tags) VALUES (:id, :blog_id, :tags)
		ON CONFLICT (id) DO
		UPDATE SET blog_id=excluded.blog_id, tags=excluded.tags;'.
	self flag: #todo.
	db  execute: sql with: aPostData
]

{ #category : 'operations' }
TvDB >> writeProgram: aProgramDict [

	| statement sql fields insert placeHolders values doUpdate |
	self flag: #todo.
	fields := ',' join:aProgramDict keys.
	insert :='INSERT INTO program (',fields ,')' .
	placeHolders:=
	',' join: ((1 to:aProgramDict size ) collect:[:i|'$', i asString]).
	values:= 'VALUES (',placeHolders,') '.
	doUpdate:=
	', ' join: (
	aProgramDict keys allButFirst collect:[:fld|fld ,'= EXCLUDED.',fld]
	)
	.
	sql := insert, 
		values,
		' ON CONFLICT(tmdb_id)
		DO UPDATE SET '
		,doUpdate .
"	statement := db prepare: sql.
	statement execute: { 1. 'foo'. 75.5. true }.
	statement close
"	"INSERT INTO inventory (id, name, price, quantity)
VALUES (1, 'A', 16.99, 120)
ON CONFLICT(id)
DO UPDATE SET
  price = EXCLUDED.price,
  quantity = EXCLUDED.quantity;"
]
