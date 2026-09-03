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
				package: 'Teapot-Core' with: [ spec requires: #( 'NeoJSON' ) ];
				package: 'Teapot-Tools' with: [ spec requires: 'Teapot-Core' ];
				package: 'Teapot-Tests' with: [ spec requires: 'Teapot-Core' ].

			spec for: (self pharoVersionsFrom: 10) do: [
					spec
						package: 'Teapot-Tests'
						with: [ spec requires: #( 'Zinc-Zodiac' ) ] ].

			spec
				group: 'Tests' with: #( 'Teapot-Tests' );
				group: 'Tools' with: #( 'Teapot-Tools' );
				group: 'Deployment' with: #( 'Teapot-Core' );
				group: 'Development' with: #( 'Tests' 'Tools' );
				group: 'default' with: 'Development' ]
]

{ #category : 'baselines' }
BaselineOfTvProg3 >> pharoVersionsFrom: aVersion [
	"Method copied from BaselineOf to allow use of Pharo versions < 11"

	^ (aVersion to: SystemVersion current major) collect: [ :v |
		  ('pharo' , v asString , '.x') asSymbol ]
]

{ #category : 'baselines' }
BaselineOfTvProg3 >> setUpDependencies: spec [

	spec
		baseline: 'NeoJSON' with: [
				spec
					repository: 'github://svenvc/NeoJSON';
					loads: #( 'core' ) ];
		baseline: 'ZincHTTPComponents'
		with: [ spec repository: 'github://svenvc/zinc' ];
	
		baseline: 'NeoConsole'
		with: [ spec repository: 'github://svenvc/NeoConsole/src' ]
		
		"project: 'Zinc-Zodiac'
		copyFrom: 'ZincHTTPComponents'
		with: [ spec loads: 'Zinc-Zodiac-Core' ];"
]
