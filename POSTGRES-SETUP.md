# استفاده از PostgreSQL با Havoc Teamserver

این راهنما نحوه اتصال Havoc Teamserver به دیتابیس PostgreSQL را (به ویژه برای استقرار در Railway) توضیح می‌دهد.

## تغییرات اعمال شده

### 1. پشتیبانی از PostgreSQL
- کد دیتابیس برای پشتیبانی از PostgreSQL و SQLite به‌روزرسانی شد
- درایور `github.com/lib/pq` اضافه شد
- **پشتیبانی خودکار از Environment Variables** برای Railway و Docker

### 2. الویت بارگذاری Database
Teamserver به ترتیب زیر دیتابیس را انتخاب می‌کند:
1. **Environment Variables** (برای Railway, Docker, Kubernetes)
2. **Profile Configuration** (از فایل .yaotl)
3. **SQLite** (پیش‌فرض)

## استفاده در Railway

### روش 1: استفاده از Environment Variables (توصیه می‌شود)

Railway این متغیرها را به صورت خودکار تزریق می‌کند:

```bash
PGHOST=postgres-nfwo.railway.internal
PGPORT=5432  # اختیاری - پیش‌فرض 5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=zPeMsQPPrejxBPBUlGGqhpyYrgqTegnr
PGDATABASE=railway
PGSSLMODE=disable  # اختیاری - پیش‌فرض disable
```

**هیچ تغییری در profile لازم نیست!** Teamserver به صورت خودکار این متغیرها را تشخیص می‌دهد.

### روش 2: استفاده از Profile Configuration

اگر می‌خواهید از فایل profile استفاده کنید، Database block را uncomment کنید:

```toml
Database {
    Type = "postgres"
    Host = "postgres-nfwo.railway.internal"
    Port = 5432
    User = "postgres"
    Password = "your_password_here"
    Name = "railway"
    SSLMode = "disable"
}
```

**نکته:** Yaotl parser از environment variables در فایل profile پشتیبانی نمی‌کند، پس باید مقادیر را hardcode کنید.

## استفاده Local

### SQLite (پیش‌فرض)
برای استفاده از SQLite، بلاک Database را از profile حذف کنید یا کامنت کنید:

```toml
# Database {
#     Type = "sqlite"
# }
```

### PostgreSQL محلی
برای اتصال به PostgreSQL محلی:

```toml
Database {
    Type = "postgres"
    Host = "localhost"
    Port = 5432
    User = "havoc"
    Password = "your_password"
    Name = "havoc_db"
    SSLMode = "disable"
}
```

## اجرا

### با Profile پیش‌فرض
```bash
./havoc server --profile profiles/havoc.yaotl
```

### با Profile Railway
```bash
./havoc server --profile profiles/railway-postgres.yaotl
```

## بررسی اتصال

هنگام اجرا، teamserver یکی از این پیام‌ها را نمایش می‌دهد:

**PostgreSQL:**
```
✓ Connected to existing Postgres database: railway
✓ Created new Postgres database schema: railway
```

**SQLite:**
```
✓ Opens existing database: data/teamserver.db
✓ Creates new database: data/teamserver.db
```

## مزایای PostgreSQL

1. **پایداری بالاتر**: داده‌ها در دیتابیس مرکزی ذخیره می‌شوند
2. **مقیاس‌پذیری**: امکان افزایش منابع به صورت مستقل
3. **Backup**: امکان backup خودکار توسط Railway
4. **Multi-instance**: امکان اجرای چند نمونه teamserver با یک دیتابیس مشترک

## نکات مهم

- برای Railway، `SSLMode = "disable"` کافی است (شبکه داخلی امن است)
- برای اتصالات خارجی، `SSLMode = "require"` استفاده کنید
- متغیرهای محیطی به صورت خودکار در زمان اجرا جایگزین می‌شوند
- جداول به صورت خودکار ساخته می‌شوند (migration خودکار)

## عیب‌یابی

### خطای اتصال به دیتابیس
بررسی کنید که:
1. سرویس PostgreSQL در Railway فعال است
2. متغیرهای محیطی صحیح هستند
3. شبکه داخلی Railway فعال است

### خطای ایجاد جدول
اگر جداول ایجاد نشدند:
```sql
-- اتصال به PostgreSQL و اجرای دستی:
\c railway
DROP TABLE IF EXISTS "TS_Listeners";
DROP TABLE IF EXISTS "TS_Agents";
DROP TABLE IF EXISTS "TS_Links";
```

سپس teamserver را مجدد راه‌اندازی کنید.

## پشتیبانی

برای مشکلات و سوالات:
- [Havoc Framework GitHub](https://github.com/HavocFramework/Havoc)
- [Railway Documentation](https://docs.railway.app/)
