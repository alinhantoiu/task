FROM golang:alpine3.20

ENV APP_HOME=/app 
ENV APP_USER=app 
ENV APP_GROUP=app

RUN mkdir $APP_HOME 

RUN addgroup -g 101 -S $APP_GROUP && adduser -u 100 -S $APP_USER -G $APP_GROUP

COPY go.mod main.go stress_test.sh /app/

WORKDIR /app

RUN go build -o app .

RUN chown -R $APP_USER:$APP_GROUP $APP_HOME

USER $APP_USER

EXPOSE 8080

CMD ["./app"]
