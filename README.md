# Introduction
AIXM is using the Extensible Markup Language (XML) format. Therefore, AIXM can benefit from technologies developed specifically for the XML world, such as EXtensible Stylesheet Language (XSL) and XSL Transformations (XSLT). XSLT is also usable by non-programmers in order to perform simple tasks on AIXM data, such as extracting data, counting specific elements, exporting data in a HTML or text report, importing data in Excel, etc.
The purpose of this project is to share a series of XSLT scripts that can be used to extract CSV formatted data for specific subjects (such as a list of navaids, designated points, etc.) from an AIP Data Set provided in AIXM 5.1.1. See www.github.com/aixm/donlon for sample data.
In general, XSLT templates used here work in “streaming mode”. With this approach, the AIXM XML file does not need to be fully loaded in the working memory of the computer. Instead, little XML chunks are loaded and processed with matching XSLT templates, in the order in which the appear in the original file. The advantage is obvious for large XML files, such as is the case with AIXM 5.1 files that can be in the order of GB if they contain all AIS data worldwide.
# Disclaimer
The initial work was done by a 'business user', not by a programmer. Therefore, the terminology and the commented XSLT code might look low-quality for an experienced XML or XSLT programmer. The initial purpose is to explain to other business users how to use widely available XML processing tools in order to achieve business needs, such analysing the data contained in an AIXM 5.1 XML file. Hopefully, the quality of the code will improve in time with the contribution of more qualified XSLT developers.

# References
[1] XSL Transformations (XSLT) Version 3.0, W3C Candidate Recommendation, 19 November 2015, https://www.w3.org/TR/2015/CR-xslt-30-20151119/

[2] Saxon documentation, http://www.saxonica.com/documentation/

[3] Oxygen XML Developer, https://www.oxygenxml.com/xml_developer.html

[4] XSLT Introduction, W3C schools, http://www.w3schools.com/xml/xsl_intro.asp 

[5] AIXM 5.1 XML Schema, www.aixm.aero/schema/5.1/index.html 
