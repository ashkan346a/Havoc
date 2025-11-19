# Havoc C2 Framework - Railway Deployment

این مخزن نسخه آماده‌ی Havoc C2 Framework برای deploy روی Railway است.

## اطلاعات اتصال پیش‌فرض

- **Host**: آدرس سرور Railway شما
- **Port**: 40056
- **Username**: 5pider
- **Password**: password1234

## نصب و راه‌اندازی

### روش ۱: Deploy خودکار از GitHub

1. این مخزن را fork کنید
2. به [railway.app](https://railway.app) بروید
3. **New Project** > **Deploy from GitHub repo**
4. مخزن خود را انتخاب کنید
5. Railway به صورت خودکار build و deploy می‌کند

### روش ۲: Railway CLI

```bash
railway login
railway init
railway up
```

## تنظیمات امنیتی

برای استفاده در production حتماً:

1. فایل `profiles/havoc.yaotl` را ویرایش کنید
2. رمز عبور را تغییر دهید
3. تنظیمات امنیتی را بررسی کنید

## پورت‌ها

- **40056**: Teamserver (باید در Railway expose شود)

## Client

برای اتصال به سرور:

1. Client را از [releases](https://github.com/HavocFramework/Havoc/releases) دانلود کنید
2. اطلاعات زیر را وارد کنید:
   - Host: دامین یا IP سرور Railway
   - Port: 40056
   - User: 5pider
   - Pass: password1234

## منابع

- [مستندات Havoc](https://havocframework.com/docs)
- [GitHub اصلی Havoc](https://github.com/HavocFramework/Havoc)
