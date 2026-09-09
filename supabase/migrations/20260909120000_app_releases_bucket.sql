-- Public bucket for CBS OTA update manifests and installers (CI uploads via service role).
INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES ('app-releases', 'app-releases', true, 52428800)
ON CONFLICT (id) DO UPDATE SET public = true, file_size_limit = EXCLUDED.file_size_limit;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'storage'
      AND tablename = 'objects'
      AND policyname = 'Public read app releases'
  ) THEN
    CREATE POLICY "Public read app releases"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'app-releases');
  END IF;
END $$;
