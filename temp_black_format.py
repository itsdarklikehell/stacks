FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Zet hier de huidige versie als fallback
ARG SUNVOX_VERSION

RUN apt-get update && apt-get install -y \
    libsdl2-2.0-0 \
    libasound2 \
    libasound2-plugins \
    alsa-utils \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG audio abc

WORKDIR /app

# Gebruik de variabele in de URL
RUN wget https://warmplace.ru/soft/sunvox/sunvox-${SUNVOX_VERSION}.zip && \
    unzip sunvox-${SUNVOX_VERSION}.zip && \
    rm sunvox-${SUNVOX_VERSION}.zip

RUN chmod +x /app/sunvox/sunvox/linux_x86_64/sunvox* && \
    ln -s /app/sunvox/sunvox/linux_x86_64/sunvox /usr/local/bin/sunvox && \
    ln -s /app/sunvox/sunvox/linux_x86_64/sunvox_opengl /usr/local/bin/sunvox_opengl

# Maak de snelkoppeling aan in een systeemmap zodat deze voor 'abc' beschikbaar is
RUN mkdir -p /usr/share/applications && \
    echo "[Desktop Entry]\nType=Application\nName=SunVox\nExec=sunvox\nIcon=audio-vocal\nTerminal=false\nCategories=AudioVideo;AudioEditing;" > /usr/share/applications/sunvox.desktop

# --- AUTORUN SETUP ---
# Kopieer het script naar de custom services map van LinuxServer.io
COPY autostart-sunvox-webtop.sh /custom-services.d/sunvox
RUN chmod +x /custom-services.d/sunvox

# Zorg dat het icoon ook op het bureaublad van de gebruiker verschijnt bij opstarten
RUN mkdir -p /defaults/desktop && \
    cp /usr/share/applications/sunvox.desktop /defaults/desktop/

WORKDIR /config

