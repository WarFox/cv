SRC_DIR =  sources
BUILD_DIR = build
IMAGES_DIR = $(SRC_DIR)/images
DIST_DIR = dist
DATE = $(shell date +'%B %d, %Y')
UTC_DATE_TIME = $(shell date -u +'%B %d, %Y %H:%M:%S UTC')

ifeq "$(wildcard $(SRC_DIR) )" ""
	PARTS_SOURCES=
else
	PARTS_SOURCES = $(shell find $(SRC_DIR) -name '*.md'  -not -name 'cv.md')
endif

PARTS = $(patsubst $(SRC_DIR)/%.md, $(BUILD_DIR)/%.html, $(PARTS_SOURCES))

# before-body contains public or private parts
before-body = --variable=privatecv
ifeq ($(private-cv),true)
	before-body = --variable=privatecv --include-before-body $(BUILD_DIR)/private.html
else
	ifeq ($(public-cv),true)
		before-body = --include-before-body $(BUILD_DIR)/public.html
	endif
endif

# after-body contains all parts but public and private
after-body = $(filter-out $(BUILD_DIR)/public.html $(BUILD_DIR)/private.html, $(PARTS))

# default target is build CV in html
all: html

# Targets for creating working directories
directories: $(BUILD_DIR) $(DIST_DIR)
$(BUILD_DIR):
	mkdir $(BUILD_DIR)
$(DIST_DIR):
	mkdir $(DIST_DIR)

# Target for building stylesheets
style: stylesheets/*.scss
	compass compile \
	  --require susy \
	  --sass-dir stylesheets \
	  --javascripts-dir javascripts \
	  --css-dir $(DIST_DIR)/stylesheets \
	  --image-dir $(IMAGES_DIR) \
	  stylesheets/style.scss

css:
	mkdir -p $(DIST_DIR)/stylesheets && cp -f stylesheets/*.css $(DIST_DIR)/stylesheets

# Target for building CV document in html
html: css templates/cv.html parts $(SRC_DIR)/cv.md | directories
	pandoc --standalone \
	  --section-divs \
	  --smart \
	  --template templates/cv.html \
	  --from markdown+yaml_metadata_block+header_attributes+definition_lists \
	  --to html5 \
	  $(before-body) \
	  $(after-body) \
	  --variable=utc_date_time:'$(UTC_DATE_TIME)' \
	  --css stylesheets/style.css \
	  --output $(DIST_DIR)/index.html $(SRC_DIR)/cv.md

# Target for build CV part in html
parts: $(PARTS)
$(PARTS): $(BUILD_DIR)/%.html: $(SRC_DIR)/%.md | directories
	pandoc \
	--section-divs \
	--from markdown+header_attributes \
	--variable=utc_date_time:'$(UTC_DATE_TIME)' \
	--to html5 -o $@ $<

# Target for cleaning
clean:
	rm -rf $(DIST_DIR)
	rm -rf $(BUILD_DIR)
