# How to get keygrip
gpg --fingerprint --fingerprint <email>
OR gpg --with-keygrip --list-secret-keys $KEY_ID
# How to get GPG keyID ?

gpg --list-secret-keys --keyid-format LONG

# To list keys
gpg --list-keys you@example.com
or
gpg --list-secret-keys you@example.com

# to export public key use this command:

gpg --output mykey.key --armor --export you@example.com

# to export private key use this command:

gpg --export-secret-keys you@example.com > private.key

# to import private key or public key

gpg --import cert.key

gpg --sign-key you@email.com maybe this one only when use for seaching
key from repo]

# To verify fingerprint match

gpg --fingerprint theperson@email.com

# If key is ultimate trusted, then we can do this to encrypt file:

gpg --recipient arafat@sofibox.com --encrypt FILENAME (no need to enter passphrase.. only decrypt). but this one need cert to decrypt.