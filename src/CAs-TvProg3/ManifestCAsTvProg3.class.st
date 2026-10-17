"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestCAsTvProg3',
	#superclass : 'PackageManifest',
	#category : 'CAs-TvProg3-Manifest',
	#package : 'CAs-TvProg3',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestCAsTvProg3 class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#TvAPI #start #false)) #'2026-10-04T18:51:15.004+02:00') )
]
