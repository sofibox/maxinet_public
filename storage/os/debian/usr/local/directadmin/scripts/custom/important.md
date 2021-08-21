In DA 1.6 -> custom script must follow this rule:

https://www.directadmin.com/features.php?id=2630

Normally the other script in custom, I should not create it. Just put inside a folder hook script

All custom scripts must end with .sh

All custom scripts inside the pre and post folder will be executed in alphabetic order.

The next script will have the previous script result text

eg. a.sh has output "yes"
b.sh will have result="yes"
c.sh will have result="yes yes"
d.sh will have result="yes yes yes"