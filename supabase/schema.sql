-- =============================================================================
-- Center for Biblical Studies - Supabase Schema
-- Run this entire file in Supabase Dashboard: SQL Editor > New query > Paste > Run
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- PROFILES (extends auth.users)
-- User types: student, teacher, visitor, admin
-- -----------------------------------------------------------------------------
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  first_name TEXT,
  last_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'student' CHECK (role IN ('student', 'teacher', 'visitor', 'admin')),
  bio TEXT,
  online_status BOOLEAN DEFAULT false,
  last_seen TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, first_name, last_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'first_name', NEW.raw_user_meta_data->>'name', ''),
    NEW.raw_user_meta_data->>'last_name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- COURSES & LESSONS
-- -----------------------------------------------------------------------------
CREATE TABLE public.courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  teacher_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  description TEXT,
  level TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER courses_updated_at
  BEFORE UPDATE ON public.courses
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.lessons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- BOOKS (library)
-- -----------------------------------------------------------------------------
DO $$ BEGIN
  CREATE TYPE public.book_category AS ENUM ('bible', 'commentary', 'dictionnaire', 'concordance', 'other');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

CREATE TABLE public.books (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  author TEXT,
  book_url TEXT,
  category public.book_category DEFAULT 'other',
  book_cover_url TEXT,
  description TEXT,
  language TEXT DEFAULT 'ENG',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- ROOMS (forum groups / chat rooms)
-- -----------------------------------------------------------------------------
CREATE TABLE public.rooms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  is_private BOOLEAN DEFAULT false,
  is_deleted BOOLEAN DEFAULT false,
  deleted_at TIMESTAMPTZ,
  deleted_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER rooms_updated_at
  BEFORE UPDATE ON public.rooms
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.room_participants (
  room_id UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (room_id, user_id)
);

-- -----------------------------------------------------------------------------
-- MESSAGES
-- -----------------------------------------------------------------------------
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  room_id UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text',
  is_deleted BOOLEAN DEFAULT false,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_courses_teacher_id ON public.courses(teacher_id);
CREATE INDEX idx_lessons_course_id ON public.lessons(course_id);
CREATE INDEX idx_books_category ON public.books(category);
CREATE INDEX idx_rooms_created_by ON public.rooms(created_by);
CREATE INDEX idx_rooms_is_deleted ON public.rooms(is_deleted) WHERE is_deleted = false;
CREATE INDEX idx_messages_room_id ON public.messages(room_id);
CREATE INDEX idx_messages_room_created ON public.messages(room_id, created_at DESC);

-- -----------------------------------------------------------------------------
-- ROW LEVEL SECURITY
-- -----------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.room_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
-- Allow insert so handle_new_user trigger can create profile; also allows client if auth.uid() is set
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

DROP POLICY IF EXISTS "Courses are viewable by authenticated users" ON public.courses;
CREATE POLICY "Courses are viewable by authenticated users" ON public.courses FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Teachers and admins can insert courses" ON public.courses;
CREATE POLICY "Teachers and admins can insert courses" ON public.courses FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('teacher', 'admin')));
DROP POLICY IF EXISTS "Teachers and admins can update courses" ON public.courses;
CREATE POLICY "Teachers and admins can update courses" ON public.courses FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('teacher', 'admin')));

DROP POLICY IF EXISTS "Lessons are viewable by authenticated users" ON public.lessons;
CREATE POLICY "Lessons are viewable by authenticated users" ON public.lessons FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Teachers and admins can manage lessons" ON public.lessons;
CREATE POLICY "Teachers and admins can manage lessons" ON public.lessons FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('teacher', 'admin')));

DROP POLICY IF EXISTS "Books are viewable by authenticated users" ON public.books;
CREATE POLICY "Books are viewable by authenticated users" ON public.books FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Admins can manage books" ON public.books;
CREATE POLICY "Admins can manage books" ON public.books FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Rooms are viewable by authenticated users" ON public.rooms;
CREATE POLICY "Rooms are viewable by authenticated users" ON public.rooms FOR SELECT TO authenticated USING (is_deleted = false);
DROP POLICY IF EXISTS "Authenticated users can create rooms" ON public.rooms;
CREATE POLICY "Authenticated users can create rooms" ON public.rooms FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);
DROP POLICY IF EXISTS "Room creator can update room" ON public.rooms;
CREATE POLICY "Room creator can update room" ON public.rooms FOR UPDATE TO authenticated USING (auth.uid() = created_by);

DROP POLICY IF EXISTS "Room participants viewable by authenticated" ON public.room_participants;
CREATE POLICY "Room participants viewable by authenticated" ON public.room_participants FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Users can join rooms" ON public.room_participants;
CREATE POLICY "Users can join rooms" ON public.room_participants FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can leave rooms" ON public.room_participants;
CREATE POLICY "Users can leave rooms" ON public.room_participants FOR DELETE TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Messages viewable by authenticated users" ON public.messages;
CREATE POLICY "Messages viewable by authenticated users" ON public.messages FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "Authenticated users can send messages" ON public.messages;
CREATE POLICY "Authenticated users can send messages" ON public.messages FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can soft-delete own messages" ON public.messages;
CREATE POLICY "Users can soft-delete own messages" ON public.messages FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- RPC helpers
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_enum_values(enum_name text)
RETURNS TABLE(value text, sort_order real)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_catalog
AS $$
  SELECT
    e.enumlabel::text AS value,
    e.enumsortorder::real AS sort_order
  FROM pg_type t
  JOIN pg_enum e ON e.enumtypid = t.oid
  JOIN pg_namespace n ON n.oid = t.typnamespace
  WHERE n.nspname = 'public'
    AND t.typname = enum_name
  ORDER BY e.enumsortorder;
$$;

GRANT EXECUTE ON FUNCTION public.get_enum_values(text) TO authenticated;
