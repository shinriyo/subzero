Pod::Spec.new do |s|
  s.name             = 'subzero'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for dynamic model manipulation using reflection.'
  s.description      = <<-DESC
A Flutter plugin for dynamic model manipulation using reflection.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'shinriyo' => 'shinriyo@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'  # ここでClassesディレクトリ内のファイルを指定
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.swift_version = '5.0'
end
