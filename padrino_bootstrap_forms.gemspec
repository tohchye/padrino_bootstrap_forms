Gem::Specification.new do |s|
  s.name        = "padrino_bootstrap_forms"
  s.version     = "0.1.1"
  s.authors     = ["Seth Vargo", "Skye Shaw"]
  s.email	= "skye.shaw@gmail.com"
  s.homepage    = "https://github.com/sshaw/padrino_bootstrap_forms"
  s.summary     = "Padrino Bootstrap Forms makes Twitter's Bootstrap on Padrino easy!"
  s.description = <<-DESC
        Padrino Bootstrap Forms is a port of Seth Vargo's Bootstrap Forms for Rails.
        It makes Twitter's Bootstrap on Padrino easy to use by creating helpful form builders that minimize markup in your views.
	Currently supports Bootstrap 2.
  DESC
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.license       = "MIT"
  # Will only work with 0.11, 0.12 >= 12.6 and 0.13 >= 0.13.2
  s.add_dependency "padrino", "~> 0.11", "!= 0.12.0", "!= 0.12.1", "!= 0.12.2", "!= 0.12.3", "!= 0.12.4", "!= 0.12.5", "!= 0.13.0", "!= 0.13.1"
  s.add_dependency "activesupport", "~> 3.1", "< 5"
  s.add_development_dependency "rake"
  s.add_development_dependency "slim"
  s.add_development_dependency "erubis"
  s.add_development_dependency "haml", "~> 4.0"
  s.add_development_dependency "rack-test", "~> 0.6.1"
  s.add_development_dependency "rspec", "~> 2.9"
  s.add_development_dependency "test_xml", "~> 0.1.7"
end
