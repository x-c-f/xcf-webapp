# XCF: Web Application

This is both the front- and backend for the XCF-Web-Application.

## Running the application

### First time run
To run the application you have to create a config file or rename our predefined config-file located in the `backend`-folder.

```bash
cp backend/config.default.xml backend/config.xml
```

### About the config file

Applications can be run from arbitrary URLs, local installations are possible.
Just point the engine and rules to a local folder. Please use absolute paths or even better
`file://`-URLs.

```xml
<!-- *TODO* replace with real IRT URLs -->
<config>
  <xcf-engine>http://files.basex.org/.xcf-application/engine/</xcf-engine>
  <xcf-rules>http://files.basex.org/.xcf-application/checks/</xcf-rules>
</config>
```

Make sure your `engine` & `rules`-folders contain at least the following files:

```bash
.xcf-application
├── engine
│   └── reportview.xsl
└── subtitles
    ├── constraints.xml
    ├── irt_functions.xsl
    └── rules_compiled.xslt
```

* Erklären was die Dateien machen (subcheck_custom <> docs/artifacts)
*

### To Build from Source and Run

```bash
# Build the frontend
cd frontend && npm install && npm run build && cd ..
cp frontend/dist/index.html backend/app/webapp/
cp -r frontend/dist/assets backend/app/webapp/
# Start basexhttp
cd backend/app && bin/basexhttp
```

### To build a docker container

```bash
# Build the frontend
cd frontend && npm install && npm run build && cd ..
docker build -t xcf-check . && docker run -p 80:8984 xcf-check
```

### To run:

    docker login git.basex.io:4567
    # use your gitlab credentials
    …
    docker run git.basex.io:4567/ms/subcheck-project -p80:8984
    # then open http://docker-host
