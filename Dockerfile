FROM openjdk:jre-alpine
RUN apk add --no-cache bash
COPY backend/app/ /usr/src/myapp/app
# COPY frontend/dist/index.html /usr/src/myapp/app/webapp/
COPY frontend/dist/   /usr/src/myapp/app/webapp/
WORKDIR /usr/src/myapp/app
ENV BASEX_JVM=-Duser.language=en
CMD ["bin/basexhttp"]
