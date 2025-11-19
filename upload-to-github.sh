#!/bin/bash

clear
cat << 'EOF'
╔════════════════════════════════════════════════════════════╗
║          🚀 Havoc به GitHub - راهنمای ساده               ║
╚════════════════════════════════════════════════════════════╝

EOF

echo "📝 ابتدا در مرورگر این کارها را انجام دهید:"
echo ""
echo "   1️⃣  به این آدرس بروید:"
echo "       👉 https://github.com/new"
echo ""
echo "   2️⃣  فرم را پر کنید:"
echo "       • Repository name: havoc-server"
echo "       • Private را انتخاب کنید"
echo "       • هیچ گزینه‌ای را تیک نزنید"
echo ""
echo "   3️⃣  دکمه Create repository را بزنید"
echo ""
echo "   4️⃣  آدرسی مثل این می‌بینید:"
echo "       https://github.com/USERNAME/havoc-server.git"
echo "       این آدرس را کپی کنید"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "✅ مخزن را ساختید؟ (y یا enter): " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ] && [ ! -z "$CONFIRM" ]; then
    echo "لطفاً ابتدا مخزن را در GitHub بسازید"
    exit 0
fi

echo ""
read -p "📋 آدرس کامل مخزن را اینجا بچسبانید: " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ آدرس وارد نشد!"
    exit 1
fi

# Extract username and repo name
GITHUB_USER=$(echo $REPO_URL | sed -n 's#.*/\([^/]*\)/[^/]*\.git#\1#p')
REPO_NAME=$(echo $REPO_URL | sed -n 's#.*/\([^/]*\)\.git#\1#p')

echo ""
echo "🔍 اطلاعات شناسایی شده:"
echo "   User: $GITHUB_USER"
echo "   Repo: $REPO_NAME"
echo ""
read -p "✅ درست است؟ (y/n): " CORRECT

if [ "$CORRECT" != "y" ] && [ "$CORRECT" != "Y" ]; then
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 در حال آماده‌سازی فایل‌ها..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /home/ubu2/Havoc

# Configure git if needed
if ! git config user.email > /dev/null 2>&1; then
    echo ""
    echo "⚙️  تنظیمات Git:"
    read -p "نام شما: " GIT_NAME
    read -p "ایمیل شما: " GIT_EMAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
fi

# Remove old .git
if [ -d ".git" ]; then
    echo "🗑️  حذف .git قدیمی..."
    rm -rf .git
fi

echo "📦 ساخت مخزن جدید..."
git init

echo "➕ اضافه کردن فایل‌ها..."
git add .

echo "💾 ایجاد commit..."
git commit -m "Initial Havoc C2 setup for Railway deployment"

echo "🔗 اتصال به GitHub..."
git branch -M main
git remote add origin "$REPO_URL"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📤 در حال آپلود به GitHub..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  ممکن است از شما username و password بخواهد:"
echo "   • Username: $GITHUB_USER"
echo "   • Password: Personal Access Token (نه رمز عبور معمولی!)"
echo ""
echo "🔑 برای ساخت Token:"
echo "   👉 https://github.com/settings/tokens/new"
echo "   • Note: Havoc Upload"
echo "   • Expiration: 30 days"
echo "   • Select: repo (تمام موارد)"
echo "   • Generate token و کپی کنید"
echo ""
read -p "آماده‌اید؟ (enter): " READY

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ موفقیت! فایل‌ها به GitHub آپلود شدند"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎯 مرحله بعدی: Deploy در Railway"
    echo ""
    echo "   1️⃣  به سایت بروید: https://railway.app"
    echo "   2️⃣  کلیک کنید: New Project"
    echo "   3️⃣  انتخاب کنید: Deploy from GitHub repo"
    echo "   4️⃣  مخزن $REPO_NAME را پیدا و انتخاب کنید"
    echo "   5️⃣  منتظر build بمانید (۵-۱۰ دقیقه)"
    echo "   6️⃣  Settings > Networking > Generate Domain"
    echo ""
    echo "🌐 مخزن شما: https://github.com/$GITHUB_USER/$REPO_NAME"
    echo ""
else
    echo ""
    echo "❌ خطا در آپلود!"
    echo ""
    echo "💡 راه‌حل:"
    echo "   1. Token بسازید: https://github.com/settings/tokens/new"
    echo "   2. دوباره تلاش کنید: git push -u origin main"
    echo ""
fi
