Pod::Spec.new do |s|
	s.name		= "GLImage"
	s.version 	= "0.0.3"
	s.summary 	= "image sdk for processing with opengles"
	s.homepage 	= "http://blog.sina.com.cn/jefffyangdis"
	s.license 	= "MIT"
	s.authors 	= {'jefffyang'=>'jefffyang@qq.com'}
	s.platform	= :ios,"7.0"
	s.source	= {:git=>"https://github.com/jeffjuliet/GLImage.git",:tag=>"#{s.version}"}
	s.source_files	= 'GLImage/**/*.{h,m}'
	s.ios.frameworks= ['OpenGLES','CoreMedia']
	s.requires_arc	= true
	
	s.public_header_files = 'GLImage/**/*.h'
	s.header_mappings_dir = 'include'
end
