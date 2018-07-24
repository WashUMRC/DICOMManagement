# DICOMManagement

This set of filese is designed to allow batch creation of sets of DICOM files and retrieve them easily. 

Generate: Run ctBatchDICOMFromISQ.m This requires, of course, that the isq files for the scans you want to make DICOM files from are on the Scanco system. It reads from DICOM_Batch_Export.COM and generates a new VMS script, puts it on the Scanco machine, and executes it. When it has completed (and it may take a long time), run getDICOMFromMicro or getDICOMFromViva as appropriate.
