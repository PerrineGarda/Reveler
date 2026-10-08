-- ============================================================
-- RÉVÉLER — Configuration Supabase
-- À coller dans : Supabase → SQL Editor → New query → Run
-- ============================================================

-- 1. Créer la table
CREATE TABLE IF NOT EXISTS reveler_responses (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  client_id    TEXT NOT NULL,
  module       TEXT NOT NULL,   -- 'competences', 'qualites', 'anime'
  data         JSONB NOT NULL DEFAULT '{}',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (client_id, module)
);

-- 2. Index pour accélérer les requêtes par client
CREATE INDEX IF NOT EXISTS idx_reveler_client ON reveler_responses (client_id);
CREATE INDEX IF NOT EXISTS idx_reveler_module ON reveler_responses (module);

-- 3. Activer RLS (Row Level Security)
ALTER TABLE reveler_responses ENABLE ROW LEVEL SECURITY;

-- 4. Politique : les clients peuvent lire ET écrire LEURS propres données
--    (la clé anon est publique → on autorise tout accès en lecture/écriture
--     car les données client_id sont gérées côté app)
CREATE POLICY "allow_all_anon" ON reveler_responses
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- ============================================================
-- Vérification : affiche la table créée
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_name = 'reveler_responses';
