-- Fix PostgREST relationship: messages.user_id -> public.profiles(id)
-- Run this if you get: "Could not find a relationship between 'messages' and 'profiles' in the schema cache"

ALTER TABLE public.messages
  DROP CONSTRAINT IF EXISTS messages_user_id_fkey;

ALTER TABLE public.messages
  ADD CONSTRAINT messages_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
