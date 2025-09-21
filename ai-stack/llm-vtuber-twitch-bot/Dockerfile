FROM python:3.14.0rc3-slim-trixie
WORKDIR /bot
COPY bot.py .
RUN pip install twitchio websockets
CMD ["python", "bot.py"]
