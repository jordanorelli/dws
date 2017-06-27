bundle:
	go build -o dws
	rm -rf dws.app
	mkdir -p dws.app/Contents/MacOS
	cp dws dws.app/Contents/MacOS
	cp Info.plist dws.app/Contents

