# Hacked-site check

Rule first: **check dates, not names.** A file named `index.php` can be clean; a file named `hello.php` can be the backdoor. And check users, posts and the database — not just files.

## 1. Public check
- Open the site, sitemap (`/sitemap.xml`) and `robots.txt`. Look for spam links, pharma / casino pages, redirects to unknown domains.

## 2. File dates
```bash
ls -lt /home/username/public_html | head -n 30
find /home/username/public_html -type f -mtime -7 -ls
```
Files modified in the last few days, especially at odd hours, go to the top of the list — whatever their name is.

## 3. Suspicious folders
- Look for new folders, upload folders with `.php` files, and files with encoded content (`eval(`, `base64_decode`).
- Check `.htaccess` for redirect rules you didn't write.

## 4. Users, posts & database
- WordPress: `wp user list`, `wp post list --post_type=post --post_status=publish` — look for admin users and spam posts you didn't create.
- Check the database for new admin users and injected links in `wp_posts` / `wp_options`.
- A clean file scan means nothing if a rogue admin user still exists.

## 5. Join the dates
Match the file dates with the user-creation date and the first spam post date. The overlap is the entry point — usually an outdated plugin/theme or a weak password. Fix that, then clean.

## After cleaning
- Change all passwords, remove unknown admin users, update everything, re-scan.
- Never clean files and leave the entry point open — it will come back.
