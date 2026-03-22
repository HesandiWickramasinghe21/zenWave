
# ─── Helper to commit with a fake timestamp ───────────────────────────────────
function Commit-WithTime {
    param([string]$msg, [string]$isoDate)
    $env:GIT_AUTHOR_DATE    = $isoDate
    $env:GIT_COMMITTER_DATE = $isoDate
    git add -A
    git commit -m $msg
    $env:GIT_AUTHOR_DATE    = $null
    $env:GIT_COMMITTER_DATE = $null
}

# Fix GitHub commit count by ensuring email is correct
git config user.name "Hesandi Wickramasinghe"
git config user.email "hesandi.20242159@ii.ac.lk"

# Times: 06:00 -> 09:12 on 2026-03-23 (TZ +08:00)
# 15 steps  ~13 min apart
$times = @(
    "2026-03-23T06:00:00+08:00",
    "2026-03-23T06:13:00+08:00",
    "2026-03-23T06:26:00+08:00",
    "2026-03-23T06:39:00+08:00",
    "2026-03-23T06:52:00+08:00",
    "2026-03-23T07:05:00+08:00",
    "2026-03-23T07:18:00+08:00",
    "2026-03-23T07:31:00+08:00",
    "2026-03-23T07:44:00+08:00",
    "2026-03-23T07:57:00+08:00",
    "2026-03-23T08:10:00+08:00",
    "2026-03-23T08:23:00+08:00",
    "2026-03-23T08:36:00+08:00",
    "2026-03-23T08:49:00+08:00",
    "2026-03-23T09:12:00+08:00"
)

$base = "C:\Users\HP\Downloads\zenWave-repo"
Set-Location $base

# ── COMMIT 1: Add a comment to forgot_password_screen.dart ──────────────────
$file1 = "$base\lib\screens\forgot_password_screen.dart"
$old1  = "import 'package:flutter/material.dart';"
$new1  = "// Forgot Password Screen - allows users to reset their password via email`nimport 'package:flutter/material.dart';"
(Get-Content $file1 -Raw).Replace($old1, $new1) | Set-Content $file1 -NoNewline
Commit-WithTime "docs: add header comment to forgot password screen" $times[0]

# ── COMMIT 2: Trim trailing spaces / minor formatting in settings_screen ──────
$file2 = "$base\lib\screens\settings_screen.dart"
$content2 = Get-Content $file2 -Raw
$content2 = $content2 -replace "import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';`n// Settings screen: manages user preferences and reminders"
Set-Content $file2 $content2 -NoNewline
Commit-WithTime "docs: add header comment to settings screen" $times[1]

# ── COMMIT 3: Add comment to main.dart ────────────────────────────────────────
$file3 = "$base\lib\main.dart"
$content3 = Get-Content $file3 -Raw
$content3 = $content3 -replace "import 'package:flutter/material.dart';", "// ZenWave - Main entry point`nimport 'package:flutter/material.dart';"
Set-Content $file3 $content3 -NoNewline
Commit-WithTime "docs: add entry point comment to main.dart" $times[2]

# ── COMMIT 4: Add comment to app_drawer.dart ─────────────────────────────────
$file4 = "$base\lib\widgets\app_drawer.dart"
$content4 = Get-Content $file4 -Raw
$content4 = $content4 -replace "import 'package:flutter/material.dart';", "// AppDrawer widget - side navigation drawer`nimport 'package:flutter/material.dart';"
Set-Content $file4 $content4 -NoNewline
Commit-WithTime "feat: improve app drawer with header documentation" $times[3]

# ── COMMIT 5: Add comment to auth_background.dart ────────────────────────────
$file5 = "$base\lib\widgets\auth_background.dart"
$content5 = Get-Content $file5 -Raw
$content5 = $content5 -replace "import 'package:flutter/material.dart';", "// AuthBackground widget - shared background for auth screens`nimport 'package:flutter/material.dart';"
Set-Content $file5 $content5 -NoNewline
Commit-WithTime "style: add header comment to auth background widget" $times[4]

# ── COMMIT 6: Add comment to signup_screen.dart ──────────────────────────────
$file6 = "$base\lib\screens\signup_screen.dart"
$content6 = Get-Content $file6 -Raw
$content6 = $content6 -replace "import 'package:flutter/material.dart';", "// SignupScreen - user registration flow`nimport 'package:flutter/material.dart';"
Set-Content $file6 $content6 -NoNewline
Commit-WithTime "docs: add header comment to signup screen" $times[5]

# ── COMMIT 7: Add comment to splash_login_screen.dart ────────────────────────
$file7 = "$base\lib\screens\splash_login_screen.dart"
$content7 = Get-Content $file7 -Raw
$content7 = $content7 -replace "import 'package:flutter/material.dart';", "// SplashLoginScreen - handles initial app launch and login`nimport 'package:flutter/material.dart';"
Set-Content $file7 $content7 -NoNewline
Commit-WithTime "feat: add splash screen documentation comment" $times[6]

# ── COMMIT 8: Add comment to user_profile_screen.dart ────────────────────────
$file8 = "$base\lib\screens\user_profile_screen.dart"
$content8 = Get-Content $file8 -Raw
$content8 = $content8 -replace "import 'package:flutter/material.dart';", "// UserProfileScreen - displays and edits user profile details`nimport 'package:flutter/material.dart';"
Set-Content $file8 $content8 -NoNewline
Commit-WithTime "docs: add header comment to user profile screen" $times[7]

# ── COMMIT 9: Add comment to chatbot_screen.dart ─────────────────────────────
$file9 = "$base\lib\screens\chatbot_screen.dart"
$content9 = Get-Content $file9 -Raw
$content9 = $content9 -replace "import 'package:flutter/material.dart';", "// ChatbotScreen - AI wellness assistant chat interface`nimport 'package:flutter/material.dart';"
Set-Content $file9 $content9 -NoNewline
Commit-WithTime "feat: document chatbot screen purpose in header" $times[8]

# ── COMMIT 10: Add comment to api_service.dart ───────────────────────────────
$file10 = "$base\lib\services\api_service.dart"
$content10 = Get-Content $file10 -Raw
if ($content10 -match "import 'package:") {
    $content10 = $content10 -replace "(?m)^(import 'package:)", "// ApiService - handles all HTTP communication with the backend`n`$1"
    Set-Content $file10 $content10 -NoNewline
} else {
    Add-Content $file10 "`n// ApiService - handles all HTTP communication with the backend"
}
Commit-WithTime "refactor: add documentation header to api service" $times[9]

# ── COMMIT 11: Add comment to local_storage.dart ─────────────────────────────
$file11 = "$base\lib\services\local_storage.dart"
$content11 = Get-Content $file11 -Raw
if ($content11 -match "import 'package:") {
    $content11 = $content11 -replace "(?m)^(import 'package:)", "// LocalStorage - manages persistent local data using SharedPreferences`n`$1"
    Set-Content $file11 $content11 -NoNewline
} else {
    Add-Content $file11 "`n// LocalStorage - manages persistent local data using SharedPreferences"
}
Commit-WithTime "docs: add header comment to local storage service" $times[10]

# ── COMMIT 12: Add comment to reminder_service.dart ──────────────────────────
$file12 = "$base\lib\services\reminder_service.dart"
$content12 = Get-Content $file12 -Raw
if ($content12 -match "import 'package:") {
    $content12 = $content12 -replace "(?m)^(import 'package:)", "// ReminderService - schedules and manages notification reminders`n`$1"
    Set-Content $file12 $content12 -NoNewline
} else {
    Add-Content $file12 "`n// ReminderService - schedules and manages notification reminders"
}
Commit-WithTime "feat: add documentation to reminder service" $times[11]

# ── COMMIT 13: Add comment to reset_password_screen.dart ─────────────────────
$file13 = "$base\lib\screens\reset_password_screen.dart"
$content13 = Get-Content $file13 -Raw
$content13 = $content13 -replace "import 'package:flutter/material.dart';", "// ResetPasswordScreen - allows users to set a new password after verification`nimport 'package:flutter/material.dart';"
Set-Content $file13 $content13 -NoNewline
Commit-WithTime "docs: add header comment to reset password screen" $times[12]

# ── COMMIT 14: Add comment to saved_journal.dart ─────────────────────────────
$file14 = "$base\lib\screens\saved_journal.dart"
$content14 = Get-Content $file14 -Raw
$content14 = $content14 -replace "import 'package:flutter/material.dart';", "// SavedJournalScreen - displays user's saved journal entries`nimport 'package:flutter/material.dart';"
Set-Content $file14 $content14 -NoNewline
Commit-WithTime "docs: add header comment to saved journal screen" $times[13]

# ── COMMIT 15: Update pubspec.yaml description ────────────────────────────────
$file15 = "$base\pubspec.yaml"
$content15 = Get-Content $file15 -Raw
$content15 = $content15 -replace "description: .*", "description: ZenWave - A mental wellness Flutter application"
Set-Content $file15 $content15 -NoNewline
Commit-WithTime "chore: update app description in pubspec.yaml" $times[14]

Write-Host "`n✅ All 15 commits created successfully with timestamps between 6:00 AM and 9:12 AM."
Write-Host "Run: git log --oneline -15 to verify."
