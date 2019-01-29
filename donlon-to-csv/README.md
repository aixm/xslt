Content
This folder contains XSLT scripts that can be used to extract data in CSV format from an AIP Data Set in AIXM 5.1.1 format, such as the Donlon Specimen.
The scripts are based on the coding rules for the AIP Data Set provided on the www.aixm.aero/confluence web site.

How to use
Because of the potentially large size of an AIP Data Set, which can contain complex data structures and thousands of records, the scripts are developed to work in streaming mode. They have been tested with Saxon-EE 9.8.0.12.
The execution is launched on a dummy.xml file. The name of the AIP Data Set file to be processed is actually specified in the XSLT file. See AIXM_AIP_DS_Extract_Designated_Points-....xslt for details.
