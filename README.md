# XCF: Web Application

This is both the front- and backend for the XCF-Web-Application.

## Related repositories

The actual XCF itself is contained in the [`xcf` Git repository](https://github.com/IRT-Open-Source/xcf) and
provides necessary helper files.



## Running the application

### First time run

To run the application you can either use the provided `config.default.xml` or create your own config file `config.xml`. You can copy the default config and take it as base for your customized configuration:

```bash
cp backend/app/config.default.xml backend/app/config.xml
```

or on Windows OS:

```bat
copy backend\app\config.default.xml backend\app\config.xml
```

> **By default:** `config.default.xml` is used and no further steps are required.

### About the config file

Applications can be run from arbitrary URLs, local installations are possible.
Just point the engine and rules to a local folder. Please use absolute paths or even better
`file://`-URLs.

```xml
<config>
  <xcf-engine>https://subtitling.irt.de/xcf_sample/engine/</xcf-engine>
  <xcf-rules>https://subtitling.irt.de/xcf_sample/rules/</xcf-rules>
</config>
```

Make sure your `engine` & `rules`-folders contain at least the following files:

```bash
├── engine
│   └── reportview.xsl
└── rules
    ├── constraints.xml
    ├── rules_compiled.xsl
    └── rules_config.xml
```

For more information on what these files do, please refer to: 

In short: 

* `rules_compiled.xsl` contains a transformation that performs the actual checking
* `constraints.xml` contains detailed information for a given error, that will be added to the report
* `reportview.xsl` is used to convert a report a more user friendly format
* `rules_config.xml` can be used to configure which checkboxes in the web-fronted are initially checked

### Development

For development start `webpack-dev-server`:

```bash
cd frontend && npm -s install && npm run dev
```

alongside the `basexhttp`-backend:

```bash
cd backend/app && bin/basexhttp
````

On Windows OS:

```bat
cd backend\app && bin\basexhttp
```

The frontend will be served at [localhost:8080](http://localhost:8080) and requests to the BaseX HTTP backend will be proxied automatically by webpack.


### To Build from Source and run in production

```bash
# Build the frontend
cd frontend && npm -s install && npm run build && cd ..
cp frontend/dist/index.html backend/app/webapp/
cp -r frontend/dist/assets backend/app/webapp/
# Start basexhttp
cd backend/app && bin/basexhttp
```
Or on Windows OS:

```bat
cd frontend && npm -s install && npm run build && cd ..
copy frontend\dist\index.html backend\app\webapp\
xcopy frontend\dist\assets backend\app\webapp\
cd backend\app && bin\basexhttp
```

### To build a docker container

```bash
# Build the frontend
cd frontend && npm -s install && npm run build && cd ..
docker build -t xcf-check . && docker run -p 80:8984 xcf-check
```

## License


The web frontend is offered by [BaseX GmbH](https://www.basex.org) and licensed under the [MIT license](LICENSE).
