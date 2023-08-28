FROM alpine as base
RUN apk add python3 bash pv curl jq && mkdir ~/.cache
COPY persona/ persona/
COPY models/ models/
COPY post/ post/
COPY clai endpoints.sh ./handle_stream.py ./record.py .
ENTRYPOINT ["./clai"]
