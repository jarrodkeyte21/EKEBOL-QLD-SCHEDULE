# Ekebol QLD Floor Schedule

A single-page production schedule for the Ekebol QLD site: jobs, tasks, labour pools, outsourcing, shutdowns,
sale value by month, suggestions and a question box. It is one file (`index.html`) with no build step.

- **Data** is saved in the browser on each device (localStorage). Nothing is sent to a server.
- Use **Export config** (top of the page) to back up a setup, and **Import config** to restore it.
- Cloud sync is deliberately switched off (see `SUPABASE_URL` in `index.html`), so this can never touch another site's data.

## Run it

Open `index.html` in Chrome or Edge, or host the folder as a static site (GitHub Pages, Vercel, Netlify).
