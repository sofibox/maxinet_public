Maxi AIDE Documentation

MaxiAIDE is an AIDE wrapper tool to manage AIDE easily

See the original AIDE: https://github.com/aide/aide

Author: Arafat Ali | Email: arafat@sofibox.com | (C) 2019-2021

Usage:

maxiaide <-SHORT_OPTIONS/--LONG_OPTIONS>
maxiaide <ACTIONS> <-SHORT_OPTIONS/--LONG_OPTIONS>

OPTIONS:

  -h, --help
        This help text.

  -v, --version
        Show version information

  -t, --test
        Provide a unit test

ACTIONS:

  scan

      Run system scan for any file or folder changes based on rule from aide.conf.
      In order to update AIDE database automatically after scanning, use the following options:
      -a, --db-auto-update

      OPTIONAL PARAMETER(S):

          -c,--cronjob
          Run the scan in cronjob mode

          -v, --verbose
          Run the scan in verbose mode

          -d, --debug
          Run the scan in debug mode

          -u, --db-auto-update, --auto-update, --db-update
          Auto update AIDE database after scanning

          -b, --db-auto-backup, --auto-backup, --db-backup
          Automatically archive or backup existing AIDE database with timestamp after scanning

  init

      Initialize config file and database. This will also backup existing AIDE config file
      Note that this action will automatically run another action called update-rule


  update-rule

      Update custom rule from /conf/custom_rules.

  edit-rule, edit-rules, editrule

      Automatically open custom rule file and edit them via editor