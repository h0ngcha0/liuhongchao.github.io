RUBY_IMAGE := ruby:3.3.4-bookworm
BUNDLE_VOLUME := hongchao-jekyll-bundle
DOCKER_RUN := docker run --rm \
	-v "$(CURDIR):/site" \
	-v "$(BUNDLE_VOLUME):/usr/local/bundle" \
	-w /site

.PHONY: build serve

build:
	$(DOCKER_RUN) $(RUBY_IMAGE) sh -c 'bundle install && bundle exec jekyll build'

serve:
	$(DOCKER_RUN) -p 4000:4000 $(RUBY_IMAGE) sh -c 'bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000'
