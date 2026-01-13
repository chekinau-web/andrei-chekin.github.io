#!/bin/bash

VPS_USER="admin"
VPS_HOST="46.32.185.14"
VPS_PORT="22022"
REMOTE_PATH="/var/www/mysite/html"


echo "Проверка подключения..."
if ! ssh -p $VPS_PORT -o ConnectTimeout=5 $VPS_USER@$VPS_HOST "true"; then
    echo "❌ Ошибка подключения к серверу"
    exit 1
fi

echo "🚀 Деплой на $VPS_HOST:$VPS_PORT"

# Копируем все файлы
scp -P $VPS_PORT ./*.html $VPS_USER@$VPS_HOST:$REMOTE_PATH/ 2>/dev/null
scp -P $VPS_PORT ./*.css $VPS_USER@$VPS_HOST:$REMOTE_PATH/ 2>/dev/null  
scp -P $VPS_PORT ./*.js $VPS_USER@$VPS_HOST:$REMOTE_PATH/ 2>/dev/null

# Копируем папки если есть
[ -d "css" ] && scp -P $VPS_PORT -r css/ $VPS_USER@$VPS_HOST:$REMOTE_PATH/
[ -d "js" ] && scp -P $VPS_PORT -r js/ $VPS_USER@$VPS_HOST:$REMOTE_PATH/
[ -d "images" ] && scp -P $VPS_PORT -r images/ $VPS_USER@$VPS_HOST:$REMOTE_PATH/

echo "✅ Файлы скопированы!"
echo "✅ Деплой завершен!"
echo "🌐 Сайт: http://$VPS_HOST/"