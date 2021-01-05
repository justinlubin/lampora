all:
	elm make src/Main.elm --output=out/main.js && \
	cp -a static/. out # Source: https://askubuntu.com/a/86891

fast:
	elm make src/Main.elm --output=out/main.js --optimize && \
	cp -a static/. out # Source: https://askubuntu.com/a/86891

publish:
	make fast; git checkout gh-pages; ./copy.sh; \
		git add -A; git commit -m "Pull updates from 'main'"; git push; \
		git checkout master

# https://discourse.elm-lang.org/t/counting-lines-of-code-loc/1459
loc:
	find src/ -type f -name '*.elm' | xargs cat | wc -l
