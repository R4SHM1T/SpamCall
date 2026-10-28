# Spam Shield: setup (from Windows + iPhone)
1. github.com -> New repository (private is fine) -> "uploading an existing file" -> unzip this folder and drag EVERYTHING in (keep the .github folder).
2. Actions tab -> "Build IPA" -> wait ~5 min -> open the run -> download artifact SpamShield-ipa -> unzip -> SpamShield.ipa.
3. Sideloadly (Windows) -> plug in iPhone -> drag the .ipa -> Start. Trust it in Settings -> General -> VPN & Device Management.
4. iPhone: Settings -> Apps -> Phone -> Call Blocking & Identification -> enable Spam Shield Blocker. Open the app, tap Reload.
Changing the list: edit CallBlocker/blocklist.txt on GitHub, commit, download the new IPA, reinstall. Free Apple ID apps expire in 7 days; reinstall weekly.
If Actions fails, open the failed step and send me the red error text.
