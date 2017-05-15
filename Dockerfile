FROM ruby:2.4.1-onbuild

CMD ["bundle", "exec", "./run.rb"]
