This is the collection of custom scripts of directadmin

In Directadmin v1.6 above, custom scripts must follow this rule:

https://www.directadmin.com/features.php?id=2630

All custom scripts should end with .sh extension to distinguish between a normal file or script file

All custom scripts inside the pre- and post-folder will be executed in alphabetical order.

To reduce confusion on how the alphabetical oder execution work, only one main script should be placed in custom hook
folder called aa_main.sh

The main script aa_main.sh may call one or multiple .sh custom scripts inside the folder at the following location

aa_hook_scripts/custom_hook_folder/user_defined_script1.sh
aa_hook_scripts/custom_hook_folder/user_defined_script2.sh
aa_hook_scripts/custom_hook_folder/user_defined_script3.sh

Each custom_hook folder inside aa_hook_scripts should have an options.conf. See an example of options.conf in filemanager_pre hook

The next script output/result will have the previous script output/result text

example of 4 scripts:

if a.sh has and output "yes"
b.sh will have output with a new variable result="yes" and
c.sh will have output with a new variable result="yes yes" and
d.sh will have output with a new variable result="yes yes yes"

List of hook scripts:

Authentication Hooks can be found here: https://docs.directadmin.com/developer/hooks/authentication.html


