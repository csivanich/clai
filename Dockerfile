FROM alpine as base
RUN apk add bash pv curl jq && mkdir ~/.cache
COPY persona/ persona/
COPY models/ models/
COPY post/ post/
COPY clai clai
COPY endpoints.sh endpoints.sh
ENTRYPOINT ["./clai"]
