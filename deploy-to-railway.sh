#!/bin/bash

echo "🚀 Havoc Railway Deployment Script"
echo ""
read -p "آدرس IP یا دامین سرور Railway: " RAILWAY_SERVER
read -p "یوزرنیم SSH (پیش‌فرض: root): " SSH_USER
SSH_USER=${SSH_USER:-root}

echo ""
echo "📦 در حال آپلود Havoc به سرور..."
scp -r /home/ubu2/Havoc ${SSH_USER}@${RAILWAY_SERVER}:/tmp/

echo ""
echo "🔧 در حال نصب و راه‌اندازی روی سرور..."
ssh ${SSH_USER}@${RAILWAY_SERVER} << 'ENDSSH'
cd /tmp/Havoc
echo "✓ نصب وابستگی‌ها..."
apt update && apt install -y nasm wget > /dev/null 2>&1

echo "✓ دانلود mingw..."
./teamserver/Install.sh

echo "✓ راه‌اندازی Teamserver..."
nohup ./havoc server --profile profiles/havoc.yaotl -v > havoc.log 2>&1 &

sleep 3
if pgrep -f "havoc server" > /dev/null; then
    echo "✅ Teamserver با موفقیت راه‌اندازی شد!"
    echo ""
    echo "📋 اطلاعات اتصال:"
    echo "   Host: $(hostname -I | awk '{print $1}')"
    echo "   Port: 40056"
    echo "   User: 5pider"
    echo "   Pass: password1234"
else
    echo "❌ خطا در راه‌اندازی! لاگ:"
    tail -20 havoc.log
fi
ENDSSH

echo ""
echo "✅ عملیات تکمیل شد!"
