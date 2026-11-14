# Project notes

- Backend lives in `backend/` (FastAPI). Design source: `Junior_Astronaut_Backend_Technical_Document.pdf` in `Downloads`.
- Use Python 3.14 via `backend/.venv` (`py -3.14 -m venv .venv`); the default `python` is 3.15.
- Run all commands from `backend/`:
  - Install: `.venv\Scripts\python -m pip install -r requirements-dev.txt`
  - Tests: `.venv\Scripts\python -m pytest -q`
  - Server: `.venv\Scripts\python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
- `backend/.env` holds secrets (NASA key, Supabase keys); never commit it.
- With empty `SUPABASE_*` values the app runs in local mode (SQLite `local_dev.db`, any Bearer token accepted).
- DONKI rejects date ranges over 60 days.
- Supabase project `fkpgakudyqvqikkrgoth`: migrations 001-003 are applied. Direct DB host is IPv6-only; `SUPABASE_DB_URL` uses the session pooler (`aws-1-ap-northeast-1.pooler.supabase.com`).
- Migration `004_water_food.sql` is also applied (5 resources, 7 themed missions).
- Design mock-ups are in `fronted images scren scnrio/`; `frontend/assets/images/` are crops of them.
- Flutter app lives in `frontend/`. Flutter 3.47.9 is at `C:/src/flutter` (not on PATH; in bash: `export PATH="/c/src/flutter/bin:$PATH"`). Verify with `flutter analyze`, `flutter test`, `flutter build web`. Run with `flutter run -d chrome --web-port 3000` (backend CORS allows only that port) and the backend on port 8000.
- Sign-in is name-only: the app calls Supabase anonymous sign-up and falls back to backend `POST /api/v1/auth/guest`.
