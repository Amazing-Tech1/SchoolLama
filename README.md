# SchoolLama

SchoolLama is a role-based school management dashboard built with Next.js, React, TypeScript, PostgreSQL, and Prisma ORM. Clerk provides sign-in and role-based access; Cloudinary handles profile photo uploads.

## Features

- Separate dashboards for administrators, teachers, students, and parents.
- Management views for teachers, students, parents, classes, subjects, and lessons.
- Exam, assignment, result, event, announcement, and attendance views.
- Search, pagination, role-aware data filtering, and create/update forms where implemented.
- Weekly schedules, event calendars, attendance summaries, and dashboard charts.

## Requirements

- Node.js 20.9 or newer.
- pnpm.
- PostgreSQL 15 or newer.
- Clerk development application keys.
- Cloudinary account and upload preset for profile photo uploads.

## Setup

1. Install dependencies:

   ```bash
   pnpm install
   ```

2. Create `.env` from the example:

   ```bash
   cp .env.example .env
   ```

   On PowerShell, use `Copy-Item .env.example .env`.

3. Configure these values in `.env`:

   ```env
   DATABASE_URL="postgresql://USER:PASSWORD@localhost:5432/DATABASE"
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY="your-clerk-publishable-key"
   CLERK_SECRET_KEY="your-clerk-secret-key"
   NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME="your-cloud-name"
   NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET="your-unsigned-upload-preset"
   ```

   Keep real credentials out of source control. The Cloudinary upload preset must allow the client-side uploads used by the profile forms.

4. Emit the Prisma contract, initialize a new database, and optionally load development data:

   ```bash
   pnpm contract:emit
   pnpm exec prisma db init
   pnpm exec tsx src/prisma/seed.ts
   ```

   **Warning:** the seed script deletes existing rows from the application tables before inserting its sample data. Run it only against a disposable development database. It seeds PostgreSQL records; it does not create Clerk sign-in accounts.

5. Start the development server:

   ```bash
   pnpm dev
   ```

   Open [http://localhost:3000](http://localhost:3000).

## Database

The Prisma contract is in `src/prisma/contract.prisma`; generated contract artifacts are in `src/prisma/`. Prisma CLI configuration is in `prisma.config.ts`, and migration packages are in `migrations/`.

After changing the contract, emit its generated artifacts:

```bash
pnpm contract:emit
```

Check or apply the on-disk migration history for an existing database:

```bash
pnpm exec prisma migration status
pnpm exec prisma db migrate
```

Use `prisma db init` for a new database that needs its tables created from the current contract. Use migrations when evolving a database that already has migration history.

## Docker Deployment

Copy `.env.example` to `.env` and set a strong, URL-safe `POSTGRES_PASSWORD`, Clerk keys, and Cloudinary values. For example, generate a URL-safe password with `openssl rand -hex 32`. `NEXT_PUBLIC_*` values are included in the browser bundle at image-build time, so rebuild the app image after changing them.

Start the database, apply the checked-in migrations, and start the app:

```bash
docker compose up -d postgres
docker compose --profile tools run --rm migrate
docker compose up --build -d app
```

The app is available at [http://localhost:3000](http://localhost:3000). Compose publishes its PostgreSQL service on `127.0.0.1:5433` to avoid colliding with an existing local database on port 5432. The app connects to `postgres:5432` over Compose's private network. The database uses a named volume and is not exposed publicly; back it up before replacing or removing that volume.

## Roles and Routes

Dashboard access is based on the Clerk user's `publicMetadata.role`. Supported roles are `admin`, `teacher`, `student`, and `parent`.

| Route                 | Purpose                            |
| --------------------- | ---------------------------------- |
| `/admin`              | Administrative overview and charts |
| `/teacher`            | Teacher schedule and announcements |
| `/student`            | Student schedule and announcements |
| `/parent`             | Parent dashboard                   |
| `/list/teachers`      | Teacher directory                  |
| `/list/students`      | Student directory                  |
| `/list/parents`       | Parent directory                   |
| `/list/classes`       | Classes                            |
| `/list/subjects`      | Subjects                           |
| `/list/lessons`       | Lessons                            |
| `/list/exams`         | Exams                              |
| `/list/assignments`   | Assignments                        |
| `/list/results`       | Results                            |
| `/list/events`        | Events                             |
| `/list/announcements` | Announcements                      |

## Scripts

| Command              | Description                          |
| -------------------- | ------------------------------------ |
| `pnpm dev`           | Start the development server         |
| `pnpm build`         | Create a production build            |
| `pnpm start`         | Serve the production build           |
| `pnpm contract:emit` | Regenerate Prisma contract artifacts |
