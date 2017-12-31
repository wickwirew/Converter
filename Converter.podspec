
Pod::Spec.new do |s|
    s.name         = "Converter"
    s.version      = "0.2.0"
    s.summary      = "An automatic convention based, boiler plate free, object mapper for Swift "
    s.description  = <<-DESC
    Converter is an object mapper similar to AutoMapper for Swift. Converting an object of one type to a different type usually invloves writing a lot of boiler plate code. Converter is an automatic convetion based solution.
    DESC
    s.homepage     = "https://github.com/wickwirew/Converter"
    s.license      = "MIT"
    s.author       = { "Wesley Wickwire" => "wickwirew@gmail.com" }
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/wickwirew/Converter.git", :tag => "0.2.0" }
    s.source_files  = 'Converter/**/*.swift'
    s.dependency 'Runtime', '0.2.0'
end
