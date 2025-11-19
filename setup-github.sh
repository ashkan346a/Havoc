#!/bin/bash

echo "🚀 Havoc GitHub Setup Script"
echo ""

# Get GitHub username
read -p "اسم کاربری GitHub شما: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ اسم کاربری وارد نشد!"
    exit 1
fi

# Get repo name
read -p "نام مخزن (پیش‌فرض: havoc-server): " REPO_NAME
REPO_NAME=${REPO_NAME:-havoc-server}

echo ""
echo "📋 خلاصه:"
echo "   GitHub User: $GITHUB_USER"
echo "   Repository: $REPO_NAME"
echo "   URL: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
read -p "ادامه می‌دهیم? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "لغو شد"
    exit 0
fi

echo ""
echo "⚠️  توجه: ابتدا باید مخزن را در GitHub ایجاد کنید:"
echo "   👉 https://github.com/new"
echo "   - Repository name: $REPO_NAME"
echo "   - Private را انتخاب کنید"
echo "   - ✅ بدون README, .gitignore, license"
echo ""
read -p "مخزن را ساختید? (y/n): " CREATED

if [ "$CREATED" != "y" ]; then
    echo "لطفاً ابتدا مخزن را بسازید"
    exit 0
fi

echo ""
echo "🔧 در حال تنظیم Git..."

# Remove old .git if exists
if [ -d ".git" ]; then
    echo "حذف .git قدیمی..."
    rm -rf .git
fi

# Initialize new repo
git init
git add .
git commit -m "Initial Havoc C2 setup for Railway deployment"

# Add remote and push
git branch -M main
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

echo ""
echo "📤 در حال push به GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ موفقیت! Havoc به GitHub آپلود شد"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎯 مرحله بعدی: Deploy در Railway"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. به https://railway.app بروید"
    echo "2. New Project > Deploy from GitHub repo"
    echo "3. مخزن $REPO_NAME را انتخاب کنید"
    echo "4. منتظر بمانید تا build تمام شود"
    echo "5. از Settings > Networking پورت 40056 را expose کنید"
    echo ""
    echo "مخزن شما: https://github.com/$GITHUB_USER/$REPO_NAME"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "❌ خطا در push"
    echo "ممکن است نیاز به تنظیم credentials باشد:"
    echo ""
    echo "git config --global user.name \"Your Name\""
    echo "git config --global user.email \"your@email.com\""
    echo ""
    echo "یا از Personal Access Token استفاده کنید:"
    echo "https://github.com/settings/tokens"
fi
