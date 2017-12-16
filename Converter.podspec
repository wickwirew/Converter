
Pod::Spec.new do |s|
    s.name         = "Converter"
    s.version      = "0.1.0"
    s.summary      = "An automatic convention based, boiler plate free, object mapper for Swift "
    s.description  = <<-DESC
    An automatic convention based, boiler plate free, object mapper for Swift 
    DESC
    s.homepage     = "https://github.com/wickwirew/Converter"
    s.license      = "MIT"
    s.author       = { "Wesley Wickwire" => "wickwirew@gmail.com" }
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/wickwirew/Converter.git", :tag => "0.1.0" }
    s.source_files  = 'Converter/**/*.swift'
end
