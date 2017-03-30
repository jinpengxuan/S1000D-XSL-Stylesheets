<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="1.0">

  <xsl:template match="dmodule[contains(@xsi:noNamespaceSchemaLocation, 'descript.xsd')]">
    <xsl:element name="chapter">
      <xsl:attribute name="xml:id">
        <xsl:text>ID_</xsl:text>
        <xsl:call-template name="get.dmcode"/>
      </xsl:attribute>
      <xsl:variable name="info.code">
        <xsl:call-template name="get.infocode"/>
      </xsl:variable>
      <xsl:apply-templates select="identAndStatusSection"/>
      <xsl:choose>
        <xsl:when test="$info.code = '001'">
          <!-- title page -->
          <xsl:apply-templates select="content/description"/>
        </xsl:when>
        <xsl:when test="$info.code = '00S'">
          <!-- list of effective data modules -->
          <xsl:call-template name="gen.lodm"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- normal data module -->
          <xsl:call-template name="content.refs"/>
          <xsl:apply-templates select="content/description"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>    
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
