# Supabase setup guide – CBS App

This guide walks you through making the CBS Flutter app fully functional with Supabase (auth, database, forum, courses, library).

---

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign in.
2. Click **New project**.
3. Choose an organization, set **Name**, **Database password** (save it), and **Region**.
4. Wait for the project to be ready.

---

## 2. Configure the app with your project

1. In the Supabase Dashboard, open your project.
2. Go to **Project Settings** (gear) → **API**.
3. Copy:
   - **Project URL** (e.g. `https://xxxxx.supabase.co`)
   - **anon public** key (under "Project API keys").

4. In the app, open **`lib/supabase/supabase_config.dart`** and set:

```dart
static const String url = 'YOUR_PROJECT_URL';   // e.g. https://xxxxx.supabase.co
static const String anonKey = 'YOUR_ANON_KEY';
```

5. Do **not** commit the real anon key to public repos. For production, use environment variables or a secure config (e.g. `--dart-define` or `flutter_dotenv`).

---

## 3. Apply the database schema

You need the tables and RLS policies the app expects.

**Option A – New project (recommended)**  
Run the full schema once:

1. In Supabase: **SQL Editor** → **New query**.
2. Open **`supabase/schema.sql`** in your project and copy its full content.
3. Paste into the SQL Editor and click **Run**.

**Option B – Using migrations**  
If you prefer to run migrations in order:

1. Run **`supabase/migrations/001_initial_schema.sql`** in the SQL Editor (copy/paste and Run).
2. Then run **`supabase/migrations/002_four_user_roles.sql`** if your schema still has the old role constraint.

After this you should have:

- **profiles** (id, email, first_name, last_name, role, …) with trigger creating a row on signup  
- **courses**, **lessons**  
- **books** (library)  
- **rooms**, **room_participants**, **messages** (forum/chat)  
- RLS policies on all these tables  

---

## 4. Auth settings (optional but useful)

1. In Dashboard: **Authentication** → **Providers**.
2. **Email**:  
   - Enable "Confirm email" if you want users to verify email before signing in.  
   - If **disabled**, users can sign in immediately after signup (good for testing).
3. Under **URL Configuration** (or **Redirect URLs**), add any deep links / redirect URLs you use (e.g. for email confirmation).

The app already handles:
- Login with email/password  
- Sign up (with optional email confirmation message)  
- Session persistence and logout  

---

## 5. Seed data (so the app has something to show)

The app reads **courses**, **books**, and **rooms** from Supabase. With empty tables, dashboard, library, and forum will be empty. Run the following in the SQL Editor to add sample data (replace `YOUR_USER_ID` with a real `auth.users.id` after you create your first user, or omit `teacher_id`/`created_by` for nullable columns).

**Courses and lessons**

```sql
INSERT INTO public.courses (id, title, description, level, teacher_id) VALUES
  (uuid_generate_v4(), 'Introduction to Biblical Studies', 'Foundations course', 'beginner', NULL),
  (uuid_generate_v4(), 'New Testament Survey', 'Overview of the NT', 'intermediate', NULL);

-- Get a course id from the table, then add lessons (replace COURSE_ID):
-- INSERT INTO public.lessons (course_id, title, description, sort_order) VALUES
--   ('COURSE_ID', 'Lesson 1', 'First lesson', 1);
```

**Books (library)**

```sql
INSERT INTO public.books (title, author, description, language, category) VALUES
  ('Sample Commentary', 'Author Name', 'A short description', 'ENG', 'commentary'),
  ('Concordance Example', 'Another Author', 'Description', 'ENG', 'concordance');
```

**Forum rooms**

```sql
INSERT INTO public.rooms (name, description, created_by) VALUES
  ('General', 'General discussion', NULL),
  ('Questions & Answers', 'Q&A', NULL);
```

After creating a user via the app, you can run `SELECT id FROM auth.users LIMIT 1;` and use that UUID in `teacher_id` or `created_by` if you want.

---

## 6. Storage (for PDFs and book covers)

If your app uses **Storage** for lesson PDFs or book covers:

1. In Dashboard: **Storage** → create a bucket (e.g. `documents`, `covers`).
2. Set **Policies** so that:
   - Authenticated users can **read** (e.g. `SELECT`) objects they’re allowed to see.
   - Only admins/teachers can **upload** if you need that from the app.

In the app, `SupabaseService.fetchPdfData()` should use the same bucket/path as in your `lessons.file_url` or equivalent (e.g. a public URL or signed URL from Storage).

---

## 7. Roles and RLS (quick reference)

- **profiles**: New users get a row via trigger; role defaults to `student`.  
- **student, teacher, visitor, admin**: Stored in `profiles.role`.  
- **courses / lessons**: All authenticated users can read; only `teacher`/`admin` can create/update.  
- **books**: All authenticated can read; only `admin` can insert/update/delete.  
- **rooms**: Authenticated users can read (non-deleted), create, and update their own.  
- **messages**: Authenticated users can read and insert; they can update (e.g. soft-delete) their own.

To set a user as admin/teacher, run in SQL (replace `USER_UUID`):

```sql
UPDATE public.profiles SET role = 'admin' WHERE id = 'USER_UUID';
```

---

## 8. Checklist

- [ ] Supabase project created  
- [ ] `lib/supabase/supabase_config.dart` updated with **Project URL** and **anon** key  
- [ ] `supabase/schema.sql` (or migrations) run in SQL Editor  
- [ ] Auth: Email provider enabled; confirm email on or off as desired  
- [ ] Optional: Seed data for courses, books, rooms  
- [ ] Optional: Storage bucket + policies if using PDFs/covers  
- [ ] Run the app: sign up → sign in → open Dashboard, Library, Forum  

If you see "Failed host lookup" or "No internet", the app is likely still using a wrong or placeholder URL in `supabase_config.dart` or the device has no network access.

---

## 9. Where things live in the app

| Feature        | Supabase           | App code                          |
|----------------|--------------------|-----------------------------------|
| Auth           | Auth (email/pwd)   | `SupabaseService.login/signUp`, `AuthService` |
| Config         | -                  | `lib/supabase/supabase_config.dart` |
| Profiles       | `profiles` table   | Trigger on signup; RLS             |
| Courses/Lessons| `courses`, `lessons` | `SupabaseService` + dashboard/courses pages |
| Library        | `books`            | `SupabaseService` + Library page   |
| Forum          | `rooms`, `messages`| `SupabaseService` + forum_pages, group_chat_page |
| PDFs           | Storage (optional) | `SupabaseService.fetchPdfData`     |

Once the schema is applied and config is set, the app should be fully functional with Supabase.
