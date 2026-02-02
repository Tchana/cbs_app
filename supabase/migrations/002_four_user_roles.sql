-- =============================================================================
-- Four user types: student, teacher, visitor, admin
-- Run this if you already have profiles with the old role constraint.
-- =============================================================================

-- Drop old check constraint (name may vary; try both)
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_role_check;

-- Update existing 'user' roles to 'student'
UPDATE public.profiles SET role = 'student' WHERE role = 'user' OR role IS NULL;

-- Set default and new check constraint
ALTER TABLE public.profiles
  ALTER COLUMN role SET DEFAULT 'student';

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('student', 'teacher', 'visitor', 'admin'));
