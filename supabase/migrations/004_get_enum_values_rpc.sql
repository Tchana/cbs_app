-- Returns ordered values for a Postgres enum type.
-- Example:
--   select * from public.get_enum_values('book_category');

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
  JOIN pg_enum e
    ON e.enumtypid = t.oid
  JOIN pg_namespace n
    ON n.oid = t.typnamespace
  WHERE n.nspname = 'public'
    AND t.typname = enum_name
  ORDER BY e.enumsortorder;
$$;

GRANT EXECUTE ON FUNCTION public.get_enum_values(text) TO authenticated;
