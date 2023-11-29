To run tests:
verifai testguru -c config.json -src compressed_decoder.sv

To fix tests..

python3 ~/verifai/lib/python3.10/site-packages/verifai/wrappers/run_auto_debugger.py -c config.json -auto -src  tests_compressed_decoder.sv

