include_dir=build
source=chapters/*.md
title='Domain Driven Architecture Book'
filename=README
imageHost=https://github.com/linksgo2011/dda-book/raw/master/

all: html epub rtf pdf mobi

# replace image src, usage:  make chapter=chapter-01-retro chapter
chapter:
	sed 's@]($(chapter)/@]($(imageHost)chapters/$(chapter)/@g' chapters/$(chapter).md > output/$(chapter).md

markdown:
	awk 'FNR==1{print ""}{print}' $(source) > $(filename).md
	sed -i "" 's@](../images@]($(imageHost)images@g' $(filename).md

html: markdown
	pandoc -s $(filename).md -t html5 -o index.html -c style.css \
		--title-prefix $(title) \
		--toc

epub: markdown
	pandoc -s $(filename).md --normalize --smart -t epub -o $(filename).epub \
		--epub-metadata $(include_dir)/metadata.xml \
		--epub-stylesheet epub.css \
		--epub-cover-image img/cover.png \
		--title-prefix $(title) \
		--normalize \
		--smart \
		--toc

rtf: markdown
	pandoc -s $(filename).md -o $(filename).rtf \
		--title-prefix $(title) \
		--normalize \
		--smart

pdf: markdown
	# OS X: http://www.tug.org/mactex/
	# Then find its path: find /usr/ -name "pdflatex"
	# Then symlink it: ln -s /path/to/pdflatex /usr/local/bin
	pandoc -s $(filename).md -o $(filename).pdf \
		--title-prefix $(title) \
		--listings -H listings-setup.tex \
		--template=template/template.tex \
		--normalize \
		--smart \
		--toc \
		--latex-engine=`which xelatex`

mobi: epub
	# Symlink bin: ln -s /path/to/kindlegen /usr/local/bin
	kindlegen $(filename).epub
