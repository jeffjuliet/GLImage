Pod::Spec.new do |s|
	s.name		= "GLImage"
	s.version 	= "0.0.1"
	s.summary 	= "image sdk for processing with opengles"
	s.homepage 	= "http://blog.sina.com.cn/jefffyangdis"
	s.license 	= "MIT"
	s.authors 	= {'jefffyang'=>'jefffyang@qq.com'}
	s.platform	= :ios,"7.0"
	s.source	= {:git=>"https://github.com/jeffjuliet/GLImage.git",:tag=>"0.0.1"}
	s.source_files	= 'GLImage','GLImage/*/*.h'
	s.requires_arc	= true
end
