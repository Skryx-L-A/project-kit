# Account creation — real-world playbook (browser-assisted)

You CANNOT fully auto-create social accounts (ToS + phone/CAPTCHA defenses). Proven model:
**Claude drives the browser (claude-in-chrome); the USER solves CAPTCHA / hCaptcha / phone.**
Email verification codes & links: **read them yourself via the IMAP `gmail` tool** (email-manager),
e.g. `gmail.py read --query "from:instagram" --full` then extract the 6-digit code / link.

## Mechanics that work
- **Passwords:** generate strong, store gitignored (chmod 600), paste via the clipboard
  (`wl-copy` then Ctrl+V) so the password never enters the chat. Mind per-platform caps
  (TikTok 8–20 chars!).
- **DOB:** use one consistent adult date (the user's account-DOB convention).
- **Custom date/select dropdowns** (IG/TikTok) are DIV-based, not native `<select>` —
  `form_input` fails; click the dropdown then click the option (scroll for years).
- **Cookie/consent:** choose the privacy-preserving option (decline optional cookies).
- **File uploads are the hard wall:** the `file_upload` tool no longer accepts host filesystem
  paths, and `upload_image` needs an imageId from a captured screenshot / user upload. So
  avatars, headers, and image posts often must go via the platform **API** (e.g. Mastodon
  `update_credentials`), a **user upload**, or a screenshot→imageId workaround.

## Per-platform reality (from a real rollout)
| Platform | Reality | Posting |
|---|---|---|
| **Mastodon** (mastodon.social) | Open reg; email-verify link via IMAP; hCaptcha (user). Create an API app (Settings→Development) → token. **fosstodon blocks signups** (network policy). | **API, fully headless** — `PATCH /accounts/update_credentials` (name/bio/fields/avatar/header), `POST /statuses`. Best platform. |
| **X / Twitter** | Works in the extension; email signup (sometimes no phone); onboarding (interests/photo/passkey/premium — skip). New accounts = **graduated access** (limited reach until engagement). No easy API token. | **Browser** — Home → compose → ≤280 chars → Post. Bio via browser; avatar/banner need file upload. |
| **Instagram** | Open email signup; **6-digit code via IMAP**; no phone needed; decline optional cookies. | **Browser, image required** — feed posts NEED a visual; image upload blocked by the tool → user upload or workaround. |
| **Reddit** | **HARD-blocked** by the claude-in-chrome safety list (cannot navigate) → **user must create it manually**. Fresh accounts need **warm-up** (days of real comments) before promo or posts get filtered. | **PRAW** (script app) after warm-up. |
| **Lemmy** | lemmy.world needs an application + **manual admin approval**, and may **DENY** it → use an open-reg instance (lemmy.ml / programming.dev / lemm.ee). Email-verify link via IMAP. | API after approval. |
| **TikTok** | Email signup; "Send code" can **rate-limit** ("too many attempts") → wait + retry; **slide-CAPTCHA** (user); password ≤20 chars. | Browser, video required. |
| **Facebook** | A Page needs a **personal account**; automated personal-account creation = high instant-lock risk → **user-created**. | Browser / Graph API on the Page. |
| **YouTube** | Create a **Brand Channel** under an existing Google login (no new signup); user must be logged into Google. | Uploads by user / Data API. |

## Posting-method summary
Mastodon = API (headless, schedulable via cron + token). X = browser. IG/TikTok = browser +
media. Reddit = PRAW. Lemmy = API after approval. **Approval gate still applies** — nothing
public without the configured go.

## Scheduling unattended posts
Only API-postable platforms (Mastodon) can be scheduled headless (a local `at`/cron job running
a curl script with the stored token). Browser-only platforms (X/IG/TikTok) need a live logged-in
session and cannot be reliably scheduled unattended.
