-- +goose Up
ALTER TABLE settings
  ADD COLUMN IF NOT EXISTS qris_image BYTEA,
  ADD COLUMN IF NOT EXISTS qris_image_mime TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS qris_image_updated_at TIMESTAMPTZ;

-- +goose Down
ALTER TABLE settings
  DROP COLUMN IF EXISTS qris_image_updated_at,
  DROP COLUMN IF EXISTS qris_image_mime,
  DROP COLUMN IF EXISTS qris_image;

