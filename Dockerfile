FROM ubuntu:24.04

# Broadway

ENV GDK_BACKEND='broadway'
ENV BROADWAY_DISPLAY=':5'
ENV DARK_MODE='false'
ENV GTK_THEME='Materia'
ENV BG_GRADIENT="#ddd, #999"

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends libgtk-3-0 libgtk-3-bin nginx gettext-base tmux wget materia-gtk-theme papirus-icon-theme
apt-get clean
apt-get autoclean
rm -rf /var/lib/apt/lists/*

rm -rf /usr/share/themes/Materia && mv /usr/share/themes/Materia-light /usr/share/themes/Materia

wget --no-check-certificate -O /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)"
chmod +x /usr/bin/ttyd
EOF

COPY --chmod=755 start.sh /usr/local/bin/start
COPY nginx.tmpl /etc/nginx/nginx.tmpl
COPY terminal-outline.svg /www/data/images/terminal-outline.svg

EXPOSE 80

# Virt-manager

ENV FAVICON_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV APP_TITLE='Virtual Machine Manager'
ENV CORNER_IMAGE_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV HOSTS="[]"

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends virt-manager dbus-x11 libglib2.0-bin gir1.2-spiceclientgtk-3.0 ssh at-spi2-core
apt-get clean
apt-get autoclean
rm -rf /var/lib/apt/lists/*

mkdir -p /root/.ssh
echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
EOF

COPY --chmod=755 startapp.sh /usr/local/bin/startapp

CMD ["/usr/local/bin/startapp"]
