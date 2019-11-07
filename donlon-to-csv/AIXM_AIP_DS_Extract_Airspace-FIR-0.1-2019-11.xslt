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
    
    <xsl:output method="text"/>
    
    <xsl:mode name="skip-unknown" on-no-match="shallow-skip"/>
     
     <xsl:template match="/">
         <xsl:stream href="EA_AIP_DS_FULL_20170701.xml" use-accumulators="#all">
        <!-- this XSLT is initiated on a dummy.xml file, which in turn launches the processing in streaming mode of the AIP data set. The actual AIP data set file name is specified above --> 
            <xsl:text>type, name, designator</xsl:text>
            <xsl:apply-templates select="*/message:hasMember/copy-of(.)" mode="skip-unknown"/>
            <!-- this is burst-streaming mode, where each hasMember is treated as a small xml document and may be processed with dedicated templates that do not have to be streamable. 
                Using burst-streaming provides more flexibility for the future evolution of this script -->
            <!-- mode is "skip-unknown" in order to limit the output to the data that is in the scope of the query, DesignatedPoints in this case -->
        </xsl:stream>
    </xsl:template>
    
    <xsl:template match="message:hasMember" mode="skip-unknown">
        <xsl:apply-templates mode="skip-unknown"/>
    </xsl:template>
    
    <xsl:template match="aixm:Airspace"  mode="skip-unknown">
        <xsl:for-each select="aixm:timeSlice/aixm:AirspaceTimeSlice[1]">
            <xsl:if test="aixm:type='FIR'">
            <!-- first insert a new line in the CSV -->
            <xsl:text>
</xsl:text>
            <xsl:value-of select="aixm:type"/><xsl:text>, </xsl:text>
            <xsl:value-of select="aixm:designator"/><xsl:text>, </xsl:text>
            <xsl:value-of select="aixm:name"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:transform>
