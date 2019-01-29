<?xml version="1.0" encoding="UTF-8"?>
<!-- This file includes contributions from EUROCONTROL -->
<!-- Copyright (c) 2019, EUROCONTROL

TBD - add license and disclaimer...

-->

<xsl:transform version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:uuid="java.util.UUID"
    xmlns:message="http://www.aixm.aero/schema/5.1.1/message"
    xmlns:gts="http://www.isotc211.org/2005/gts" 
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:gss="http://www.isotc211.org/2005/gss" 
    xmlns:aixm="http://www.aixm.aero/schema/5.1.1"
    xmlns:gsr="http://www.isotc211.org/2005/gsr" 
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:event="http://www.aixm.aero/schema/5.1.1/event" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:aixm_ds_xslt="http://www.aixm.aero/xslt">

    <xsl:import href="AIXM_DS_Shared_Functions-0.1-2019-01.xslt"/>
    <!-- Imports functions that could be re-used by other Data Set processing stylesheets, such as a function that converts DD.dddd into DDMMSS.ssH, etc. 
        This includes a local copy of the FunctX XSLT Function Library, see http://www.xsltfunctions.com --> 
    
      
    <xsl:output method="text"/>
    
    <xsl:mode name="skip-unknown" streamable="yes" on-no-match="shallow-skip"/>
    <xsl:mode name="preserve-unknown" streamable="yes" on-no-match="shallow-copy"/>
     
    <xsl:accumulator name="srsName" as="xs:string?" initial-value="()" streamable="yes">
        <xsl:accumulator-rule match="aixm:Point" select="string(@srsName)"/>
        <!-- TBD - need to expand this to other possibilitie than aixm:Point. Need to consider the full inhetritance chain for srsName, see the Profile document -->
    </xsl:accumulator>
    
    <xsl:template match="/">
        <xsl:stream href="EA_AIP_DS_FULL_20170701.xml" use-accumulators="#all">
        <!-- this XSLT is initiated on a dummy.xml file, which in turn launches the processing in streaming mode of the AIP data set. The actual AIP data set file name is specified above --> 
            <xsl:text>valid from, valid until, Name-code designator, Coordinates, Remarks</xsl:text>
            <xsl:apply-templates mode="skip-unknown"/>
            <!-- mode is "skip-unknown" in order to limit the output to the data that is in the scope of the query, DesignatedPoints in this case -->
        </xsl:stream>
    </xsl:template>
    
    <xsl:template match="aixm:DesignatedPoint"  mode="skip-unknown">
            <xsl:apply-templates mode="skip-unknown"/>
    </xsl:template>

    <xsl:template match="aixm:timeSlice" mode="skip-unknown">
        <xsl:apply-templates mode="skip-unknown"/>
    </xsl:template>

    <xsl:template match="aixm:DesignatedPointTimeSlice"  mode="skip-unknown">
        <xsl:apply-templates mode="skip-unknown"/>
    </xsl:template>

    <xsl:template match="aixm:DesignatedPointTimeSlice/gml:validTime/gml:TimePeriod/gml:beginPosition"  mode="skip-unknown">
        <!-- this is the first element processed in a DesignatedPoint, therefore it needs to insert a new line -->
        <xsl:text>
</xsl:text>
        <xsl:value-of select="text()"/><xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="aixm:DesignatedPointTimeSlice/gml:validTime/gml:TimePeriod/gml:endPosition"  mode="skip-unknown">
        <xsl:value-of select="text()"/><xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="aixm:DesignatedPointTimeSlice/aixm:designator"  mode="skip-unknown"> 
        <xsl:value-of select="text()"/><xsl:text>, </xsl:text>
    </xsl:template>
    
    <xsl:template match="aixm:DesignatedPointTimeSlice/aixm:location/aixm:Point"  mode="skip-unknown">
        <!-- TBD - might need to support other alternatives for expressing the point position, such as gml:Point -->
        <xsl:variable name="mySrsName" select="accumulator-before('srsName')"/>
        <xsl:value-of select="aixm_ds_xslt:geo_deg_to_dms(gml:pos, $mySrsName)"/>
        <xsl:text>, </xsl:text>
     </xsl:template>

</xsl:transform>
