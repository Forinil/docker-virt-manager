FROM ubuntu:24.04

# Broadway

ENV GDK_BACKEND='broadway'
ENV BROADWAY_DISPLAY=':5'
ENV DARK_MODE='false'
ENV GTK_THEME='Materia'
ENV BG_GRADIENT="#ddd, #999"

RUN apt-get update
RUN apt-get install -y --no-install-recommends libgtk-3-0 libgtk-3-bin nginx gettext-base tmux wget materia-gtk-theme papirus-icon-theme
RUN apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/share/themes/Materia && mv /usr/share/themes/Materia-light /usr/share/themes/Materia

RUN wget --no-check-certificate -O /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)"
RUN chmod +x /usr/bin/ttyd

COPY start.sh /usr/local/bin/start
COPY nginx.tmpl /etc/nginx/nginx.tmpl
COPY terminal-outline.svg /www/data/images/terminal-outline.svg
EXPOSE 80

ENV FAVICON_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV APP_TITLE='Virtual Machine Manager'
ENV CORNER_IMAGE_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV HOSTS="[]"

# Virt-manager

RUN apt-get update
RUN apt-get install -y --no-install-recommends virt-manager dbus-x11 libglib2.0-bin gir1.2-spiceclientgtk-3.0 ssh at-spi2-core
RUN apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY startapp.sh /usr/local/bin/startapp

CMD ["/usr/local/bin/startapp"]
