SRC_DIR=sources
DIST_DIR=dist
UTC_DATE_TIME=$(shell date -u +'%B %d, %Y %H:%M:%S UTC')

# default target is build CV in html
all: html

# Targets for creating working directories
directories: $(DIST_DIR)
$(DIST_DIR):
	mkdir $(DIST_DIR)

css:
	mkdir -p $(DIST_DIR)/stylesheets && cp -f stylesheets/*.css $(DIST_DIR)/stylesheets

# Target for building CV document in html
html: css templates/cv.html $(SRC_DIR)/cv.md | directories
	pandoc --standalone \
	  --section-divs \
	  --smart \
	  --template templates/cv.html \
	  --from markdown+yaml_metadata_block+header_attributes+definition_lists \
	  --to html5 \
	  --variable=utc_date_time:'$(UTC_DATE_TIME)' \
	  --css stylesheets/style.css \
	  --output $(DIST_DIR)/index.html \
		$(SRC_DIR)/cv.md

# Target for building docx
docx:
	pandoc --standalone \
    --output doc.docx \
    $(SRC_DIR)/cv.md

# Target for cleaning
clean:
	rm -rf $(DIST_DIR)
