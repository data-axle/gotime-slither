# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gotime-slither}
  s.version = "2.0.0.pre"

  s.authors = ["Ryan Wood"]
  s.description = %q{A simple, clean DSL for describing, writing, and parsing fixed-width text files.}
  s.email = %q{ryan.wood@gmail.com}
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test}/*`.split("\n")
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ryanwood/slither}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.summary = %q{A simple, clean DSL for describing, writing, and parsing fixed-width text files}
end
