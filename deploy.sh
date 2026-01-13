#!/bin/bash

VPS_USER="admin"
VPS_HOST="ch1andr"
REMOTE_PATH="/var/www/mysite/html"  # ← Изменили путь!

echo "🚀 Деплой в /var/www/mysite/html/"

# Создаем backup
BACKUP_DIR="/tmp/site_backups"
ssh $VPS_USER@$VPS_HOST "mkdir -p $BACKUP_DIR"
ssh $VPS_USER@$VPS_HOST "tar -czf $BACKUP_DIR/site_$(date +%Y%m%d_%H%M%S).tar.gz -C $REMOTE_PATH ."

# Синхронизируем файлы
rsync -avz --progress \
  -e ssh \
  --delete \
  --exclude='.git' \
  --exclude='.github' \
  --exclude='deploy.sh' \
  --exclude='*.backup' \
  --exclude='.env*' \
  ./ $VPS_USER@$VPS_HOST:$REMOTE_PATH/

if [ $? -eq 0 ]; then
    echo "✅ Деплой завершен!"
    echo "📁 Файлы на сервере:"
    ssh $VPS_USER@$VPS_HOST "ls -la $REMOTE_PATH/"
else
    echo "❌ Ошибка!"
    exit 1
fi