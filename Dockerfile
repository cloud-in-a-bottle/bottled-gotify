FROM gotify/server

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

ENTRYPOINT []
CMD ["/app/start.sh"]
