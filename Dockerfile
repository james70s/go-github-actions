FROM golang:alpine as builder
# ENV GOPROXY=https://goproxy.cn,direct 
# RUN git clone ${APP_GIT_URI}
WORKDIR ${GOPATH}/src/eb
COPY . .

RUN go get -d && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

#------------------------------------------------------------------------
# FROM golang:alpine as product
# Scratch镜像，简洁、小巧，基本是个空镜像
FROM scratch as product
# ENV GOPROXY=https://goproxy.cn,direct 

ENV APP_PATH=/go/src/eb \
    VERSION=0.2

WORKDIR ${APP_PATH}

COPY --from=builder ${APP_PATH}/main .

ENTRYPOINT ["./main"]
CMD ["-r"]

