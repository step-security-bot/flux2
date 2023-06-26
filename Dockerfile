FROM alpine:3.18@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 as builder

RUN apk add --no-cache ca-certificates curl

ARG ARCH=linux/amd64
ARG KUBECTL_VER=1.27.2

RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/${ARCH}/kubectl \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && \
    kubectl version --client=true

FROM alpine:3.18@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 as flux-cli

RUN apk add --no-cache ca-certificates

COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/
COPY --chmod=755 flux /usr/local/bin/

USER 65534:65534
ENTRYPOINT [ "flux" ]
