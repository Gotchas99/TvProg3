"build.st"

Iceberg remoteTypeSelector: #httpsUrl.

(IceRepository registry select: [ :r | r name = 'TvProg3' ]) do:
        [ :r |
        r location ifNotNil: [ :dir | dir ensureDeleteAll ].
        r forget ].

Stdio stdout
        nextPutAll: '>>> before build: P3=' , (Smalltalk globals hasClassNamed: #P3Client) printString ,
                ' Teapot=' , (Smalltalk globals hasClassNamed: #Teapot) printString;
        lf; flush.

Metacello new
        baseline: 'TvProg3';
        repository: 'github://Gotchas99/TvProg3:main/src';
        onConflictUseIncoming;
        load.
!

TmdbClient token: (Smalltalk os environment at: 'TMDB_API_TOKEN').
OmdbClient apiKey: (Smalltalk os environment at: 'OMDB_API_KEY').
!

Smalltalk garbageCollect.
!

"Metacello new
  repository: 'github://svenvc/zinc/repository';
  baseline: 'ZincHTTPComponents';
  onConflict: [ :e | e useIncoming ];
  onUpgrade: [ :e | e useIncoming ];
  onWarning: [ :e | e load ];
  load: #('default' 'WebSocket').
"
