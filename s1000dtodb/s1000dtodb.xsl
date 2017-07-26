<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">
  
  <xsl:param name="date.time"/>
  
  <xsl:param name="want.producedby.blurb">yes</xsl:param>
  
  <xsl:param name="want.inwork.blurb">yes</xsl:param>
  
  <xsl:param name="publication.code">UNKNOWN PUBLICATION</xsl:param>

  <xsl:param name="body.start.indent">20mm</xsl:param>
  
  <xsl:param name="show.unimplemented.markup">1</xsl:param>

  <!-- When generate.references.table = 1, the contents of the References table
       are automatically generated (if the refs element exists, it is ignored). -->
  <xsl:param name="generate.references.table">0</xsl:param>

  <!-- When use.unparsed.entity.uri = 1, the unparsed URI of an ICN entity is
       used to determine the filename. -->
  <xsl:param name="use.unparsed.entity.uri">0</xsl:param>

  <!-- Show / hide the ICN on graphics. -->
  <xsl:param name="show.graphic.icn">1</xsl:param>

  <!-- When external.pub.ref.inline = 'title', externalPubRefs are presented
       using the externalPubTitle.

       When external.pub.ref.inline = 'code', externalPubRefs are presented
       using the externalPubCode. -->
  <xsl:param name="external.pub.ref.inline">title</xsl:param>

  <!-- When these variables = 1 and a project includes a data module
       with their associated info code, the contents are automatically generated. -->
  <!-- 001 Title page -->
  <xsl:param name="generate.title.page">1</xsl:param>
  <!-- 009 Table of contents -->
  <xsl:param name="generate.table.of.contents">1</xsl:param>
  <!-- 00S List of effective data modules -->
  <xsl:param name="generate.list.of.datamodules">1</xsl:param>

  <!-- Include the issue date on the title page content, derived from the issue
       date of the pub module (for auto-generated title page) or from the
       issueDate element of the title page front matter schema (vs. the issue
       date of the title page data module itself, which is displayed in the
       footer). -->
  <xsl:param name="title.page.issue.date">1</xsl:param>

  <!-- When hierarchical.table.of.contents = 1, pmEntryTitles are shown in the
       table of contents with indentation to reflect their level. -->
  <xsl:param name="hierarchical.table.of.contents">0</xsl:param>

  <!-- Indentation for each level on the generated hierarchical table of contents -->
  <xsl:param name="generated.hierarchical.toc.indent">24pt</xsl:param>

  <!-- When show.unclassified = 0, the security classification for 01
       (Unclassified) is not shown in the header/footer. -->
  <xsl:param name="show.unclassified">1</xsl:param>

  <!-- Show 'titled' labelled paras in the table of contents. -->
  <xsl:param name="titled.labelled.para.toc">0</xsl:param>

  <!-- When bookmarks are enabled, also include pmEntry elements in the
       bookmark outline structure. -->
  <xsl:param name="include.pmentry.bookmarks">0</xsl:param>

  <xsl:param name="part.no.prefix">1</xsl:param>

  <xsl:output indent="no" method="xml"/>

  <xsl:include href="crew.xsl"/>
  <xsl:include href="descript.xsl"/>
  <xsl:include href="fault.xsl"/>
  <xsl:include href="proced.xsl"/>
  <xsl:include href="frontmatter.xsl"/>

  <xsl:include href="inlineSignificantData.xsl"/>

  <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="number">0123456789.</xsl:variable>

  <xsl:variable name="all.dmodules" select="//dmodule"/>

  <xsl:template match="/">
    <book>
      <xsl:apply-templates/>
    </book>
  </xsl:template>

  <xsl:template match="publication">
    <xsl:choose>
      <xsl:when test="pm">
        <xsl:apply-templates select="pm"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="dmodule"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>Unhandled: <xsl:call-template name="element.name"/></xsl:message>
    <xsl:if test="$show.unimplemented.markup != 0 and ancestor-or-self::dmodule">
      <fo:block color="red">
        <xsl:apply-templates select="." mode="literal"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="literal">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>=&quot;</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&quot;</xsl:text>
    </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="literal"/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template name="element.name">
    <xsl:for-each select="parent::*">
      <xsl:call-template name="element.name"/>
      <xsl:text>/</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="name()"/>
  </xsl:template>

  <xsl:template match="fo:*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pm">
    <xsl:apply-templates select="content/pmEntry"/>
  </xsl:template>

  <xsl:template match="pmTitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pmEntry">
    <xsl:choose>
      <xsl:when test="$include.pmentry.bookmarks = 0">
        <xsl:apply-templates select="pmEntry|dmRef|dmodule"/>
      </xsl:when>
      <xsl:otherwise>
        <part>
          <xsl:apply-templates select="pmEntryTitle|pmEntry|dmRef|dmodule"/>
        </part>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pmEntryTitle">
    <info>
      <title>
        <xsl:apply-templates/>
      </title>
    </info>
  </xsl:template>

  <xsl:template match="pmEntry/dmRef">
    <xsl:variable name="dm.ref.dm.code">
      <xsl:apply-templates select="dmRefIdent/identExtension"/>
      <xsl:apply-templates select="dmRefIdent/dmCode"/>
    </xsl:variable>
    <xsl:variable name="module.content">
      <xsl:for-each select="$all.dmodules">
        <xsl:variable name="dm.code">
          <xsl:call-template name="get.dmcode"/>
        </xsl:variable>
        <xsl:if test="$dm.ref.dm.code = $dm.code">
          <!--
          <xsl:message>
            <xsl:text>Data module: </xsl:text>
            <xsl:value-of select="$dm.code"/>
          </xsl:message>
          -->
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <!-- FIXME: this test works but isn't efficient -->
      <xsl:when test="normalize-space($module.content)">
        <xsl:copy-of select="$module.content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>PM references unknown DM: </xsl:text>
          <xsl:value-of select="$dm.ref.dm.code"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get.dmcode">
    <xsl:for-each select="ancestor-or-self::dmodule">
      <xsl:apply-templates select="identAndStatusSection/dmAddress/dmIdent/identExtension"/>
      <xsl:apply-templates select="identAndStatusSection/dmAddress/dmIdent/dmCode"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="get.infocode">
    <xsl:for-each select="ancestor-or-self::dmodule">
      <xsl:apply-templates select="identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCode"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="get.dmref.infocode">
    <xsl:apply-templates select="ancestor-or-self::dmRef/dmRefIdent/dmCode/@infoCode"/>
  </xsl:template>

  <xsl:template name="copy.id">
    <xsl:if test="./@id">
      <xsl:variable name="id" select="./@id"/>
      <xsl:attribute name="id">
        <xsl:text>ID_</xsl:text>
        <xsl:call-template name="get.dmcode"/>
        <xsl:text>-</xsl:text>
	      <xsl:value-of select="$id"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dmodule">
    <chapter>
      <xsl:choose>
        <xsl:when test="@xsi:noNamespaceSchemaLocation">
          <title>Unimplemented dmodule: <xsl:value-of select="@xsi:noNamespaceSchemaLocation"/></title>
        </xsl:when>
        <xsl:otherwise>
          <title>Unknown dmodule type</title>
        </xsl:otherwise>
      </xsl:choose>
    </chapter>
  </xsl:template>

  <xsl:template match="techName|infoName">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="get.applicability.string">
    <xsl:choose>
      <xsl:when test="dmStatus/applic/displayText/simplePara">
        <xsl:apply-templates select="dmStatus/applic/displayText/simplePara/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>All</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="identAndStatusSection">
    <xsl:param name="show.producedby.blurb" select="$want.producedby.blurb"/>
    <xsl:variable name="pm" select="(/publication/pm|/pm)"/>
    <info>
      <xsl:variable name="info.code">
        <xsl:call-template name="get.infocode"/>
      </xsl:variable>
      <xsl:variable name="dm.type">
        <xsl:call-template name="get.dm.type"/>
      </xsl:variable>
      <title>
        <xsl:choose>
          <!-- present only infoname of frontmatter data modules -->
          <xsl:when test="$dm.type = 'frontmatter'">
            <xsl:call-template name="info.name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="tech.name"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
      <xsl:if test="$dm.type != 'frontmatter'">
        <subtitle>
          <xsl:call-template name="info.name"/>
        </subtitle>
      </xsl:if>
      <date>
        <xsl:apply-templates select=".//issueDate"/>
      </date>
      <bibliomisc role="publication.title">
        <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmAddressItems/pmTitle/text()"/>
      </bibliomisc>
      <bibliomisc role="publication.author">
        <xsl:apply-templates select="$pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/enterpriseName/text()"/>
      </bibliomisc>
      <bibliomisc role="page.header.logo">
        <xsl:apply-templates select="(dmStatus/logo|$pm/identAndStatusSection/pmStatus/logo)[1]"/>
      </bibliomisc>
      <xsl:if test="number(dmAddress/dmIdent/issueInfo/@inWork) != 0 and $want.inwork.blurb = 'yes'">
        <bibliomisc role="inwork.blurb">
          This is a draft copy of issue <xsl:value-of select="dmAddress/dmIdent/issueInfo/@issueNumber"/>-<xsl:value-of
          select="dmAddress/dmIdent/issueInfo/@inWork"/>.
          <xsl:if test="$date.time != ''">
            Printed <xsl:value-of select="$date.time"/>.
          </xsl:if>
        </bibliomisc>
      </xsl:if>
      <xsl:if test="dmStatus/responsiblePartnerCompany/enterpriseName and $show.producedby.blurb = 'yes'">
        <bibliomisc role="producedby.blurb">
          Produced by: <xsl:value-of select="dmStatus/responsiblePartnerCompany/enterpriseName"/>
        </bibliomisc>
      </xsl:if>
      <xsl:if test="$info.code = '001'">
        <!-- title page -->
        <bibliomisc role="no.chapter.title"/>
      </xsl:if>
      <bibliomisc role="data.module.code">
        <xsl:apply-templates select="dmAddress/dmIdent/dmCode"/>
      </bibliomisc>
      <bibliomisc role="publication.code">
        <xsl:choose>
          <xsl:when test="$pm">
            <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmIdent/pmCode"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$publication.code"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="classification">
        <xsl:choose>
          <xsl:when test="*/security/@securityClassification = '01'">
            <xsl:choose>
              <xsl:when test="$show.unclassified != 0">
                <xsl:text>Unclassified</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&#160;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Classified: </xsl:text>
            <xsl:value-of select="*/security/@securityClassification"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="applicability">
        <xsl:call-template name="get.applicability.string"/>
      </bibliomisc>
    </info>
  </xsl:template>

  <xsl:template name="content.refs">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>

    <!-- Create references table automatically when $generate.references.table = 1 -->
    <xsl:variable name="content" select="content/description|content/procedure"/>

    <xsl:variable name="auth.dm.refs" select="content/refs/dmRef"/>
    <xsl:variable name="auth.ep.refs" select="content/refs/externalPubRef"/>

    <xsl:variable name="auto.dm.refs" select="$content//dmRef"/>
    <xsl:variable name="auto.ep.refs" select="$content//externalPubRef"/>

    <xsl:variable name="gen" select="$generate.references.table"/>

    <xsl:variable name="dm.refs" select="$auth.dm.refs[$gen=0]|$auto.dm.refs[$gen=1]"/>
    <xsl:variable name="ep.refs" select="$auth.ep.refs[$gen=0]|$auto.ep.refs[$gen=1]"/>
    <xsl:variable name="refs" select="$dm.refs|$ep.refs"/>

    <bridgehead renderas="centerhead">References</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>References</title>
      <tgroup cols="2" align="left">
        <thead>
          <row>
            <entry>Data module/Technical publication</entry>
            <entry>Title</entry>
          </row>
        </thead>
        <tbody rowsep="0">
	        <xsl:if test="not($refs)">
	          <row>
	            <entry>None</entry>
	            <entry></entry>
	          </row>
	        </xsl:if>
	        <xsl:for-each select="$dm.refs">
	          <row>
	            <entry><xsl:apply-templates select="."/></entry>
	            <entry>
	              <xsl:if test="dmRefAddressItems/dmTitle">
                  <xsl:apply-templates select="dmRefAddressItems/dmTitle"/>
		              <!--<xsl:apply-templates select="dmRefAddressItems/dmTitle/techName"/>
		              <xsl:if test="dmRefAddressItems/dmTitle/infoName">
		                <xsl:text> - </xsl:text>
		                <xsl:apply-templates select="dmRefAddressItems/dmTitle/infoName"/>
		              </xsl:if>-->
	              </xsl:if>
	            </entry>
	          </row>
	        </xsl:for-each>
	        <xsl:for-each select="$ep.refs">
	          <row>
	            <entry>
	              <xsl:if test="externalPubRefIdent/externalPubCode">
		              <xsl:if test="externalPubRefIdent/externalPubCode/@pubCodingScheme">
		                <xsl:value-of select="externalPubRefIdent/externalPubCode/@pubCodingScheme"/>
		                <xsl:text> </xsl:text>
	                </xsl:if>
		              <xsl:value-of select="externalPubRefIdent/externalPubCode"/>
	              </xsl:if>
	            </entry>
	            <entry>
	              <xsl:if test="externalPubRefIdent/externalPubTitle">
		              <xsl:value-of select="externalPubRefIdent/externalPubTitle"/>
	              </xsl:if>
	            </entry>
	          </row>
	        </xsl:for-each>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="*" mode="number">
    <xsl:number level="any" from="dmodule"/>
  </xsl:template>

  <xsl:template name="labelled.para">
    <xsl:param name="label"/>
    <xsl:param name="content"/>
    <xsl:param name="title"/>
    <xsl:element name="para">
      <xsl:if test="$titled.labelled.para.toc = 1">
        <xsl:attribute name="label"><xsl:value-of select="$label"/></xsl:attribute>
        <xsl:if test="$title">
          <xsl:attribute name="labeltitle"><xsl:value-of select="$title"/></xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <fo:list-block start-indent="0mm" provisional-distance-between-starts="{$body.start.indent}">
        <fo:list-item>
	        <fo:list-item-label start-indent="0mm" end-indent="label-end()" text-align="start">
	          <fo:block>
	            <xsl:copy-of select="$label"/>
	          </fo:block>
	        </fo:list-item-label>
	        <fo:list-item-body start-indent="body-start()">
	          <fo:block>
	            <xsl:copy-of select="$content"/>
	          </fo:block>
	        </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="levelledPara|levelledParaAlts" mode="number">
    <xsl:if test="parent::levelledPara">
      <xsl:apply-templates select="parent::levelledPara" mode="number"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="parent::levelledParaAlts">
        <xsl:apply-templates select="parent::levelledParaAlts" mode="number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="single" count="levelledPara|levelledParaAlts"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="commonInfoDescrPara|commonInfoDescrParaAlts" mode="number">
    <xsl:if test="parent::commonInfoDescrPara">
      <xsl:apply-templates select="parent::commonInfoDescrPara" mode="number"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="parent::commonInfoDescrParaAlts">
        <xsl:apply-templates select="parent::commonInfoDescrParaAlts" mode="number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="single" count="commonInfoDescrPara|commonInfoDescrParaAlts"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="proceduralStep|proceduralStepAlts" mode="number">
    <xsl:if test="parent::proceduralStep">
      <xsl:apply-templates select="parent::proceduralStep" mode="number"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="parent::proceduralStepAlts">
        <xsl:apply-templates select="parent::proceduralStepAlts" mode="number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="single" count="proceduralStep|proceduralStepAlts"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="internalRef">
    <xsl:variable name="id" select="@internalRefId"/>
    <xsl:variable name="target" select="ancestor-or-self::dmodule//*[@id = $id]"/>
    <xsl:variable name="linkend">
      <xsl:text>ID_</xsl:text>
      <xsl:call-template name="get.dmcode"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$id"/>
    </xsl:variable>
    <xsl:choose>
      <!-- 
        special case tables because the numbering of the authored tables doesn't
        start at 1 and we leave it up to the xref processing to work out the correct
        table number
      -->
      <xsl:when test="name($target[1]) = 'table'">
        <xsl:element name="xref">
          <xsl:attribute name="linkend">
            <xsl:value-of select="$linkend"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="link">
          <xsl:attribute name="linkend">
            <xsl:value-of select="$linkend"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="name($target[1]) = 'levelledPara' or name($target[1]) = 'levelledParaAlts' or name($target[1]) = 'commonInfoDescrPara' or name($target[1]) = 'commonInfoDescrParaAlts'">
              <xsl:for-each select="$target">
                <xsl:text>Para&#xA0;</xsl:text>
                <xsl:apply-templates select="." mode="number"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name($target[1]) = 'figure' or name($target[1]) = 'figureAlts'">
              <xsl:for-each select="$target">
                <xsl:text>Fig&#xA0;</xsl:text>
                <xsl:apply-templates select="." mode="number"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name($target[1]) = 'proceduralStep' or name($target[1]) = 'proceduralStepAlts'">
              <xsl:attribute name="xrefstyle">select:nopage</xsl:attribute>
              <xsl:for-each select="$target">
                <xsl:text>Step&#xA0;</xsl:text>
                <xsl:apply-templates select="." mode="number"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="name($target[1]) = 'hotspot'">
              <xsl:for-each select="$target">
                <xsl:text>Fig&#xA0;</xsl:text>
                <xsl:for-each select="parent::*">
                  <xsl:apply-templates select="." mode="number"/>
                </xsl:for-each>
                <xsl:if test="@applicationStructureName">
                  <xsl:text>&#xA0;[</xsl:text>
                  <xsl:value-of select="@applicationStructureName"/>
                  <xsl:text>]</xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="$target/shortName">
              <xsl:apply-templates select="$target/shortName/text()"/>
            </xsl:when>
            <xsl:when test="$target/name">
              <xsl:apply-templates select="$target/name/text()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>Can't generate link target type for: <xsl:value-of select="name($target[1])"/>(<xsl:value-of select="$id"/>)</xsl:message>
              <xsl:value-of select="$id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dmRef">
    <xsl:variable name="dm.ref.dm.code">
      <xsl:apply-templates select="dmRefIdent/identExtension"/>
      <xsl:apply-templates select="dmRefIdent/dmCode"/>
    </xsl:variable>
    <xsl:variable name="link.show" select="behavior/@linkShow"/>
    <xsl:variable name="fragment" select="@referredFragment"/>
    <xsl:variable name="result">
      <xsl:for-each select="$all.dmodules">
        <xsl:variable name="dm.code">
          <xsl:call-template name="get.dmcode"/>
        </xsl:variable>
        <xsl:if test="$dm.ref.dm.code = $dm.code">
          <xsl:choose>
            <xsl:when test="$link.show = 'embedInContext'">
              <xsl:choose>
                <xsl:when test="$fragment">
                  <xsl:apply-templates select=".//*[@id = $fragment]"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="link">
                <xsl:attribute name="linkend">
                  <xsl:value-of select="concat('ID_', $dm.ref.dm.code)"/>
                </xsl:attribute>
                <xsl:value-of select="$dm.ref.dm.code"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$result != ''">
        <xsl:copy-of select="$result"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dm.ref.dm.code"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="identExtension" mode="text">
    <xsl:value-of select="@extensionProducer"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@extensionCode"/>
    <xsl:text>-</xsl:text>
  </xsl:template>

  <xsl:template match="identExtension">
    <xsl:variable name="dm.code">
      <xsl:apply-templates select="../dmCode"/>
    </xsl:variable>
    <xsl:variable name="extension">
      <xsl:apply-templates select="." mode="text"/>
    </xsl:variable>
    <xsl:for-each select="$all.dmodules/identAndStatusSection/dmAddress/dmIdent">
      <xsl:variable name="other.dm.code">
        <xsl:apply-templates select="dmCode"/>
      </xsl:variable>
      <xsl:variable name="other.extension">
        <xsl:apply-templates select="identExtension" mode="text"/>
      </xsl:variable>
      <xsl:if test="$dm.code = $other.dm.code and $extension != $other.extension">
        <xsl:value-of select="$extension"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dmCode">
    <xsl:value-of select="./@modelIdentCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@systemDiffCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@systemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@subSystemCode"/>
    <xsl:value-of select="./@subSubSystemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@assyCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@disassyCode"/>
    <xsl:value-of select="./@disassyCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@infoCode"/>
    <xsl:value-of select="./@infoCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@itemLocationCode"/>
  </xsl:template>

  <xsl:template match="pmCode">
    <xsl:value-of select="./@modelIdentCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmIssuer"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmNumber"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmVolume"/>
  </xsl:template>

  <xsl:template match="externalPubCode">
    <xsl:if test="@pubCodingScheme">
      <xsl:apply-templates select="@pubCodingScheme"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="tech.name">
    <xsl:apply-templates select="dmAddress/dmAddressItems/dmTitle/techName"/>
  </xsl:template>
  
  <xsl:template name="info.name">
    <xsl:apply-templates select="dmAddress/dmAddressItems/dmTitle/infoName"/>
  </xsl:template>
  
  <xsl:template match="issueDate">
    <xsl:value-of select="@year"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@month"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@day"/>
  </xsl:template>

  <xsl:template name="levelled.para.content">
    <xsl:call-template name="make.applic.annotation"/>
    <xsl:call-template name="copy.id"/>
    <xsl:call-template name="revisionflag"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="levelledPara|commonInfoDescrPara">
    <section>
      <xsl:call-template name="make.applic.annotation"/>
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates select="@warningRefs|@cautionRefs"/>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="commonInfo">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <xsl:choose>
      <xsl:when test="title">
        <bridgehead renderas="centerhead"><xsl:value-of select="title"/></bridgehead>
      </xsl:when>
      <xsl:otherwise>
        <bridgehead renderas="centerhead">Common information</bridgehead>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="figure|note|para|commonInfoDescrPara"/>
  </xsl:template>
  
  <xsl:template match="preliminaryRqmts">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Preliminary requirements</bridgehead>
    <xsl:apply-templates select="reqCondGroup"/>
    <xsl:apply-templates select="reqPersons"/>
    <xsl:apply-templates select="reqSupportEquips"/>
    <xsl:apply-templates select="reqSupplies"/>
    <xsl:apply-templates select="reqSpares"/>
    <xsl:apply-templates select="reqSafety"/>
  </xsl:template>

  <xsl:template match="closeRqmts">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Requirements after job completion</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="required.conditions">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Required conditions</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Required conditions</title>
      <tgroup cols="2" align="left">
        <thead>
          <row>
            <entry>Action/Condition</entry>
            <entry>Data module/Technical publication</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:for-each select="*">
            <row>
              <xsl:choose>
                <xsl:when test="name() = 'noConds'">
                  <entry>None</entry>
                  <entry></entry>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="preliminaryRqmts/reqCondGroup">
    <xsl:call-template name="required.conditions"/>
  </xsl:template>

  <xsl:template match="reqCondNoRef">
    <entry><xsl:apply-templates/></entry>
    <entry></entry>
  </xsl:template>
  
  <xsl:template match="reqCondExternalPub">
    <entry><xsl:apply-templates select="reqCond"/></entry>
    <entry><xsl:apply-templates select="externalPubRef"/></entry>
  </xsl:template>

  <xsl:template match="reqCondDm">
    <entry><xsl:apply-templates select="reqCond"/></entry>
    <entry><xsl:apply-templates select="dmRef"/></entry>
  </xsl:template>

  <xsl:template match="reqCond">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="externalPubRef">
    <xsl:choose>
      <xsl:when test="@xlink:href" xmlns:xlink="http://www.w3.org/1999/xlink">
        <xsl:element name="link">
	        <xsl:attribute name="xlink:href">
	          <xsl:value-of select="@xlink:href"/>
	        </xsl:attribute>
	        <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="externalPubRefIdent">
    <xsl:choose>
      <xsl:when test="($external.pub.ref.inline = 'title' and externalPubTitle) or not(externalPubCode)">
        <xsl:apply-templates select="externalPubTitle"/>
      </xsl:when>
      <xsl:when test="($external.pub.ref.inline = 'code' and externalPubCode) or not (externalPubTitle)">
        <xsl:apply-templates select="externalPubCode"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="externalPubTitle">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="estimatedTime">
    <xsl:apply-templates/>
    <xsl:if test="@unitOfMeasure">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@unitOfMeasure"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="reqPersons">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Required persons</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Required persons</title>
      <tgroup cols="5" align="left">
        <thead>
          <row>
            <entry>Person</entry>
            <entry>Category</entry>
            <entry>Skill Level</entry>
            <entry>Trade/Trade code</entry>
            <entry>Estimated time</entry>
          </row>
        </thead>
        <tbody rowsep="0">
	  <xsl:choose>
	    <xsl:when test="person|personnel">
	      <xsl:for-each select="person">
	        <row>
		  <entry><xsl:text>Man </xsl:text><xsl:value-of select="@man"/></entry>
		  <entry><xsl:value-of select="personCategory/@personCategoryCode"/></entry>
		  <entry><xsl:apply-templates select="personSkill/@skillLevelCode"/></entry>
		  <entry><xsl:value-of select="trade"/></entry>
		  <entry><xsl:apply-templates select="estimatedTime"/></entry>
	        </row>
	      </xsl:for-each>
	      <xsl:for-each select="personnel">
	        <xsl:choose>
		  <xsl:when test="*">
		    <row>
		      <entry>As required</entry>
		      <entry><xsl:value-of select="personCategory/@personCategoryCode"/></entry>
		      <entry>
		        <xsl:apply-templates select="personSkill/@skillLevelCode"/>
		        <xsl:if test="@numRequired">
			  <xsl:text> (</xsl:text>
			    <xsl:value-of select="@numRequired"/>
			  <xsl:text>)</xsl:text>
		        </xsl:if>
		      </entry>
		      <entry><xsl:value-of select="trade"/></entry>
		      <entry><xsl:apply-templates select="estimatedTime"/></entry>
		    </row>
		  </xsl:when>
		  <xsl:otherwise>
		    <row>
		      <entry>As required</entry>
		    </row>
		  </xsl:otherwise>
	        </xsl:choose>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:otherwise>
	      <row>
	        <entry>As required</entry>
	      </row>
	    </xsl:otherwise>
	  </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqQuantity">
    <xsl:apply-templates/>
    <xsl:if test="@unitOfMeasure != 'EA'">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@unitOfMeasure"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="identNumber">
    <xsl:if test="manufacturerCode != ''">
      <xsl:if test="$part.no.prefix != 0 and partAndSerialNumber/partNumber">
        <xsl:text>Part No. </xsl:text>
      </xsl:if>
      <xsl:value-of select="manufacturerCode"/>
      <xsl:if test="partAndSerialNumber/partNumber">
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:value-of select="partAndSerialNumber/partNumber"/>
  </xsl:template>

  <xsl:template match="remarks">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="reqSupportEquips">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Support equipment</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Support equipment</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSupportEquips or not(supportEquipDescrGroup/supportEquipDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="supportEquipDescrGroup/supportEquipDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
		  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
            <xsl:text>ID_</xsl:text>
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|toolRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSupplies">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Consumables, materials and expendables</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Consumables, materials and expendables</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSupplies or not(supplyDescrGroup/supplyDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="supplyDescrGroup/supplyDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
                  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
            <xsl:text>ID_</xsl:text>
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|supplyRqmtRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSpares">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Spares</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Spares</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSpares or not(spareDescrGroup/spareDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="spareDescrGroup/spareDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
                  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
            <xsl:text>ID_</xsl:text>
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|functionalItemRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSafety">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Safety conditions</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="noSafety">
    <para>
      <xsl:text>None</xsl:text>
    </para>
  </xsl:template>

  <xsl:template match="safetyRqmts">
    <xsl:apply-templates select="@warningRefs|@cautionRefs"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="warning|caution|note">
    <xsl:call-template name="make.applic.annotation"/>
    <xsl:element name="{name()}">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="para|warningAndCautionPara|notePara|simplePara|attentionListItemPara">
    <xsl:element name="para">
      <xsl:call-template name="make.applic.annotation"/>
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:element name="figure">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:attribute name="label">
	      <xsl:number level="any" from="dmodule"/>
      </xsl:attribute>
      <xsl:attribute name="pgwide">1</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <xsl:template name="make.imageobject" xmlns:ier="InfoEntityResolver">
    <xsl:variable name="entity" select="@infoEntityIdent"/>
    <xsl:variable name="fileref">
      <xsl:choose>
        <xsl:when test="function-available('ier:resolve')">
	        <xsl:value-of select="ier:resolve($entity)"/>
        </xsl:when>
        <xsl:when test="$use.unparsed.entity.uri = 1">
          <xsl:value-of select="unparsed-entity-uri($entity)"/>
        </xsl:when>
        <xsl:otherwise>
	        <xsl:value-of select="$entity"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--
    <xsl:message>    Graphic: <xsl:value-of select="$entity"/></xsl:message>
    <xsl:if test="$fileref != $entity">
      <xsl:message>         Is: <xsl:value-of select="$fileref"/></xsl:message>
    </xsl:if>
    -->
    <imageobject xsl:exclude-result-prefixes="ier">
      <xsl:element name="imagedata">
        <xsl:attribute name="align">center</xsl:attribute>
        <xsl:attribute name="fileref">
	        <xsl:value-of select="$fileref"/>
        </xsl:attribute>
        <xsl:if test="@reproductionWidth">
	        <xsl:attribute name="width">
	          <xsl:value-of select="@reproductionWidth"/>
	        </xsl:attribute>
	        <xsl:attribute name="contentwidth">
	          <xsl:value-of select="@reproductionWidth"/>
	        </xsl:attribute>
        </xsl:if>
        <xsl:if test="@reproductionHeight">
	        <xsl:attribute name="depth">
	          <xsl:value-of select="@reproductionHeight"/>
	        </xsl:attribute>
	        <xsl:attribute name="contentdepth">
	          <xsl:value-of select="@reproductionHeight"/>
	        </xsl:attribute>
        </xsl:if>
        <xsl:if test="@reproductionScale">
          <xsl:attribute name="scale">
            <xsl:value-of select="@reproductionScale"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@reproductionWidth) and not(@reproductionHeight) and not(@reproductionScale)">
          <xsl:attribute name="scalefit">1</xsl:attribute>
        </xsl:if>
      </xsl:element>
    </imageobject>
  </xsl:template>

  <xsl:template match="graphic">
    <xsl:param name="show.icn" select="$show.graphic.icn"/>
    <mediaobject>
      <xsl:call-template name="make.imageobject"/>
    </mediaobject>
    <xsl:if test="$show.icn = 1">
      <caption>
        <para><xsl:value-of select="@infoEntityIdent"/></para>
      </caption>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="symbol|barCodeSymbol">
    <inlinemediaobject>
      <xsl:call-template name="make.imageobject"/>
    </inlinemediaobject>
  </xsl:template>

  <xsl:template match="hotspot">
    <xsl:element name="anchor">
      <xsl:call-template name="copy.id"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="logo">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="randomList|attentionRandomList">
    <xsl:element name="itemizedlist">
      <xsl:call-template name="revisionflag"/>
      <xsl:if test="@listItemPrefix = 'pf01'">
        <!-- "simple list" -->
        <xsl:attribute name="mark">
	  <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sequentialList|attentionSequentialList">
    <xsl:element name="orderedlist">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definitionList">
    <xsl:element name="variablelist">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="definitionListHeader|definitionListItem">
    <xsl:element name="varlistentry">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="termTitle">
    <xsl:element name="term">
      <xsl:call-template name="revisionflag"/>    
      <emphasis role="bold">
        <emphasis role="underline">
	  <xsl:apply-templates/>
        </emphasis>
      </emphasis>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definitionTitle">
    <xsl:element name="listitem">
      <xsl:call-template name="revisionflag"/>
      <emphasis role="bold">
        <emphasis role="underline">
	  <xsl:apply-templates/>
        </emphasis>
      </emphasis>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="listItemTerm">
    <xsl:element name="term">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="listItem|listItemDefinition|attentionSequentialListItem|attentionRandomListItem">
    <xsl:element name="listitem">
      <xsl:call-template name="make.applic.annotation"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:variable name="table-type">
      <xsl:choose>
        <xsl:when test="title">table</xsl:when>
        <xsl:otherwise>informaltable</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$table-type}">
      <xsl:call-template name="copy.id"/>
      <xsl:if test="descendant-or-self::*[@changeMark = '1']">
        <xsl:call-template name="revisionflag">
          <xsl:with-param name="change.mark">1</xsl:with-param>
          <!-- there could be multiple modifications of differing types so lets just mark the table as modified -->
          <xsl:with-param name="change.type">modify</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <!-- Default values of attributes -->
      <xsl:if test="not(@colsep)">
        <xsl:attribute name="colsep">0</xsl:attribute>
      </xsl:if>
      <xsl:if test="not(@frame)">
        <xsl:attribute name="frame">topbot</xsl:attribute>
      </xsl:if>
      <xsl:for-each select="@*">
        <xsl:if test="name(.) != 'id'">
	  <xsl:copy/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tbody">
    <xsl:element name="tbody">
      <xsl:if test="not(@rowsep|ancestor::table/@rowsep)">
        <xsl:attribute name="rowsep">0</xsl:attribute>
      </xsl:if>
      <xsl:for-each select="@*">
	      <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tgroup|thead|colspec|row|entry">
    <xsl:element name="{name()}">
      <xsl:call-template name="copy.id"/>
      <xsl:if test="name(.) = 'thead' and not(@rowsep|ancestor::table/@rowsep)">
        <xsl:attribute name="rowsep">1</xsl:attribute>
      </xsl:if>
      <xsl:for-each select="@*">
        <xsl:choose>
	        <xsl:when test="name(.) = 'id'">
	          <!-- ignore it -->
	        </xsl:when>
	        <xsl:when test="name(.) = 'colwidth' and string(number(.))!='NaN'">
	          <!-- colwidth is just a plain number so suffix with '*' -->
	          <xsl:attribute name="colwidth">
	            <xsl:value-of select="."/>
	            <xsl:text>*</xsl:text>
	          </xsl:attribute>
	        </xsl:when>
	        <xsl:otherwise>
	          <xsl:copy/>
	        </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates select="@warningRefs|@cautionRefs"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="emphasis">
    <xsl:element name="emphasis">
      <xsl:attribute name="role">
        <xsl:choose>
          <xsl:when test="@emphasisType = 'em02'">italic</xsl:when>
          <xsl:when test="@emphasisType = 'em03'">underline</xsl:when>
          <xsl:when test="@emphasisType = 'em05'">strikethrough</xsl:when>
          <xsl:otherwise>bold</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="verbatimText">
    <xsl:choose>
      <xsl:when test="not(@verbatimStyle)">
        <literal><xsl:apply-templates/></literal>
      </xsl:when>
      <xsl:when test="@verbatimStyle = 'vs11'">
        <programlisting><xsl:apply-templates/></programlisting>
      </xsl:when>
      <xsl:when test="@verbatimStyle = 'vs23'">
        <screen><xsl:apply-templates/></screen>
      </xsl:when>
      <xsl:when test="@verbatimStyle = 'vs24'">
        <programlisting><xsl:apply-templates/></programlisting>
      </xsl:when>
      <xsl:otherwise>
        <literal><xsl:apply-templates/></literal>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="footnote">
    <xsl:element name="footnote">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="subScript">
    <subscript><xsl:apply-templates/></subscript>
  </xsl:template>

  <xsl:template match="superScript">
    <superscript><xsl:apply-templates/></superscript>
  </xsl:template>

  <xsl:template name="revisionflag">
    <xsl:param name="change.mark">
      <xsl:value-of select="@changeMark"/>
    </xsl:param>
    <xsl:param name="change.type">
      <xsl:value-of select="@changeType"/>
    </xsl:param>
    <xsl:if test="$change.mark = '1'">
      <xsl:attribute name="revisionflag">
        <xsl:choose>
	  <xsl:when test="$change.type = 'add'">
	    <xsl:text>added</xsl:text>
	  </xsl:when>
	  <xsl:when test="$change.type = 'delete'">
	    <xsl:text>deleted</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>changed</xsl:text>
	  </xsl:otherwise>      
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="changeInline">
    <xsl:element name="phrase">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- Associate certain info codes with 'types' of data modules -->
  <xsl:template name="get.dm.type">
    <xsl:variable name="info.code">
      <xsl:choose>
        <!-- if this is inside a dmRef, we want the info code of the referenced dm -->
        <xsl:when test="ancestor-or-self::dmRef">
          <xsl:call-template name="get.dmref.infocode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="get.infocode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$info.code = '001' or $info.code = '009' or $info.code = '00S'">frontmatter</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dmTitle">
    <!-- present only infoname as title for frontmatter data modules -->
    <xsl:variable name="dm.type">
      <xsl:call-template name="get.dm.type"/>
    </xsl:variable>

    <xsl:if test="not($dm.type = 'frontmatter')">
      <xsl:apply-templates select="techName"/>
    </xsl:if>

    <xsl:if test="infoName">
      <xsl:if test="not($dm.type = 'frontmatter')">
        <xsl:text> - </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="infoName"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="gen.lodm">
    <xsl:variable name="pm" select="(/publication/pm|/pm)"/>
    <para>The listed documents are included in issue
      <xsl:value-of select="$pm/identAndStatusSection/pmAddress/pmIdent/issueInfo/@issueNumber"/>, dated
      <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmAddressItems/issueDate"/>, of this publication.
    </para>
    <para>C = Changed data module</para>
    <para>N = New data module</para>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="6" align="left">
        <colspec colnum="3" colwidth="1.5em" align="center"/>
        <colspec colnum="4" colwidth="6em"/>
        <colspec colnum="5" colwidth="4em"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Data module code</entry>
            <entry></entry>
            <entry>Issue date</entry>
            <entry>No. of pages</entry>
            <entry>Applicable to</entry>
          </row>
        </thead>
        <tbody>
	        <xsl:if test="not($pm/content/pmEntry//dmRef)">
	          <row>
	            <entry>None</entry>
	          </row>
	        </xsl:if>
          <xsl:apply-templates select="$pm/content/pmEntry" mode="lodm"/>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="dmRef" mode="lodm">
    <xsl:variable name="dm.ref.dm.code">
      <xsl:apply-templates select="dmRefIdent/dmCode"/>
    </xsl:variable>
    <xsl:for-each select="$all.dmodules">
      <xsl:variable name="dm.code">
        <xsl:call-template name="get.dmcode"/>
      </xsl:variable>
      <xsl:if test="$dm.ref.dm.code = $dm.code">
        <row>
          <entry>
            <xsl:apply-templates select="identAndStatusSection//dmTitle"/>
          </entry>
          <entry>
            <xsl:element name="link">
              <xsl:attribute name="linkend">
                <xsl:text>ID_</xsl:text>
                <xsl:call-template name="get.dmcode"/>
              </xsl:attribute>
              <xsl:call-template name="get.dmcode"/>
            </xsl:element>
          </entry>
          <entry>
            <xsl:choose>
              <xsl:when test="identAndStatusSection/dmStatus/@issueType='new'">
                <xsl:text>N</xsl:text>
              </xsl:when>
              <xsl:when test="identAndStatusSection/dmStatus/@issueType='changed'">
                <xsl:text>C</xsl:text>
              </xsl:when>
            </xsl:choose>
          </entry>
          <entry>
            <xsl:apply-templates select="identAndStatusSection/dmAddress/dmAddressItems/issueDate"/>
          </entry>
          <entry>
            <para>
              <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
            </para>
          </entry>
          <entry>
            <xsl:for-each select="identAndStatusSection">
              <xsl:call-template name="get.applicability.string"/>
            </xsl:for-each>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dmodule" mode="lodm">
    <xsl:variable name="dm.code">
      <xsl:call-template name="get.dmcode"/>
    </xsl:variable>
    <row>
      <entry>
        <xsl:apply-templates select="identAndStatusSection//dmTitle"/>
      </entry>
      <entry>
        <xsl:element name="link">
          <xsl:attribute name="linkend">
            <xsl:text>ID_</xsl:text>
            <xsl:call-template name="get.dmcode"/>
          </xsl:attribute>
          <xsl:call-template name="get.dmcode"/>
        </xsl:element>
      </entry>
      <entry>
        <xsl:choose>
          <xsl:when test="identAndStatusSection/dmStatus/@issueType='new'">
            <xsl:text>N</xsl:text>
          </xsl:when>
          <xsl:when test="identAndStatusSection/dmStatus/@issueType='changed'">
            <xsl:text>C</xsl:text>
          </xsl:when>
        </xsl:choose>
      </entry>
      <entry>
        <xsl:apply-templates select="identAndStatusSection/dmAddress/dmAddressItems/issueDate"/>
      </entry>
      <entry>
        <para>
          <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
        </para>
      </entry>
      <entry>
        <xsl:for-each select="identAndStatusSection">
          <xsl:call-template name="get.applicability.string"/>
        </xsl:for-each>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="pmEntry" mode="lodm">
    <xsl:apply-templates select="pmEntry|dmRef|dmodule" mode="lodm"/>
  </xsl:template>

  <xsl:template name="table.of.content">
    <xsl:choose>
      <xsl:when test="reducedPara">
        <xsl:apply-templates select="reducedPara"/>
      </xsl:when>
      <xsl:otherwise>
        <para>
          <xsl:text>The listed documents are included in issue </xsl:text>
          <xsl:value-of select="issueInfo/@issueNumber"/>
          <xsl:text>, dated </xsl:text>
          <xsl:apply-templates select="issueDate"/>
          <xsl:text>, of this publication.</xsl:text>
        </para>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="tocList"/>
  </xsl:template>

  <xsl:template match="tocList">
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="5" align="left">
        <colspec colname="c1"/>
        <colspec colname="c2"/>
        <colspec colname="c3" colwidth="6em"/>
        <colspec colname="c4" colwidth="4em"/>
        <colspec colname="c5"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Document identifier</entry>
            <entry>Issue date</entry>
            <entry>No. of pages</entry>
            <entry>Applicable to</entry>
          </row>
        </thead>
        <tbody>
          <xsl:apply-templates select="tocEntry" mode="toc"/>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="tocEntry" mode="toc">
    <xsl:choose>
      <xsl:when test="$hierarchical.table.of.contents = 1">
        <xsl:apply-templates select="title|tocEntry|dmRef" mode="toc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="tocEntry|dmRef" mode="toc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="gen.toc">
    <xsl:variable name="pm" select="(/publication/pm|/pm)"/>
    <para>
      <xsl:text>The listed documents are included in issue </xsl:text>
      <xsl:value-of select="$pm/identAndStatusSection/pmAddress/pmIdent/issueInfo/@issueNumber"/>
      <xsl:text>, dated </xsl:text>
      <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmAddressItems/issueDate"/>
      <xsl:text>, of this publication.</xsl:text>
    </para>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="5" align="left">
        <colspec colname="c1"/>
        <colspec colname="c2"/>
        <colspec colname="c3" colwidth="6em"/>
        <colspec colname="c4" colwidth="4em"/>
        <colspec colname="c5"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Document identifier</entry>
            <entry>Issue date</entry>
            <entry>No. of pages</entry>
            <entry>Applicable to</entry>
          </row>
        </thead>
        <tbody>
          <xsl:if test="not($pm/content/pmEntry//dmRef|$pm/content/pmEntry//dmodule)">
            <row>
              <entry>None</entry>
            </row>
          </xsl:if>
          <xsl:apply-templates select="$pm/content/pmEntry" mode="toc"/>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="dmRef" mode="toc">
    <xsl:variable name="dm.ref.dm.code">
      <xsl:apply-templates select="dmRefIdent/dmCode"/>
    </xsl:variable>
    <xsl:for-each select="$all.dmodules">
      <xsl:variable name="dm.code">
        <xsl:call-template name="get.dmcode"/>
      </xsl:variable>
      <xsl:if test="$dm.ref.dm.code = $dm.code">
        <row>
          <entry>
            <xsl:apply-templates select="identAndStatusSection//dmTitle"/>
          </entry>
          <entry>
            <link>
              <xsl:attribute name="linkend">
                <xsl:text>ID_</xsl:text>
                <xsl:call-template name="get.dmcode"/>
              </xsl:attribute>
              <xsl:call-template name="get.dmcode"/>
            </link>
          </entry>
          <entry>
            <xsl:apply-templates select="identAndStatusSection/dmAddress/dmAddressItems/issueDate"/>
          </entry>
          <entry>
            <para>
              <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
            </para>
          </entry>
          <entry>
            <xsl:for-each select="identAndStatusSection">
              <xsl:call-template name="get.applicability.string"/>
            </xsl:for-each>
          </entry>
        </row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dmodule" mode="toc">
    <xsl:variable name="dm.code">
      <xsl:call-template name="get.dmcode"/>
    </xsl:variable>
    <row>
      <entry>
        <xsl:apply-templates select="identAndStatusSection//dmTitle"/>
      </entry>
      <entry>
        <link>
          <xsl:attribute name="linkend">
            <xsl:text>ID_</xsl:text>
            <xsl:call-template name="get.dmcode"/>
          </xsl:attribute>
          <xsl:call-template name="get.dmcode"/>
        </link>
      </entry>
      <entry>
        <xsl:apply-templates select="identAndStatusSection/dmAddress/dmAddressItems/issueDate"/>
      </entry>
      <entry>
        <para>
          <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
        </para>
      </entry>
      <entry>
        <xsl:for-each select="identAndStatusSection">
          <xsl:call-template name="get.applicability.string"/>
        </xsl:for-each>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="pmEntry" mode="toc">
    <xsl:choose>
      <xsl:when test="$hierarchical.table.of.contents = 1">
        <xsl:apply-templates mode="toc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="pmEntry|dmRef|dmodule" mode="toc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="title.page">
    <xsl:param name="productIntroName" select="productIntroName"/>
    <xsl:param name="pmTitle" select="pmTitle"/>
    <xsl:param name="shortPmTitle" select="shortPmTitle"/>
    <xsl:param name="pmCode" select="pmCode"/>
    <xsl:param name="issueInfo" select="issueInfo"/>
    <xsl:param name="issueDate" select="issueDate"/>
    <xsl:param name="productAndModel" select="productAndModel"/>
    <xsl:param name="dataRestrictions" select="dataRestrictions"/>
    <xsl:param name="productIllustration" select="productIllustration"/>
    <xsl:param name="responsiblePartnerCompany" select="responsiblePartnerCompany"/>
    <xsl:param name="publisherLogo" select="publisherLogo"/>
    <xsl:param name="enterpriseSpec" select="enterpriseSpec"/>
    <xsl:param name="enterpriseLogo" select="enterpriseLogo"/>
    <xsl:param name="frontMatterInfo" select="frontMatterInfo"/>
    <xsl:param name="barCode" select="barCode"/>
    <xsl:variable name="policyStatement" select="$dataRestrictions/policyStatement"/>
    <xsl:variable name="dataConds" select="$dataRestrictions/dataConds"/>
    <fo:block start-indent="0pt">
      <fo:block font-weight="bold">
        <fo:block-container height="25mm">
          <fo:block font-size="18pt">
            <xsl:apply-templates select="$productIntroName"/>
            <xsl:apply-templates select="$productAndModel"/>
          </fo:block>
        </fo:block-container>
        <fo:block-container height="40mm">
          <fo:block font-size="24pt">
            <xsl:apply-templates select="$pmTitle"/>
          </fo:block>
          <fo:block font-size="14pt">
            <xsl:apply-templates select="$shortPmTitle"/>
          </fo:block>
        </fo:block-container>
        <fo:block-container height="21pt">
          <fo:block font-size="14pt">
            <xsl:apply-templates select="$pmCode"/>
          </fo:block>
        </fo:block-container>
        <fo:block-container height="21pt">
          <xsl:call-template name="title.page.issue">
            <xsl:with-param name="issueInfo" select="$issueInfo"/>
            <xsl:with-param name="issueDate" select="$issueDate"/>
          </xsl:call-template>
        </fo:block-container>
      </fo:block>
      <fo:block-container height="60mm">
        <fo:block space-before="16pt">
          <xsl:apply-templates select="$productIllustration"/>
        </fo:block>
      </fo:block-container>
      <fo:block font-size="8pt">
        <fo:block-container height="30mm">
          <fo:block>
            <xsl:apply-templates select="$dataRestrictions/restrictionInfo/copyright"/>
          </fo:block>
        </fo:block-container>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block-container height="20mm">
                  <xsl:call-template name="logo.and.company">
                    <xsl:with-param name="title">Publisher:</xsl:with-param>
                    <xsl:with-param name="logo" select="$publisherLogo"/>
                    <xsl:with-param name="company" select="$responsiblePartnerCompany"/>
                  </xsl:call-template>
                </fo:block-container>
                <fo:block-container height="15mm">
                  <fo:block>
                    <xsl:if test="enterpriseSpec">
                      <xsl:call-template name="logo.and.company">
                        <xsl:with-param name="title">Manufacturer:</xsl:with-param>
                        <xsl:with-param name="logo" select="$enterpriseLogo"/>
                        <xsl:with-param name="company" select="$enterpriseSpec"/>
                      </xsl:call-template>
                    </xsl:if>
                  </fo:block>
                </fo:block-container>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block-container height="35mm" display-align="after">
                  <fo:block text-align="right">
                    <xsl:apply-templates select="$barCode/barCodeSymbol"/>
                  </fo:block>
                </fo:block-container>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
        <xsl:if test="$policyStatement or $dataConds or $frontMatterInfo">
          <fo:block page-break-before="always">
            <xsl:apply-templates select="$policyStatement"/>
            <xsl:apply-templates select="$dataConds"/>
            <xsl:apply-templates select="$frontMatterInfo"/>
          </fo:block>
        </xsl:if>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template name="logo.and.company">
    <xsl:param name="title"/>
    <xsl:param name="logo"/>
    <xsl:param name="company"/>
    <fo:block>
      <fo:block>
        <xsl:value-of select="$title"/>
      </fo:block>
      <fo:block>
        <xsl:if test="$logo">
          <fo:inline padding-right="4mm">
            <xsl:apply-templates select="$logo/symbol"/>
          </fo:inline>
        </xsl:if>
        <fo:inline vertical-align="top">
          <xsl:value-of select="$company/enterpriseName"/>
        </fo:inline>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template name="title.page.issue">
    <xsl:param name="issueInfo"/>
    <xsl:param name="issueDate"/>
    <fo:block space-before="8pt" font-size="14pt">
      <xsl:text>Issue No. </xsl:text>
      <xsl:value-of select="$issueInfo/@issueNumber"/>
      <xsl:if test="$issueDate and $title.page.issue.date != 0">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="$issueDate"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template name="gen.title.page">
    <xsl:variable name="pm" select="(/publication/pm|/pm)"/>
    <xsl:call-template name="title.page">
      <xsl:with-param name="pmTitle" select="$pm//pmTitle"/>
      <xsl:with-param name="shortPmTitle" select="$pm//shortPmTitle"/>
      <xsl:with-param name="pmCode" select="$pm//pmCode"/>
      <xsl:with-param name="issueInfo" select="$pm//pmIdent/issueInfo"/>
      <xsl:with-param name="issueDate" select="$pm//pmAddressItems/issueDate"/>
      <xsl:with-param name="dataRestrictions" select="$pm//pmStatus/dataRestrictions"/>
      <xsl:with-param name="responsiblePartnerCompany" select="$pm//pmStatus/responsiblePartnerCompany"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="shortPmTitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="restrictionInfo">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="copyright">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="copyrightPara">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="policyStatement">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="dataConds">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="frontMatterInfo">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="reducedPara">
    <para>
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template name="get.measurement.value">
    <xsl:param name="measurement"/>
    <xsl:value-of select="translate(translate($measurement, $lower, ''), $upper, '')"/>
  </xsl:template>

  <xsl:template name="get.measurement.unit">
    <xsl:param name="measurement"/>
    <xsl:value-of select="translate($measurement, $number, '')"/>
  </xsl:template>

  <xsl:template match="pmEntryTitle|title" mode="toc">
    <xsl:variable name="level" select="count(ancestor::pmEntry) - 1"/>
    
    <xsl:variable name="indent.value">
      <xsl:call-template name="get.measurement.value">
        <xsl:with-param name="measurement" select="$generated.hierarchical.toc.indent"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="indent.unit">
      <xsl:call-template name="get.measurement.unit">
        <xsl:with-param name="measurement" select="$generated.hierarchical.toc.indent"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="indent" select="concat($indent.value * $level, $indent.unit)"/>

    <row>
      <entry namest="c1" nameend="c5">
        <fo:inline font-weight="bold" padding-left="{$indent}">
          <xsl:apply-templates/>
        </fo:inline>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="@applicRefId">
    <xsl:variable name="id" select="."/>
    <xsl:apply-templates select="ancestor::content/referencedApplicGroup/applic[@id=$id]"/>
  </xsl:template>

  <xsl:template match="applic">
    <fo:block font-weight="bold" font-size="10pt">
      <xsl:text>Applicable to: </xsl:text>
      <xsl:choose>
        <xsl:when test="displayText">
          <xsl:apply-templates select="displayText/simplePara/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="assert|evaluate"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template match="assert">
    <xsl:value-of select="@applicPropertyIdent"/>
    <xsl:text> = </xsl:text>
    <xsl:value-of select="@applicPropertyValues"/>
  </xsl:template>

  <xsl:template match="evaluate">
    <xsl:variable name="op" select="@andOr"/>
    <xsl:for-each select="assert|evaluate">
      <xsl:apply-templates select="."/>
      <xsl:if test="position() != last()">
        <xsl:text> </xsl:text>
        <xsl:value-of select="$op"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="make.applic.annotation">
    <xsl:variable name="this.applic" select="@applicRefId"/>
    <xsl:variable name="parent.applic" select="ancestor::*[@applicRefId][1]/@applicRefId"/>
    <xsl:variable name="preced.applic" select="preceding-sibling::*[@applicRefId][1]/@applicRefId"/>

    <xsl:variable name="dm.applic" select="ancestor::dmodule/identAndStatusSection/dmStatus/applic"/>

    <!-- If this element has no applic annotation and its preceding sibling has different applic than both elements' parent,
         show the parent's applic annotation to clarify the applicability -->
    <xsl:if test="not($this.applic) and $preced.applic">
      <xsl:if test="not($parent.applic)">
        <xsl:if test="preceding-sibling::*[1]/descendant-or-self::*[@applicRefId]">
          <xsl:apply-templates select="$dm.applic"/>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="$parent.applic"/>
    </xsl:if>

    <!-- If the applic of the preceding sibling is the same, don't repeat the applicability annotation -->
    <xsl:if test="not($preced.applic) or $preced.applic != $this.applic">
      <xsl:apply-templates select="$this.applic"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="levelledParaAlts|proceduralStepAlts|figureAlts">
    <fo:block keep-with-next="always">
      <xsl:call-template name="copy.id"/>
    </fo:block>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="functionalItemRef">
    <xsl:choose>
      <xsl:when test="shortName">
        <xsl:apply-templates select="shortName"/>
      </xsl:when>
      <xsl:when test="name">
        <xsl:apply-templates select="name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@functionalItemNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="name">
    <para>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template match="shortName">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="apply.delimited.id.refs">
    <xsl:param name="refs"/>
    <xsl:param name="delim" select="' '"/>

    <xsl:variable name="before" select="substring-before($refs, $delim)"/>

    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="$before != ''">
          <xsl:value-of select="$before"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$refs"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="after" select="substring-after($refs, $delim)"/>

    <xsl:apply-templates select="//*[@id=$id]"/>

    <xsl:if test="$after != ''">
      <xsl:call-template name="apply.delimited.id.refs">
        <xsl:with-param name="ids" select="$after"/>
        <xsl:with-param name="delim" select="$delim"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@warningRefs|@cautionRefs">
    <xsl:call-template name="apply.delimited.id.refs">
      <xsl:with-param name="refs" select="."/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
