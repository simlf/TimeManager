FROM node:18

COPY . /web_app
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

WORKDIR /web_app

EXPOSE 5173

CMD ["/entrypoint.sh"]