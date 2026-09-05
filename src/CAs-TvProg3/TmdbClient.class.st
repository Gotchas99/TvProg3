Class {
	#name : 'TmdbClient',
	#superclass : 'Object',
	#classVars : [
		'ApiKey',
		'Token'
	],
	#category : 'CAs-TvProg3-API',
	#package : 'CAs-TvProg3',
	#tag : 'API'
}

{ #category : 'accessing' }
TmdbClient class >> token [

	^ Token 
]

{ #category : 'accessing' }
TmdbClient class >> token:aToken [

 Token :=aToken 
]

{ #category : 'private' }
TmdbClient >> client [

	| zn |
	zn := ZnClient new setBearerAuthentication:self class token;
	url: 'https://api.themoviedb.org/3/';forJsonREST.
	^zn
]

{ #category : 'as yet unclassified' }
TmdbClient >> find_by_id: anImdbId [
	"curl --request GET \
     --url 'https://api.themoviedb.org/3/find/external_id?external_source=imdb_id&language=en-US'"

	| cl tv movies res all |
	cl := self client
		      addPath: #find;
		      addPath: anImdbId asString.
	cl queryAt: 'external_source' put: 'imdb_id'.
	cl get.
	res := cl contents.
	tv := (res at: #tv_results) collect: [ :show |
			      TvProgram new
				      type: #tv;
				      tmdbId: (show at: #id) ].
	movies := (res at: #movie_results) collect: [ :show |
			          TvProgram new
				          type: #movie;
				          tmdbId: (show at: #id) ].
			all:=tv,movies.
			all do:[:p|p retrieveTmdb ;retrieveOmdb ].
	^ all
]

{ #category : 'as yet unclassified' }
TmdbClient >> movie_details: tmdbId [

		| cl |
	cl := self client
		      addPath: #tv;
		      addPath: tmdbId asString.
	cl get.
	^ cl contents
]

{ #category : 'as yet unclassified' }
TmdbClient >> movie_external_ids: aTmdbId [

	| cl |
self flag:'behövs troligen inte. imdb finns i details'.
	cl := self client
		      addPath: #movie;
		      addPath: aTmdbId asString.
	cl get.
	^ cl contents
]

{ #category : 'as yet unclassified' }
TmdbClient >> tv_details: series_id [

	| cl |
	cl := self client
		      addPath: #tv;
		      addPath: series_id asString.
	cl get.
	^ cl contents
]

{ #category : 'as yet unclassified' }
TmdbClient >> tv_details_old: series_id [
	"ideas for more fields: genres (list),seasons (with episode count)) "

	| raw flds dict |
	raw := self tv_details_raw: series_id.
	flds := { #id. #name. #tagline. #overview. #status. #vote_average.
	        #number_of_seasons. #number_of_episodes }.
	dict := Dictionary new.
	flds do: [ :fld | dict at: fld put: (raw at: fld) ].
	dict
		at: #poster_thumbnail
		put: 'https://image.tmdb.org/t/p/w92' , (raw at: #poster_path).
	^ dict
]

{ #category : 'as yet unclassified' }
TmdbClient >> tv_external_ids: aTmdbId [

	| cl |
	cl := self client
		      addPath: #tv;
		      addPath: aTmdbId asString;
		addPath:#external_ids.
	cl get.
	^ cl contents
]

{ #category : 'as yet unclassified' }
TmdbClient >> unavailable_providers [

	^ #( 'Amazon Prime Video' 'Viaplay' )
]

{ #category : 'as yet unclassified' }
TmdbClient >> watch_providers: aTmdbId [

	| cl countries swedish providers names |
	cl := self client
		      addPath: #tv;
		      addPath: aTmdbId asString;
		      addPath: 'watch/providers'.
	cl get.
	countries := cl contents at: #results.
	swedish := countries at: #SE.
	providers := swedish at: #flatrate.
	names := providers collect: [ :p | p at: #provider_name ].
	^ names  \ self unavailable_providers 
]
