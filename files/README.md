# Gator Grind — Deployment Guide

This turns the planner into a real website: your own URL, real login, and data that
saves permanently to a database. Total cost: $0 on free tiers. Total time: ~20 minutes.

## What you're setting up
- **Supabase** — a free hosted database + login system
- **Vercel** — free hosting for the site itself, plus a tiny serverless function
  that keeps your Claude API key private
- **Anthropic API key** — powers the "Ask Gator AI" feature (optional — the rest
  of the site works fine without it)

---

## Step 1 — Create your Supabase project

1. Go to https://supabase.com and sign up (free).
2. Click **New Project**. Pick any name/region, set a database password (save it
   somewhere), and wait ~2 minutes for it to spin up.
3. In the left sidebar, open **SQL Editor** → **New query**.
4. Paste in the entire contents of `supabase-schema.sql` (included in this folder)
   and click **Run**. This creates your `tasks` and `schedule_slots` tables and
   locks them down so each user can only see their own data.
5. In the left sidebar, go to **Project Settings → API**. Copy two values:
   - **Project URL**
   - **anon public** key
6. Open `index.html` in this folder, find these two lines near the top of the
   `<script>` section, and paste your values in:
   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT-REF.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
   ```
7. (Optional, recommended while testing) In **Authentication → Providers → Email**,
   turn **off** "Confirm email" so you can sign up and log in immediately without
   clicking an email link. Turn it back on later if you want extra security.

## Step 2 — Get an Anthropic API key (for the AI assistant)

1. Go to https://console.anthropic.com and sign up.
2. Go to **API Keys** → **Create Key**. Copy it — you'll paste it into Vercel in
   Step 3, not into any file here.
3. Note: this is a paid API (usage-based, generally cents per conversation for a
   student's usage level). You can skip this step — the rest of the site works
   fine, "Ask Gator AI" will just show a friendly error until a key is added.

## Step 3 — Deploy to Vercel

1. Push this whole folder to a GitHub repository (create one on github.com, then
   `git init`, `git add .`, `git commit -m "gator grind"`, `git remote add origin ...`,
   `git push`). If you're not comfortable with git, Vercel also supports dragging
   a folder in directly via https://vercel.com/new — but GitHub makes future
   updates much easier.
2. Go to https://vercel.com, sign up (free), click **Add New → Project**, and
   import your GitHub repo.
3. Before deploying, expand **Environment Variables** and add:
   - Name: `ANTHROPIC_API_KEY`
   - Value: (paste the key from Step 2)
4. Click **Deploy**. In under a minute you'll get a real URL like
   `gator-grind.vercel.app`.

That's it — visit the URL, create an account, and start using it. Sign in from
your phone with the same account and your schedule/tasks will be there too.

## Making changes later
Edit the files, push to GitHub (`git add . && git commit -m "..." && git push`),
and Vercel automatically redeploys.

## Troubleshooting
- **"Failed to fetch" on sign in** → double check `SUPABASE_URL` and
  `SUPABASE_ANON_KEY` in `index.html` are exactly what Supabase shows you.
- **Sign up says success but sign in fails** → email confirmation is probably
  still on; check Step 1.7, or check your inbox for the confirmation email.
- **Ask Gator AI shows an error** → check that `ANTHROPIC_API_KEY` is set in
  Vercel's Environment Variables and redeploy after adding it.
- **Data doesn't save** → open the schema SQL again and confirm both tables and
  both policies were created without errors (Supabase will show red text if a
  statement failed).
