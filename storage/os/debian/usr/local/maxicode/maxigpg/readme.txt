
Maxi GPG Documentation

Author: Arafat Ali | Email: arafat@sofibox.com | (C) 2019-2021

Usage:

maxigpg <-SHORT_OPTIONS/--LONG_OPTIONS>
maxigpg <ACTIONS> <-SHORT_OPTIONS/--LONG_OPTIONS>


OPTIONS:

  -h, --help
        This help text.

  -v, --version
        Show version information

  -t, --test
        Provide a unit test

ACTIONS:

 init
        Remove all configuration, passphrases, stop gpg-agent process
        and recreate new configuration files (init default setting)


 setpass, setkey, setpassword

    OPTIONAL PARAMETER(S):
        --key <KEY_ID>"
        This action is used to key in GPG passphrase and validate it.
        This action will always clear the previous cache passphrase from gpp-agent.
        If the passphrase is valid, it will show information about the cache duration.
        Note that this action will automatically start gpg-agent

        eg: maxigpg setpass --key <KEY_ID> <cron_warn>"
        eg: maxigpg setpass --key 2B705B8B6FA943B1 --cronjob"

 stop
        Stop gpg-agent process. This will also clear the passphrase

 status

     OPTIONAL PARAMETER(S):
        --key <KEY_ID>"
        Show gpg-agent process and cache status for a given key ID. KEY_ID is an optional argument
        If no KEY_ID argument is given, it will then find the current valid passphrase with its cached C_CACHED_KEY_ID
        If KEY_ID argument is empty and not in cache file, program will halt for correct KEY_ID."

 removeconf (deprecated)
        This will remove gpg-agent configuration files. The new configuration will be created"
        automatically when the script is running again"

 clearpass
        This will clear all gpg-agent passphrases. This action is similar to restarting gpg-agent
