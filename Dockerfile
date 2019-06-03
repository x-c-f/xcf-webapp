FROM openjdk:8-jre-alpine
RUN apk add --no-cache bash
COPY backend/app/ /usr/src/myapp/app
COPY frontend/dist/index.html /usr/src/myapp/app/webapp/
COPY frontend/dist/assets /usr/src/myapp/app/webapp/assets
WORKDIR /usr/src/myapp/app
ENV BASEX_JVM=-Duser.language=en
CMD ["bin/basexhttp"]
