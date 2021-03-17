require_relative 'lib/fairy_chores/version'

Gem::Specification.new do |spec|
  spec.name          = "fairy_chores"
  spec.version       = FairyChores::VERSION
  spec.authors       = ["Noah Gibbs"]
  spec.email         = ["the.codefolio.guy@gmail.com"]

  spec.summary       = %q{A silly attempt at a hidden-role game AI.}
  spec.description   = %q{A circle of fairies frolicks. But unknown to them, fairies in their midst will try to assign them to chore duty. They must prevent it! A silly attempt at hidden-role game AI.}
  spec.homepage      = "https://github.com/noahgibbs/fairy_chores"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/noahgibbs/fairy_chores"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "andor", "~>0.1.0"
end
