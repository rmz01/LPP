# frozen_string_literal: true

require_relative "lib/triaje/version"

Gem::Specification.new do |spec|
  spec.name = "triaje"
  spec.version = Triaje::VERSION
  spec.authors = ["rmz01"]
  spec.email = ["alu0101438238@ull.edu.es"]

  spec.summary = "Gema para la gestión del triaje en servicios sanitarios"
  spec.description = "Una gema que proporciona clases, constantes y métodos para organizar y priorizar pacientes en servicios de urgencias mediante el triaje, un proceso de clasificación según niveles de gravedad. Implementa el Sistema Español de Triaje (SET) con cinco niveles de atención prioritaria basados en el tiempo de espera."
  spec.homepage = "https://github.com/ULL-ESIT-LPP-2425/07-poo-aaron-ramirez-valencia-alu0101438238"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ULL-ESIT-LPP-2425/07-poo-aaron-ramirez-valencia-alu0101438238"
  spec.metadata["changelog_uri"] = "https://github.com/ULL-ESIT-LPP-2425/07-poo-aaron-ramirez-valencia-alu0101438238"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "yard"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
