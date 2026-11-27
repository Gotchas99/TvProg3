"deps.st"

Iceberg remoteTypeSelector: #httpsUrl.

Metacello new
        baseline: 'TvProg3';
        repository: 'github://Gotchas99/TvProg3:main/src';
        load: #( 'deps' ).

Smalltalk garbageCollect.
