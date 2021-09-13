
Maxi Perm Documentation

Author: Arafat Ali | Email: arafat@sofibox.com | (C) 2019-2021

Usage:

perm <ACTIONS> <OPTIONS>

These are 2 special commands without action:

perm
perm <OPTIONS>


Running perm without any arguments will show info about the current folder only

eg: perm

OPTIONAL ARGUMENT <path> can be provided to show info about specific path (file or folder)

eg: perm /var/www

The above command will only show the current information about the folder www. To show info about its content use this:

eg: perm -r /var/www


OPTIONS:

  -h, --help
        Show usage help text.

  -V, --version
        Show version information

  -t, --test
        This is a test unit to test the script

  -r, -R, --recursive <PATH>
         Running perm with only this recursive option will list its contents for the current folder or path
         eg: perm -r

         OPTIONAL ARGUMENT(S):

             <PATH>

              We can specify path after the recursive option above to list its contents for the path:
              eg: perm -r /var/www


ACTIONS:

  help
        Show usage help text. This action is similar to the option -h

  version
        Show version information. This action is similar to the option -V

  check
        This action is used to check info about the path. If you run this action without any arguments,
        it will list info about the current folder or path

        eg: perm check (this is similar like running perm without any actions as mentioned above, eg: perm)

           OPTIONAL OPTION(S):

            -r, -R, --recursive:
                If you want to recursively check its content, use -r, -R, R or --recursive after the action check:
                eg: perm check -r

             -p, --path:
                 You can specify path with option of -p or --path for defining specific path:
                 eg: perm check -r -p /var/www or eg: perm check -rp /var/www

                 IMPORTANT: The option -p or --path is required if you want to define specific path when using check action.
                            The path can be absolute or relative path

                 eg: perm check -p /usr/local

                 this is not valid because it does not have an option -p : perm check /usr/local

                 You can also specify multiple paths to check the folder info but you must quote the path like below:
                 eg: perm check -p "/var/www/file1 /etc/file2 /usr/folder1 /usr/local"

                 Try this to check multiple folder with its contents:
                 eg: perm check -rp "/var/www/file1 /etc/file2 /usr/folder1 /usr/local"

  change
        This action is used to change file or folder permission based on chmod. This action required at least 1 option as follow:

             OPTION(S):

               -x, --permission <PERMISSION_VALUE> <OPTIONAL_PATH> <OPTIONS>

                  This is a global permission option.

                  PERMISSION_VALUE:

                  The permission value must be in a valid octal notation for linux file permission
                  eg: 755 or 644

                  The command below will change the current folder or path to permission of 755 (it will not change its contents)
                  eg: perm change -x 755

                  If you want to change all its contents to 755 you can supply the recursive option -r, --recursive, -R
                  eg: perm change -x 755 -r or eg: perm change -rx 755

                  Note: if you use recursive option, you will be asked whether to confirm or cancel the operation

                  You can also specify path for this option
                  eg: perm change -x 777 -r -p /website/tmp or eg: perm change -x 777 -rp /website/tmp

               -d, --dir-perm <PERMISSION_VALUE> <OPTIONAL_PATH>

                   Similar to the option -x or --permission but the option -d only change directory permission
                   and by default it uses recursive option -r (so when you use this option -d, you don't have to supply recursive option -r)
                   The command below will change all folders in the current path to permission 444
                   eg: perm -d 444

                   You can specify a path as well where path can be absolute or relative path
                   eg: perm -d 444 /usr/local or eg: perm -d local

                   Note: Since this option -d uses recursive option by default, you will be asked whether to confirm or cancel the operation

               -f, --file-perm <PERMISSION_VALUE> <OPTIONAL_PATH>

                   Similar to the option -x or --permission but the option -f only change file permission
                   and by default it uses recursive option -r (so when you use this option -f, you don't have to supply recursive option -r)
                   The command below will change all files in the current path to permission 444
                   eg: perm -f 444

                   You can specify a path as well where path can be absolute or relative path
                   eg: perm -f 444 /usr/local or eg: perm -f local

                   Note: Since the option -f uses recursive option by default, you will be asked whether to confirm or cancel the operation

                COMBINE 2 OPTIONS

                -f <PERMISSION_VALUE> -d <PERMISSION_VALUE>

                    You can also combine the -f and -d options like below
                    eg: perm change -d 755 -f 644 -p /var/www

                    The above command will change all folders permission to 755 and files to permission 644 inside the path /var/www.
                    Note: Since the option -f and -d uses recursive option by default, you will be asked whether to confirm or cancel the operation


