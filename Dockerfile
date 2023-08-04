FROM alpine
RUN apk add bash pv curl jq && mkdir ~/.cache
COPY persona/ persona/
COPY chat.sh chat.sh
COPY endpoints.sh endpoints.sh
ENTRYPOINT ["./chat.sh"]
