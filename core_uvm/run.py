#!/usr/bin/env python3
# ==============================================================================
# Copyright 2023 VerifAI All Rights Reserved.
#
# ==============================================================================

import os
import glob
import subprocess
import shutil


# generate UVM tests using verifai command line
f = '*.sv'

files = glob.glob(f)

for f in files:
    print("(verifai-testguru) generating UVM tests for file {0}" .format(f))
    res = subprocess.run(['verifai','testguru', '-c','config.json','-src',f])
