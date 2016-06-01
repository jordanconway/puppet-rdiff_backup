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
