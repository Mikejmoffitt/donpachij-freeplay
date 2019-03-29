# DonPachi (Japanese ver) Free Play Patch
2019 Michael Moffitt
mikejmoffitt@gmail.com

Overview
--------
This patch adds a Free Play option to the game's configuration screen,
replacing the 3 coins / 1 play option that is rarely used in a home or
presentation envrionment.

Instructions
------------
Apply the IPS patch to a dump of the ROM at U29, and burn the patched file to a
27C4096 or compatible ROM.

Development
-----------
This patch uses The Macro Assembler AS as an assembler, and incbins
original game program as a binary base. My own tool, bsplit, is used to
do simple ROM split, exchange, and interleave operations, and is available from
https://github.com/mikejmoffitt/romtools.
