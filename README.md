# About

The goal of this project is to convert the required data of a 1password agilekeychain encryptionKeys.js file to the hash format expected by oclHashcat.  
The oclHashcat hash mode is -m 6600 = 1Password, Agile Keychain.  
Cloud Keychain (-m 8200 = 1Password, Cloud Keychain) conversion is currently not supported by this script.  
Support for Cloud Keychain may be added later (if there is any interest) to this or an independent script.

# Requirements

Software:  
- Perl must be installed (should work on *nix and windows with perl installed)


# Installation and First Steps

* Clone this repository:  
    git clone https://github.com/philsmd/1password_agilekeychain_to_hashcat.git
* Enter the repository root folder:  
    cd 1password_agilekeychain_to_hashcat
* Run it:  
    ./1password_agilekeychain_to_hashcat.pl encryptionKeys.js hashes.txt
* Run oclHashcat:  
    ./oclHashcat64.bin -m 6600 -a 0 hashes.txt dict.txt


# Usage and command line options

The second command line argument, i.e. the output file, is not required.  
If you do not specify any output file (or 2nd command line argument) the output will be printed to stdout.
It is also possible to pipe or redirect the stdout of course.
    ./1password_agilekeychain_to_hashcat.pl encryptionKeys.js >> existing_1password_hashes_file.txt

# Hacking

* More features
* Add support for Cloud Keychain
* CLEANUP the code, use more coding standards, make it easier readable, everything is welcome (submit patches!)
* all bug fixes are welcome
* testing with different versions of 1password clients etc
* solve and remove the TODOs (if any exist)
* and,and,and

# Credits and Contributors 
Credits go to:  
  
* philsmd, hashcat project

# License/Disclaimer

License: belongs to the PUBLIC DOMAIN, donated to hashcat, credits MUST go to hashcat and philsmd for their hard work. Thx
Disclaimer: WE PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE Furthermore, NO GUARANTEES THAT IT WORKS FOR YOU AND WORKS CORRECTLY
