all:
	elm make src/Main.elm --output=out/main.js && \
	cp -a static/. out # Source: https://askubuntu.com/a/86891
