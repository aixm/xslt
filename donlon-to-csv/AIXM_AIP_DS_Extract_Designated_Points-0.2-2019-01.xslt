<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (c) 2019, EUROCONTROL

BSD 2-Clause License

Copyright (c) 2019, EUROCONTROL
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
    
    <xsl:mode name="skip-unknown" on-no-match="shallow-skip"/>
     
    <xsl:accumulator name="srsName" as="xs:string?" initial-value="()" streamable="yes">
        <xsl:accumulator-rule match="aixm:Point" select="string(@srsName)"/>
        <!-- TBD - need to expand this to other possibilitie than aixm:Point. Need to consider the full inhetritance chain for srsName, see the Profile document -->
    </xsl:accumulator>
    
    <xsl:template match="/">
        <xsl:stream href="EA_AIP_DS_FULL_20170701.xml" use-accumulators="#all">
        <!-- this XSLT is initiated on a dummy.xml file, which in turn launches the processing in streaming mode of the AIP data set. The actual AIP data set file name is specified above --> 
            <xsl:text>valid from, valid until, Name-code designator, Coordinates, Remarks</xsl:text>
            <xsl:apply-templates select="*/message:hasMember/copy-of(.)" mode="skip-unknown"/>
            <!-- this is burst-streaming mode, where each hasMember is treated as a small xml document and may be processed with dedicated templates that do not have to be streamable. 
                Using burst-streaming provides more flexibility for the future evolution of this script -->
            <!-- mode is "skip-unknown" in order to limit the output to the data that is in the scope of the query, DesignatedPoints in this case -->
        </xsl:stream>
    </xsl:template>
    
    <xsl:template match="message:hasMember" mode="skip-unknown">
        <xsl:apply-templates mode="skip-unknown"/>
    </xsl:template>
    
    <xsl:template match="aixm:DesignatedPoint"  mode="skip-unknown">
        <xsl:for-each select="aixm:timeSlice/aixm:DesignatedPointTimeSlice">
            <!-- first insert a new line in the CSV -->
            <xsl:text>
</xsl:text>
            <xsl:value-of select="gml:validTime/gml:TimePeriod/gml:beginPosition"/><xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when  test="not(gml:validTime/gml:TimePeriod/gml:endPosition/text())">
                    <xsl:value-of select="gml:validTime/gml:TimePeriod/gml:endPosition/@indeterminatePosition"/><xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="gml:validTime/gml:TimePeriod/gml:endPosition"/><xsl:text>, </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="aixm:designator"/><xsl:text>, </xsl:text>
            <xsl:apply-templates select="aixm:location/aixm:Point"></xsl:apply-templates>
            <!-- TBD - might need to support other alternatives for expressing the point position, such as gml:Point -->
        </xsl:for-each>
    </xsl:template>
   
    <xsl:template match="aixm:Point">
        <xsl:variable name="mySrsName" select="accumulator-before('srsName')"/>
        <xsl:value-of select="aixm_ds_xslt:geo_deg_to_dms(gml:pos, $mySrsName)"/>
        <xsl:text>, </xsl:text>
     </xsl:template>

</xsl:transform>
