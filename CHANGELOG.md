## 2016-06-30 - Version 0.3.2
### Summary
Added pre_exclude parameter for forcing excludes before includes/excludes
#### Features
- New rdiff_export param: pre_exclude

## 2016-06-29 - Version 0.3.1
### Summary
Bigfixes.
#### Fixes
- Made lockfile names unique.
- Fixed issue with order of rdiff-backup parameters
- Fixed some travis ci issues.

## 2016-06-28 - Version 0.3.0
### Summary
Added includesymboliclinks excludespecialfiles and made them default true and tunable along with noeas.
#### Features
- New rdiff_export param: excludespecialfiles
- New rdiff_export param: includesymboliclinks
- New rdiff_export param: noeas

## 2016-06-23 - Version 0.2.4
### Summary
Added tests.

## 2016-06-23 - Version 0.2.3
### Summary
Bugfixes.

#### Fixes
- Defining '/' as a path will no longer result in broken paths/titles.
- Defining '*' as an include or exclude will no longer break backup scripts as it is quoted.

## 2016-06-22 - Version 0.2.2
### Summary
Changes to the backup scripts for safety and versatility.

#### Features
- Backup script now pidified and locked.
- Cleanup job will not run unless backup was successful.
- No redundant sleep before cleanup job.
- Backup script can be manually run with --now to avoid cron jitter wait.

## 2016-06-20 - Version 0.2.1
### Summary
Adds the ability to add includes and excludes to rdiff_export type

#### Features
- Add include parameter for rdiff_export type
- Add exclude parameter for rdiff_export type

## 2016-06-01 - Version 0.2.0
### Summary
Split backup scripts into one per resource rather than one monolithic file per host, made cron hour and minute
tuneable and added optional cron_jitter parameter to defined type.

#### Features
- Add CHANGELOG.md
- Add cron_hour parameter for rdiff_export type
- Add cron_minute parameter for rdiff_export type
- Add cron_jitter parameter for rdiff_export type
- Removed client::config classes

#### Bugfixes
- Cronjobs will no longer run every job per host at each time.

## 2016-05-19 - Version 0.1.2
### Summary
Minor documentation and typo changes

## 2016-05-19 - Version 0.1.1
### Summary
Minor documentation and typo changes

## 2016-05-19 - Version 0.1.0
### Summary
Initial Release
