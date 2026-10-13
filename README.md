# Ekebol QLD Floor Schedule

A single-page production schedule for the Ekebol QLD site: jobs, tasks, labour pools, outsourcing, shutdowns,
sale value by month, suggestions and a question box. It is one file (`index.html`) with no build step.

## Where the data lives
- **On the website** (served over http/https): sign in, and everyone shares one schedule that syncs through this site's own
  Supabase project (`supabase-setup.sql` creates the tables and the sign-in rules). The page checks for changes every few seconds.
- **Opened as a file on a PC** (`file://`): sync is off and the data stays in that browser only.
- **Export config / Import config** (top of the page) back up or move a setup. To move local data to the website,
  Export from the local copy, sign in on the website and Import.

## Set up Supabase (once)
1. Create a new Supabase project (not another site's).
2. Run `supabase-setup.sql` in the SQL Editor.
3. Authentication > Users > add a user, then run the snippet at the bottom of the SQL file to make that user a manager.
4. Put the Project URL and the publishable (anon) key into `SUPABASE_URL` / `SUPABASE_ANON_KEY` in `index.html`.
   The publishable key is meant to be public; the sign-in and row-level-security rules are what protect the data.
   Never put a `service_role` / secret key in this file.

## Host it
Any static host works: GitHub Pages (Settings > Pages > main / root), Vercel or Netlify.
