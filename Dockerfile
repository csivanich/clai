FROM alpine
RUN apk add bash pv curl jq && mkdir ~/.cache
COPY persona/ persona/
COPY clai clai
COPY endpoints.sh endpoints.sh
ENTRYPOINT ["./clai"]
