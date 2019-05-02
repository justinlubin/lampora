all:
	elm make src/Main.elm --output=out/main.js --optimize && \
	cp -a src/raw/. out # Source: https://askubuntu.com/a/86891
