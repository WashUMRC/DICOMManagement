$ cd dk0:[MICROCT.DATA.SAMPLE.MEASUREMENT]
$ ipl
/isq_to_aim in CNUMBER.isq 0 -1
/todicom_from_aim in MEASUREMENT.dcm true false
q
