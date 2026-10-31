Class {
	#name : 'BaselineOfTvProg3',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTvProg3',
	#package : 'BaselineOfTvProg3'
}

{ #category : 'baselines' }
BaselineOfTvProg3 >> baseline: spec [

	<baseline>
	spec for: #common do: [
			self setUpDependencies: spec.

			spec
				package: 'CAs-TvProg3'
				with: [
				spec requires:
					#( 'NeoJSON' 'P3' 'Teapot' 'Tealight' 'NeoConsole' ) ].
			"spec
				package: 'TvProg3-Web'
				with: [ spec requires: #( 'TvProg3-Core' 'Bootstrap5' ) ]."

			spec
				group: 'default' with: 'CAs-TvProg3' ]
			
		"group: 'Web' with: #( 'TvProg3-Web' );"
]

{ #category : 'baselines' }
BaselineOfTvProg3 >> setUpDependencies: spec [

	spec
		baseline: 'NeoJSON' with: [
				spec
					repository: 'github://svenvc/NeoJSON';
					loads: #( 'core' ) ];
		baseline: 'P3' with: [ spec repository: 'github://svenvc/P3' ];
		baseline: 'Teapot' with: [ spec repository: 'github://zeroflag/Teapot/source' ];
		baseline: 'Tealight' with: [ spec repository: 'github://astares/Tealight:main/src' ];
		baseline: 'NeoConsole'
		with: [ spec repository: 'github://svenvc/NeoConsole/src' ];
		baseline: 'Bootstrap5'
		with: [
		spec repository: 'github://astares/Seaside-Bootstrap5:master/src' ]
]
