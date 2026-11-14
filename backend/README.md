# Junior Astronaut Mission Trainer - Backend

FastAPI backend for the NASA Space Apps game. Follows
`Junior_Astronaut_Backend_Technical_Document.pdf` (FastAPI, Supabase, NASA DONKI).

## Run

Use Python 3.14 (`py -3.14`). From `backend/`:

```bash
py -3.14 -m venv .venv
.venv\Scripts\python -m pip install -r requirements-dev.txt
copy .env.example .env        # then put your NASA key in NASA_API_KEY
.venv\Scripts\python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Interactive docs: http://localhost:8000/docs

Tests (never call NASA or Supabase): `.venv\Scripts\python -m pytest -q`

## Two storage modes

| | Local development | Supabase |
|---|---|---|
| When | `SUPABASE_*` values in `.env` are empty | all three `SUPABASE_*` values are set |
| Data | `local_dev.db` (SQLite) | Supabase PostgreSQL |
| Sign-in | none: any `Authorization: Bearer <text>` is accepted, each text is its own player | real Supabase Auth access token |

Local mode is for building and demos on one machine only. Never deploy it.

To switch to Supabase: create the project, run `migrations/001_schema.sql`,
`002_rls.sql`, `003_functions.sql`, `004_water_food.sql` in the SQL Editor in that
order, then fill `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` in `.env`.

## Game rules

Five resources (oxygen, power, water, food, radiation protection) and seven missions,
one per game day. Each mission offers three options and only that mission's options are
accepted on its day (`decision_not_for_this_mission` otherwise). `GET /api/v1/game/config`
returns the missions, options, effects and daily use. All numbers live in
`app/core/game_config.py` and are game design, not NASA measurements.

## Endpoints

| Method | URL | Auth | Purpose |
|---|---|---|---|
| GET | `/health` (`?deep=true`) | no | Server (and database) up? |
| GET | `/api/v1/game/config` | no | Decision catalogue and game parameters |
| POST | `/api/v1/missions` | yes | Start a mission |
| GET | `/api/v1/missions` (`?status=active&limit=1` to restore) | yes | List the player's missions |
| GET | `/api/v1/missions/{id}` | yes | One mission |
| POST | `/api/v1/missions/{id}/decision` | yes | Submit a decision |
| GET | `/api/v1/missions/{id}/history` | yes | Decisions made |
| GET | `/api/v1/nasa/space-weather` (`days` 1-60, `types`, `limit`) | yes | NASA DONKI events + simulated game alert |
| GET | `/api/v1/nasa/health-research` (`term`, `limit`) | yes | NASA OSDR studies by keyword |

Errors always look like `{"error": {"code", "message", "details"}}`.

## NASA data

- **DONKI** (api.nasa.gov, needs `NASA_API_KEY`): solar flares (FLR), coronal mass
  ejections (CME), geomagnetic storms (GST). Cached in the database for 30 minutes.
  `data_status` is `live`, `cached`, `archived` or `unavailable`; `type_status` gives
  the same per event type.
- **OSDR** (osdr.nasa.gov, no key): study titles and descriptions for a search term.
- Event fields are shown as NASA reports them. `game_scenario` (calm / watch / storm)
  and every number in `app/core/game_config.py` are game design, not NASA measurements.
