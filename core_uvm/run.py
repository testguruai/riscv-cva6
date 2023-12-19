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
f = '*/test_*.sv'

files = glob.glob(f)

for f in files:
    try:
        #print("copying {0} --> ../core_tests/{1}" .format(f,f))
        print("editing {0}" .format(f)) 
        #shutil.copy(f, "../core_tests/"+f)
        ofile = f.replace('test_','')
        ofile = os.path.basename(ofile)
        head = """\n// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: {0}
// UVM Test Bench and Test Code for {1} Verilog Code
// ==============================================================================\n""" .format(ofile,ofile)
        with open(f, 'r') as file:
           file_contents = file.read()
           combined_contents = head + file_contents
        #print("combined: {0}" .format(combined_contents))
        with open(f, 'w') as file:
           file.write(combined_contents)
           print("writing: {0}" .format(f))
    except:
        pass
