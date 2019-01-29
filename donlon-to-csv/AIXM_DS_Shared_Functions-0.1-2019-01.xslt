
<!--

 *************************************************************************************
 XSLT Function Library that are used in one or more of the data set processing scripts
 *************************************************************************************

 Copyright (C) 2019 EUROCONTROL

  
 @version 0.1
 @see     http://...
--> 
<xsl:transform version="3.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:uuid="java.util.UUID"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:functx="http://www.functx.com">
  
  <xsl:import href="functx-1.0-doc-2007-01.xsl"/>
  <!-- Imports a local copy of the FunctX XSLT Function Library, see http://www.xsltfunctions.com --> 
 
<!--
  Performs conversion of DD.dddd into DDMMSS.ssH

 @author  Eduard Porosnicu, Eurocontrol 
 @version 0.1
 @see     gitHub... 
 @param   $arg the string to substring 
 @param   $delim the delimiter 
--> 
<xsl:function name="aixm_ds_xslt:geo_deg_to_dms" as="xs:string?" 
              xmlns:aixm_ds_xslt="http://www.aixm.aero/xslt">
  <xsl:param name="geo_token" as="xs:string?"/> 
  <xsl:param name="srsName" as="xs:string?"/> 
 
  <xsl:variable name="LatLong" select="tokenize($geo_token,'\s')"/>
  <!-- TBD - the order depends on the CRS, we should check here based on the GML profile list and raise an error if unsupported
              - the srsName is provided as an argument to the function, but not used yet!-->
  <!-- TBD - The conversion should take the accuracy in consideration, if provided --> 
  <xsl:variable name="LatHemi">
    <xsl:choose>
      <xsl:when test="starts-with($LatLong[1],'-')">S</xsl:when>
      <xsl:when test="not(starts-with($LatLong[1],'-'))">N</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="LatDeg" select="functx:substring-after-if-contains(functx:substring-before-if-contains($LatLong[1], '.'),'-')"/>
  <xsl:variable name="LatDeci" select="functx:substring-after-if-contains($LatLong[1], '.')"/>
  <xsl:variable name="LatMin" select="format-number(floor(number(concat('0.', $LatDeci))*60.0),'00')"/>
  <xsl:variable name="LatSec" select="format-number(round((number(concat('0.', $LatDeci))*60.0 - number($LatMin))*6000.0)*0.01,'00.00')"/>
  <xsl:variable name="LongHemi">
    <xsl:choose>
      <xsl:when test="starts-with($LatLong[2],'-')">W</xsl:when>
      <xsl:when test="not(starts-with($LatLong[2],'-'))">E</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="LongDeg" select="format-number(number(functx:substring-after-if-contains(functx:substring-before-if-contains($LatLong[2], '.'),'-')),'000')"/>
  <xsl:variable name="LongDeci" select="functx:substring-after-if-contains($LatLong[2], '.')"/>
  <xsl:variable name="LongMin" select="format-number(floor(number(concat('0.', $LongDeci))*60.0), '00')"/>
  <xsl:variable name="LongSec" select="format-number(round((number(concat('0.', $LongDeci))*60.0 - number($LongMin))*6000.0)*0.01,'00.00')"/>
  <xsl:value-of select="concat($LatDeg, $LatMin, $LatSec, $LatHemi, ' ', $LongDeg, $LongMin, $LongSec, $LongHemi)"/> 
</xsl:function>


</xsl:transform>
