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
└── rules
    ├── constraints.xml
    ├── rules_compiled.xslt
    └── rules_config.xml
```

For more information on what these files do, please refer to: 

In short: 



* `rules_compiled.xslt` contains a transformation that performs the actual checking
* `constraints.xml` contains detailed information for a given error, that will be added to the report
* `reportview.xsl` is used to convert a report a more user friendly format
* `rules_config.xml` can be used to configure which checkboxes in the web-fronted are initially checked

### Development

For development start `webpack-dev-server`:

```bash
cd frontend && npm install && npm run build
```

alongside the `basexhttp`-backend:

```bash
cd backend/app && bin/basexhttp
````

The frontend will be served at [localhost:8080](http://localhost:8080) and requests to the BaseX HTTP backend will be proxied automatically by webpack.

### To Build from Source and run in production

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
