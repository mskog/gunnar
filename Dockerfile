FROM ruby:2.2.0-onbuild
CMD ["bundle", "exec", "ruby", "gunnar.rb"]
