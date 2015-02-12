Pod::Spec.new do |s|
	s.name					= 'NuweScoreCharts'
	s.version				= '1.0.0'
	s.summary				= 'A dynamic chart library for easily creating the Nuwe Score dial chart and History Bar Chart for iOS.'
	s.homepage				= 'http://www.nuwe.co/'
	s.license				= 'MIT'
	s.screenshots			= ['https://cloud.githubusercontent.com/assets/6021383/5755764/03fa1a40-9cb1-11e4-9266-031d22a09f93.png',
								'https://cloud.githubusercontent.com/assets/6021383/5755757/fb8fa5fa-9cb0-11e4-8c7b-2273adb65c36.png']
	s.authors				= { 'Steve Schofield' => 'stevebschofield@gmail.com', 'Dimitar Plamenov' => 'dimitarplamenov@live.com' ,'Ahmed Ghalab' => '0xcodezero@gmail.com', }
	s.social_media_url		= 'https://twitter.com/r3trosteve'
	s.source				= { :git => 'https://github.com/nuwehq/nuwe-charts-ios.git', :tag => s.version.to_s }
	s.platform				= :ios, '7.0'	
	s.source_files			= 'JSQMessagesViewController/**/*.{h,m}'
	s.resources				= 'JSQMessagesViewController/Assets/JSQMessagesAssets.bundle', 'JSQMessagesViewController/Assets/Strings/*.lproj', 'JSQMessagesViewController/**/*.{xib}',
	s.frameworks			= 'UIKit'
	s.requires_arc			= true
end