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
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  version="1.0">
  
  <!-- When set, adds the "Printed $date.time" statement to the left margin. -->
  <xsl:param name="date.time"/>
  
  <!-- When "yes", show the "Produced by" statement. -->
  <xsl:param name="want.producedby.blurb">yes</xsl:param>

  <!-- Set the "Produced by" blurb for the whole publication rather than
       deriving it invididually from each data module, when the blurb is used
       to indicate the entity responsible for printing the page-oriented output
       rather than maintaining the data module. -->
  <xsl:param name="producedby.blurb"/>

  <!-- Include the "Produced by" blurb on the title page. -->
  <xsl:param name="producedby.blurb.on.titlepage">1</xsl:param>

  <!-- Text before "Produced by" blurb -->
  <xsl:param name="producedby.blurb.before">Produced by: </xsl:param>

  <!-- Optional country where the page-oriented output was printed. -->
  <xsl:param name="printedin.blurb"/>

  <!-- Text before "Printed in" blurb -->
  <xsl:param name="printedin.blurb.before">. Printed in </xsl:param>
  
  <xsl:param name="want.inwork.blurb">yes</xsl:param>
  
  <xsl:param name="publication.code"></xsl:param>

  <xsl:param name="body.start.indent">20mm</xsl:param>
  
  <xsl:param name="show.unimplemented.markup">1</xsl:param>

  <!-- When use.unparsed.entity.uri = 1, the unparsed URI of an ICN entity is
       used to determine the filename if the InfoEntityResolver is not available. -->
  <xsl:param name="use.unparsed.entity.uri">1</xsl:param>

  <!-- Show / hide the ICN on graphics. -->
  <xsl:param name="show.graphic.icn">1</xsl:param>

  <!-- When external.pub.ref.inline = 'title', externalPubRefs are presented
       using the externalPubTitle.

       When external.pub.ref.inline = 'code', externalPubRefs are presented
       using the externalPubCode. -->
  <xsl:param name="external.pub.ref.inline">title</xsl:param>

  <!-- When these variables = 1 and a project includes a descriptive data module
       with their associated info code, the contents are automatically generated. -->
  <!-- 001 Title page -->
  <xsl:param name="generate.title.page">1</xsl:param>
  <!-- 009 Table of contents -->
  <xsl:param name="generate.table.of.contents">1</xsl:param>
  <!-- 00A List of illustrations -->
  <xsl:param name="generate.list.of.illustrations">1</xsl:param>
  <!-- 00S List of effective data modules -->
  <xsl:param name="generate.list.of.datamodules">1</xsl:param>
  <!-- 00U Highlights -->
  <xsl:param name="generate.highlights">1</xsl:param>
  <!-- 00Z List of tables -->
  <xsl:param name="generate.list.of.tables">1</xsl:param>
  <!-- 014 Alphabetical and alphanumeric index -->
  <xsl:param name="generate.index">0</xsl:param>

  <!-- The type of index to generate.

       table    Creates a tabular index with data module references.

       docbook  Uses the built-in DocBook index generator with page number
                references. -->
  <xsl:param name="index.type">table</xsl:param>

  <!-- Include an index section for each data module -->
  <xsl:param name="data.module.index">0</xsl:param>

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
  <xsl:param name="titled.labelled.para.toc">1</xsl:param>

  <!-- When bookmarks are enabled, also include pmEntry elements in the
       bookmark outline structure. -->
  <xsl:param name="include.pmentry.bookmarks">0</xsl:param>

  <!-- Include the "Part No." prefix on identNumber -->
  <xsl:param name="part.no.prefix">1</xsl:param>

  <!-- Whether and how to include the acronym definition.

       no    Only show the acronym term.

       before    This is a Data Module Code (DMC)
                           ^^^^^^^^^^^^^^^^^^^^^^

       after     This is a DMC (Data Module Code)
                           ^^^^^^^^^^^^^^^^^^^^^^
  -->
  <xsl:param name="auto.expand.acronyms">no</xsl:param>

  <!-- Width of the term column in a definition list. -->
  <xsl:param name="definition.list.term.width">50mm</xsl:param>

  <!-- Descriptive data modules with these info codes are presented as front matter, meaning
         - Only the infoName is presented
         - No TOC, LOF, LOTBL, or References
         - No centerhead 'Description' -->
  <xsl:param name="front.matter.info.codes">001 005 006 007 009 00A 00S 00U 00Z</xsl:param>
  <!-- Descriptive data modules with these info codes are presented as "simple"/"tabular", meaning
         - No TOC, LOF, LOTBL, or References
         - No centerhead 'Description' -->
  <xsl:param name="simple.info.codes"/>

  <!-- Determines whether normal pagination (page number is reset to 1 for each
       data module) or running pagination will be used.

       This does not set the actual method of pagination, which is handled by
       the DocBook stylesheets. See the equivalent parameter in dbtofo.xsl.
       This parameter sets how page numbers are handled in the generated table
       of contents.

       When 0, the heading for the page number will be "No. of pages" and the
       entry will contain the total page count for that data module.

       When 1, the heading for the page number will be "Page" and the entry
       will contain page number on which the data module begins. -->
  <xsl:param name="running.pagination">0</xsl:param>

  <!-- Highlight applicability statements with blue -->
  <xsl:param name="highlight.applic">0</xsl:param>

  <!-- Controls whether and how quantities are reformatted for presentation.

       custom   Completely reformat quantities using the formats specified below
                and the format-number() function. All quantities will be
                presented in the same format regardless of how they are
                authored.

                For example, 0.030 and 0.3 are both valid xs:decimal numbers.
                With this formatting option, both would be presented the same
                way (either both as 0.030 or both as 0.3).

                The quantity.decimal.format and quantity.format options
                actually determine the formatting.

                This is the most consistent option, but isn't suitable if the
                project uses varying formats (for example, different numbers of
                leading/trailing zeroes to indicate different scales.

       basic    Do simple translation of xs:decimal to the format indicated in
                quantity.decimal.format, but keep other formatting (such as
                leading/trailing zeroes) as-is.

       none     Present the xs:decimal value exactly as authored. -->
  <xsl:param name="reformat.quantities">basic</xsl:param>

  <xsl:decimal-format name="SI" decimal-separator="," grouping-separator=" "/>
  <xsl:decimal-format name="imperial" decimal-separator="." grouping-separator=","/>

  <!-- The rules for specifying a format for displaying quantity values and
       tolerances.

       Allowable values:

       SI         Système International d'Unites (SI)
                  - Uses comma [,] as the decimal separator
                  - Uses space [ ] as the grouping separator
                    (currently only when reformat.quantities = custom)

       imperial   Imperial
                  - Uses period [.] as the decimal separator
                  - Uses comma [,] as the grouping separator
                    (currently only when reformat.quantities = custom) -->
  <xsl:param name="quantity.decimal.format">SI</xsl:param>
  
  <!-- The actual format of a quantity value/threshold when
       reformat.quantities = custom, conforming to the chosen rules. This is
       the picture string passed to format-number(). -->
  <xsl:param name="quantity.format">
    <xsl:choose>
      <xsl:when test="$quantity.decimal.format = 'SI'">### ##0,#####</xsl:when>
      <xsl:when test="$quantity.decimal.format = 'imperial'">###,##0.#####</xsl:when>
    </xsl:choose>
  </xsl:param>

  <!-- How applicability is shown.
       
       none       Never show applicability statements.

       simple     Only show statements on elements with @applicRefId.
       
       standard   Show applicability statements as described in Chap 6 of the
                  specification. -->
  <xsl:param name="show.applicability">simple</xsl:param>

  <!--<xsl:param name="sidehead0.need">2cm</xsl:param>
  <xsl:param name="centerhead2.need">5cm</xsl:param>-->

  <!-- Hide preliminary requirements section when unused (all tables are empty) -->
  <xsl:param name="hide.empty.proced.rqmts">0</xsl:param>

  <!-- Hide the References table if there are no references -->
  <xsl:param name="hide.empty.refs.table">0</xsl:param>

  <!-- Whether or not to include the default heading based on the DM schema,
       e.g., "Description" for descriptive, "Procedure" for procedural, etc. -->
  <xsl:param name="show.schema.heading">1</xsl:param>

  <xsl:output indent="no" method="xml"/>

  <xsl:include href="crew.xsl"/>
  <xsl:include href="descript.xsl"/>
  <xsl:include href="fault.xsl"/>
  <xsl:include href="proced.xsl"/>
  <xsl:include href="frontmatter.xsl"/>

  <!-- Project configurable attribute values -->
  <xsl:include href="configurable.xsl"/>

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
    <xsl:choose>
      <!-- if this is inside a dmRef, we want the info code of the referenced dm -->
      <xsl:when test="ancestor-or-self::dmRef">
        <xsl:apply-templates select="ancestor-or-self::dmRef/dmRefIdent/dmCode/@infoCode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="ancestor-or-self::dmodule/identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCode"/>
      </xsl:otherwise>
    </xsl:choose>
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
    <xsl:variable name="applic" select="dmStatus/applic"/>
    <xsl:choose>
      <xsl:when test="$applic/displayText/simplePara">
        <xsl:apply-templates select="$applic/displayText/simplePara/node()"/>
      </xsl:when>
      <xsl:when test="$applic/displayText">
        <xsl:text>All</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$applic/assert|$applic/evaluate"/>
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
        <xsl:call-template name="data.module.type">
          <xsl:with-param name="info.code">
            <xsl:call-template name="get.infocode"/>
          </xsl:with-param>
        </xsl:call-template>
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
        <xsl:choose>
          <xsl:when test="$pm/identAndStatusSection/pmAddress/pmAddressItems/pmTitle">
            <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmAddressItems/pmTitle/text()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="dmAddress/dmAddressItems/dmTitle"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="publication.author">
        <xsl:choose>
          <xsl:when test="$pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/enterpriseName">
            <xsl:value-of select="$pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/enterpriseName"/>
          </xsl:when>
          <xsl:when test="$pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/@enterpriseCode">
            <xsl:value-of select="$pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/@enterpriseCode"/>
          </xsl:when>
          <xsl:when test="dmStatus/responsiblePartnerCompany/enterpriseName">
            <xsl:value-of select="dmStatus/responsiblePartnerCompany/enterpriseName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="dmStatus/responsiblePartnerCompany/@enterpriseCode"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="page.header.logo">
        <xsl:apply-templates select="(dmStatus/logo|$pm/identAndStatusSection/pmStatus/logo)[1]"/>
      </bibliomisc>
      <xsl:if test="number(dmAddress/dmIdent/issueInfo/@inWork) != 0 and $want.inwork.blurb = 'yes'">
        <bibliomisc role="inwork.blurb">
          <xsl:text>This is a draft copy of issue </xsl:text>
          <xsl:value-of select="dmAddress/dmIdent/issueInfo/@issueNumber"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="dmAddress/dmIdent/issueInfo/@inWork"/>
          <xsl:text>.</xsl:text>
          <xsl:if test="$date.time != ''">
            <xsl:text> Printed </xsl:text>
            <xsl:value-of select="$date.time"/>
            <xsl:text>.</xsl:text>
          </xsl:if>
        </bibliomisc>
      </xsl:if>
      <xsl:if test="$show.producedby.blurb = 'yes'">
        <bibliomisc role="producedby.blurb">
          <xsl:value-of select="$producedby.blurb.before"/>
          <xsl:choose>
            <xsl:when test="$producedby.blurb != ''">
              <xsl:value-of select="$producedby.blurb"/>
            </xsl:when>
            <xsl:when test="dmStatus/responsiblePartnerCompany/enterpriseName">
              <xsl:value-of select="dmStatus/responsiblePartnerCompany/enterpriseName"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="dmStatus/responsiblePartnerCompany/@enterpriseCode"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="$printedin.blurb != ''">
            <xsl:value-of select="$printedin.blurb.before"/>
            <xsl:value-of select="$printedin.blurb"/>
          </xsl:if>
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
        <xsl:apply-templates select="*/security"/>
      </bibliomisc>
      <bibliomisc role="applicability">
        <xsl:call-template name="get.applicability.string"/>
      </bibliomisc>
    </info>
  </xsl:template>

  <xsl:template name="content.refs">
    <xsl:if test="$data.module.index != 0">
      <bridgehead>Index</bridgehead>
      <index>
        <xsl:attribute name="type">
          <xsl:call-template name="get.dmcode"/>
        </xsl:attribute>
      </index>
    </xsl:if>

    <xsl:variable name="dm.refs" select="content/refs/dmRef"/>
    <xsl:variable name="pm.refs" select="content/refs/pmRef"/>
    <xsl:variable name="ep.refs" select="content/refs/externalPubRef"/>

    <xsl:variable name="refs" select="$dm.refs|$pm.refs|$ep.refs"/>

    <xsl:if test="$hide.empty.refs.table = 0 or $refs">
      <bridgehead renderas="centerhead">References</bridgehead>
      <table pgwide="1" frame="topbot" colsep="0" role="refs">
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
                <entry>
                  <xsl:apply-templates select="."/>
                  <xsl:if test="dmRefIdent/issueInfo">
                    <xsl:text> Issue </xsl:text>
                    <xsl:apply-templates select="dmRefIdent/issueInfo"/>
                  </xsl:if>
                </entry>
                <entry>
                  <xsl:apply-templates select="dmRefAddressItems/dmTitle"/>
                </entry>
              </row>
            </xsl:for-each>
            <xsl:for-each select="$pm.refs">
              <row>
                <entry>
                  <xsl:apply-templates select="."/>
                </entry>
                <entry>
                  <xsl:apply-templates select="pmRefAddressItems/pmTitle"/>
                  <xsl:if test="pmRefAddressItems/issueDate">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="pmRefAddressItems/issueDate"/>
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
                  <xsl:value-of select="externalPubRefIdent/externalPubTitle"/>
                </entry>
              </row>
            </xsl:for-each>
          </tbody>
        </tgroup>
      </table>
    </xsl:if>
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
        <xsl:if test="$title != ''">
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
      <!-- When internalRef contains textual content, always display that -->
      <xsl:when test=". != ''">
        <link linkend="{$linkend}">
          <xsl:apply-templates/>
        </link>
      </xsl:when>
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
            <xsl:when test="name($target[1]) = 'proceduralStep' or name($target[1]) = 'proceduralStepAlts' or name($target[1]) = 'crewDrillStep'">
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
    <xsl:if test="./@learnCode">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="./@learnCode"/>
      <xsl:value-of select="./@learnEventCode"/>
    </xsl:if>
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

  <xsl:template match="issueInfo">
    <xsl:value-of select="@issueNumber"/>
    <xsl:if test="@inWork != '00'">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@inWork"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="levelled.para.content">
    <xsl:call-template name="copy.id"/>
    <xsl:call-template name="revisionflag"/>
    <xsl:call-template name="applic.annotation"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="levelledPara|commonInfoDescrPara">
    <section>
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:call-template name="applic.annotation"/>
      <xsl:apply-templates select="@warningRefs"/>
      <xsl:apply-templates select="@cautionRefs"/>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <!-- Experimental: Handle levelledParas the same as proceduralSteps.

       Allows for levelledPara's without titles to be displayed properly? -->

  <xsl:template match="levelledPara[not(title)]|commonInfoDescrPara[not(title)]">
    <xsl:call-template name="labelled.para">
      <xsl:with-param name="label">
        <xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <fo:block>
          <xsl:apply-templates select="@warningRefs"/>
          <xsl:apply-templates select="@cautionRefs"/>
          <xsl:call-template name="applic.annotation"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="commonInfo">
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$centerhead2.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
    <bridgehead renderas="centerhead">Preliminary requirements</bridgehead>
    <xsl:apply-templates select="reqCondGroup"/>
    <xsl:apply-templates select="reqPersons"/>
    <xsl:apply-templates select="reqSupportEquips"/>
    <xsl:apply-templates select="reqSupplies"/>
    <xsl:apply-templates select="reqSpares"/>
    <xsl:apply-templates select="reqSafety"/>
  </xsl:template>

  <xsl:template match="closeRqmts">
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$centerhead2.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
    <bridgehead renderas="centerhead">Requirements after job completion</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="required.conditions">
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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

  <xsl:template match="procedure/closeRqmts/reqCondGroup">
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

  <xsl:template match="pmRef">
    <xsl:apply-templates select="pmRefIdent"/>
  </xsl:template>

  <xsl:template match="pmRefIdent">
    <xsl:apply-templates select="pmCode"/>
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
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
    <!--<xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="</xsl:text>
      <xsl:value-of select="$sidehead0.need"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>-->
    <bridgehead renderas="sidehead0">Safety conditions</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="noSafety">
    <para>
      <xsl:text>None</xsl:text>
    </para>
  </xsl:template>

  <xsl:template match="safetyRqmts">
    <xsl:apply-templates select="@warningRefs"/>
    <xsl:apply-templates select="@cautionRefs"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="warning|caution">
    <xsl:call-template name="applic.annotation"/>
    <xsl:element name="{name()}">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="note">
    <note>
      <xsl:call-template name="applic.annotation"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </note>
  </xsl:template>

  <xsl:template match="para|warningAndCautionPara|notePara|simplePara|attentionListItemPara">
    <xsl:element name="para">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:call-template name="applic.annotation"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure">
    <figure>
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:attribute name="label">
	      <xsl:number level="any" from="dmodule"/>
      </xsl:attribute>
      <xsl:attribute name="pgwide">1</xsl:attribute>
      <xsl:call-template name="applic.annotation"/>
      <xsl:apply-templates select="title|graphic"/>
    </figure>
    <xsl:apply-templates select="legend"/>
  </xsl:template>

  <xsl:template match="legend">
    <xsl:apply-templates/>
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
          <xsl:if test="self::graphic">
            <xsl:attribute name="width">100%</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="scalefit">1</xsl:attribute>
        </xsl:if>
      </xsl:element>
    </imageobject>
  </xsl:template>

  <xsl:template match="graphic">
    <xsl:param name="show.icn" select="$show.graphic.icn"/>
    <xsl:call-template name="applic.annotation"/>
    <mediaobject>
      <xsl:call-template name="make.imageobject"/>
      <xsl:if test="$show.icn != 0">
        <caption role="icn">
          <para><xsl:value-of select="@infoEntityIdent"/></para>
        </caption>
      </xsl:if>
      <caption role="title">
        <para>
          <xsl:text>Fig </xsl:text>
          <xsl:number count="figure" level="any" from="dmodule"/>
          <xsl:text>&#160;&#160;</xsl:text>
          <xsl:apply-templates select="parent::figure/title/node()"/>
          <xsl:variable name="graphic.count" select="count(parent::figure/graphic)"/>
          <xsl:if test="$graphic.count &gt; 1">
            <xsl:text> (Sheet </xsl:text>
            <xsl:number count="graphic" level="single" from="figure"/>
            <xsl:text> of </xsl:text>
            <xsl:value-of select="$graphic.count"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </para>
      </caption>
    </mediaobject>
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
      <xsl:choose>
        <xsl:when test="@listItemPrefix = 'pf01'">
          <xsl:attribute name="mark">
            <xsl:text>none</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@listItemPrefix = 'pf03'">
          <xsl:attribute name="mark">
            <xsl:text>dash</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@listItemPrefix = 'pf04'">
          <xsl:attribute name="mark">
            <xsl:text>disc</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@listItemPrefix = 'pf05'">
          <xsl:attribute name="mark">
            <xsl:text>circle</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@listItemPrefix = 'pf06'">
          <xsl:attribute name="mark">
            <xsl:text>whitesquare</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@listItemPrefix = 'pf07'">
          <xsl:attribute name="mark">
            <xsl:text>bullet</xsl:text>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
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
    <variablelist termlength="{$definition.list.term.width}">
      <xsl:if test="descendant-or-self::*[@changeMark = '1']">
        <xsl:call-template name="revisionflag">
          <xsl:with-param name="change.mark">1</xsl:with-param>
          <!-- there could be multiple modifications of differing types so lets just mark the list as modified -->
          <xsl:with-param name="change.type">modify</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates/>
    </variablelist>
  </xsl:template>

  <!--<xsl:template match="legend/definitionList">
    <variablelist termlength="7mm">
      <xsl:call-template name="revisionflag"/>
      <title>
        <xsl:text>Legend to Fig </xsl:text>
        <xsl:apply-templates select="ancestor::figure" mode="number"/>
        <xsl:text>:</xsl:text>
      </title>
      <xsl:apply-templates/>
    </variablelist>
  </xsl:template>-->

  <xsl:template match="legend/definitionList">
    <xsl:variable name="items" select="definitionListItem"/>
    <xsl:variable name="count" select="count($items)"/>
    <xsl:variable name="num.cols">
      <xsl:choose>
        <xsl:when test="$count &gt; 1">4</xsl:when>
        <xsl:otherwise>2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="half" select="ceiling($count div 2)"/>
    <fo:block keep-together.within-column="1" text-align="left">
    <fo:block font-style="italic">
      <xsl:text>Legend to Fig </xsl:text>
      <xsl:apply-templates select="ancestor::figure" mode="number"/>
      <xsl:text>:</xsl:text>
    </fo:block>
    <informaltable colsep="0" rowsep="0" frame="none">
      <tgroup cols="{$num.cols}">
        <colspec colnum="1" colwidth="7mm"/>
        <colspec colnum="2" colwidth="68mm"/>
        <xsl:if test="$num.cols = 4">
          <colspec colnum="3" colwidth="7mm"/>
          <colspec colnum="4" colwidth="68mm"/>
        </xsl:if>
        <tbody>
          <xsl:for-each select="$items[position() &lt;= $half]">
            <xsl:variable name="i" select="position()"/>
            <row>
              <entry>
                <xsl:value-of select="listItemTerm"/>
              </entry>
              <entry>
                <xsl:apply-templates select="listItemDefinition/para"/>
              </entry>
              <xsl:if test="$num.cols = 4">
                <entry>
                  <xsl:value-of select="$items[$i + $half]/listItemTerm"/>
                </entry>
                <entry>
                  <xsl:apply-templates select="$items[$i + $half]/listItemDefinition/para"/>
                </entry>
              </xsl:if>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </informaltable>
    </fo:block>
  </xsl:template>

  <xsl:template match="legend/definitionList/definitionListItem/listItemTerm">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="legend/definitionList/definitionListItem/listItemDefinition/para">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
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
      <xsl:call-template name="revisionflag"/>
      <xsl:call-template name="applic.annotation"/>
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

  <xsl:template match="tgroup|thead|colspec|spanspec|row|entry">
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
          <!-- Do not copy S1000D-specific attributes. -->
          <xsl:when test="name(.) = 'applicRefId'"/>
	        <xsl:otherwise>
	          <xsl:copy/>
	        </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:if test="self::entry">
        <!-- Show applic for row in first entry -->
        <xsl:for-each select="parent::row">
          <xsl:apply-templates select="@warningRefs"/>
          <xsl:apply-templates select="@cautionRefs"/>
          <xsl:call-template name="applic.annotation"/>
        </xsl:for-each>
        <xsl:apply-templates select="@warningRefs"/>
        <xsl:apply-templates select="@cautionRefs"/>
        <xsl:call-template name="applic.annotation"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="footnote">
    <xsl:element name="footnote">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="footnoteRef">
    <xsl:variable name="linkend">
      <xsl:text>ID_</xsl:text>
      <xsl:call-template name="get.dmcode"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@internalRefId"/>
    </xsl:variable>
    <footnoteref linkend="{$linkend}"/>
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

  <xsl:template match="dmTitle">
    <!-- present only infoname as title for frontmatter data modules -->
    <xsl:variable name="dm.type">
      <xsl:call-template name="data.module.type">
        <xsl:with-param name="info.code">
          <xsl:call-template name="get.infocode"/>
        </xsl:with-param>
      </xsl:call-template>
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

  <xsl:template name="gen.lot">
    <xsl:variable name="all.tables" select="$all.dmodules//table[title]"/>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="2" align="left">
        <thead rowsep="1">
          <row>
            <entry>Title</entry>
            <entry>Data module code</entry>
          </row>
        </thead>
        <tbody>
          <xsl:choose>
            <xsl:when test="not($all.tables)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$all.tables" mode="lot"/>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="table" mode="lot">
    <row>
      <entry>
        <xsl:value-of select="title"/>
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
    </row>
  </xsl:template>

  <xsl:template name="gen.loi">
    <xsl:variable name="all.graphics" select="$all.dmodules//figure/graphic"/>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="3" align="left">
        <thead rowsep="1">
          <row>
            <entry>Title</entry>
            <entry>ICN</entry>
            <entry>Data module code</entry>
          </row>
        </thead>
        <tbody>
          <xsl:choose>
            <xsl:when test="not($all.graphics)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$all.graphics" mode="loi"/>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="graphic" mode="loi">
    <row>
      <entry>
        <xsl:value-of select="parent::figure/title"/>
      </entry>
      <entry>
        <xsl:apply-templates select="@infoEntityIdent"/>
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
    </row>
  </xsl:template>

  <xsl:template name="gen.high">
    <xsl:variable name="pm" select="(/publication/pm|/pm)"/>
    <para>
      <xsl:text>The listed changes are introduced in issue </xsl:text>
      <xsl:value-of select="$pm/identAndStatusSection/pmAddress/pmIdent/issueInfo/@issueNumber"/>
      <xsl:text>, dated </xsl:text>
      <xsl:apply-templates select="$pm/identAndStatusSection/pmAddress/pmAddressItems/issueDate"/>
      <xsl:text>, of this publication.</xsl:text>
    </para>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="2" align="left">
        <thead rowsep="1">
          <row>
            <entry>Data module code</entry>
            <entry>Reason for update</entry>
          </row>
        </thead>
        <tbody>
          <xsl:choose>
            <xsl:when test="not(//reasonForUpdate)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$all.dmodules" mode="highlights"/>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

  <xsl:template match="dmodule" mode="highlights">
    <xsl:apply-templates select="identAndStatusSection/dmStatus/reasonForUpdate" mode="highlights"/>
  </xsl:template>

  <xsl:template match="reasonForUpdate" mode="highlights">
    <row>
      <xsl:if test="position() = 1">
        <entry morerows="{count(following-sibling::reasonForUpdate)}">
          <link>
            <xsl:attribute name="linkend">
              <xsl:text>ID_</xsl:text>
              <xsl:call-template name="get.dmcode"/>
            </xsl:attribute>
            <xsl:call-template name="get.dmcode"/>
          </link>
        </entry>
      </xsl:if>
      <entry>
        <xsl:apply-templates/>
      </entry>
    </row>
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
            <entry>
              <xsl:choose>
                <xsl:when test="$running.pagination = 0">No. of pages</xsl:when>
                <xsl:otherwise>Page</xsl:otherwise>
              </xsl:choose>
            </entry>
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
        <colspec colname="c3" colwidth="7em"/>
        <colspec colname="c4" colwidth="4em"/>
        <colspec colname="c5" colwidth="8em"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Document identifier</entry>
            <entry>Issue date</entry>
            <entry>
              <xsl:choose>
                <xsl:when test="$running.pagination = 0">No. of pages</xsl:when>
                <xsl:otherwise>Page</xsl:otherwise>
              </xsl:choose>
            </entry>
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
        <colspec colname="c3" colwidth="7em"/>
        <colspec colname="c4" colwidth="4em"/>
        <colspec colname="c5" colwidth="8em"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Document identifier</entry>
            <entry>Issue date</entry>
            <entry>
              <xsl:choose>
                <xsl:when test="$running.pagination = 0">No. of pages</xsl:when>
                <xsl:otherwise>Page</xsl:otherwise>
              </xsl:choose>
            </entry>
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
              <xsl:choose>
                <xsl:when test="$running.pagination = 0">
                  <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
                </xsl:when>
                <xsl:otherwise>
                  <fo:page-number-citation ref-id="ID_{$dm.code}"/>
                </xsl:otherwise>
              </xsl:choose>
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
          <xsl:choose>
            <xsl:when test="$running.pagination = 0">
              <fo:page-number-citation-last ref-id="ID_{$dm.code}-end"/>
            </xsl:when>
            <xsl:otherwise>
              <fo:page-number-citation ref-id="ID_{$dm.code}"/>
            </xsl:otherwise>
          </xsl:choose>
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
                <fo:block-container height="15mm">
                  <xsl:call-template name="logo.and.company">
                    <xsl:with-param name="title">Publisher:</xsl:with-param>
                    <xsl:with-param name="logo" select="$publisherLogo"/>
                    <xsl:with-param name="company" select="$responsiblePartnerCompany"/>
                  </xsl:call-template>
                </fo:block-container>
                <fo:block-container height="15mm">
                  <fo:block>
                    <xsl:if test="enterpriseSpec">
                      <fo:block padding-top="5mm" border-top-style="solid" border-top-color="black" border-top-width="1px">
                        <xsl:call-template name="logo.and.company">
                          <xsl:with-param name="title">Manufacturer:</xsl:with-param>
                          <xsl:with-param name="logo" select="$enterpriseLogo"/>
                          <xsl:with-param name="company" select="$enterpriseSpec"/>
                        </xsl:call-template>
                      </fo:block>
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
    <fo:block font-weight="bold" font-size="10pt" keep-with-next="always">
      <xsl:if test="$highlight.applic != 0">
        <xsl:attribute name="color">blue</xsl:attribute>
      </xsl:if>
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
    <xsl:text>: </xsl:text>
    <xsl:value-of select="@applicPropertyValues"/>
  </xsl:template>

  <xsl:template match="evaluate">
    <xsl:variable name="op" select="@andOr"/>
    <xsl:for-each select="assert|evaluate">
      <xsl:if test="self::evaluate and @andOr != $op">
        <xsl:text>(</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
      <xsl:if test="self::evaluate and @andOr != $op">
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="position() != last()">
        <xsl:text> </xsl:text>
        <xsl:value-of select="$op"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="applic.annotation">
    <xsl:if test="$show.applicability != 'none' and ancestor-or-self::dmodule//content//@applicRefId">
      <xsl:call-template name="make.applic.annotation"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make.applic.annotation">
      <xsl:variable name="this.applic" select="@applicRefId"/>
      <xsl:choose>
        <!-- If this element has an applic statement, show it. -->
        <xsl:when test="$this.applic">
          <xsl:apply-templates select="$this.applic"/>
        </xsl:when>
        <!-- If this element has no applic statement, check if there is a
             preceding applicability statement.
             
             FIXME: Very expensive/slow to calculate this since it involves
                    constantly looking backwards in the document with
                    preceding::* and ancestor::* even when there is very little
                    applicability. -->
        <xsl:when test="$show.applicability = 'standard'">
          <xsl:variable name="this" select="."/>
          <xsl:variable name="this.preced" select="$this/preceding::*|$this/ancestor::*"/>
          <xsl:variable name="this.preced.count" select="count($this.preced)"/>
          <xsl:variable name="preced.applic" select="$this/preceding::*[@applicRefId][1]"/>
          <!-- If there is a preceding applicability statement, a statement must
               be placed on this element to disambiguate its applicability. The
               statement will be inherited from either an ancestor element or the
               applicability of the whole data module. -->
          <xsl:if test="$preced.applic">
            <!-- Use the Kayessian XPath formula to obtain all elements between
                 the preceding applicability statement and the current element. -->
            <xsl:variable
              name="between"
              select="$preced.applic/following::*[count(.|$this.preced) = $this.preced.count]"/>
            <!-- If there are no elements between the last applicability statement
                 and the current element, then this element will carry the
                 inherited applicability statement. -->
            <xsl:if test="not($between)">
              <!-- Find any ancestor element with applicability. -->
              <xsl:variable name="parent.applic" select="ancestor::*[@applicRefId][1]/@applicRefId"/>
              <xsl:choose>
                <!-- If there is an ancestor element with applicability, inherit
                     from that. -->
                <xsl:when test="$parent.applic">
                  <xsl:apply-templates select="$parent.applic"/>
                </xsl:when>
                <!-- If there is no parent element with applicability, inherit
                     from the data module's applicability. -->
                <xsl:otherwise>
                  <xsl:apply-templates select="ancestor::dmodule/identAndStatusSection/dmStatus/applic"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
  </xsl:template>

  <xsl:template match="levelledParaAlts|proceduralStepAlts|figureAlts">
    <fo:block keep-with-next="always">
      <xsl:call-template name="copy.id"/>
    </fo:block>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="functionalItemRef|controlIndicatorRef|accessPointRef|zoneRef">
    <xsl:choose>
      <xsl:when test="shortName">
        <xsl:value-of select="shortName"/>
      </xsl:when>
      <xsl:when test="name">
        <xsl:value-of select="name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="self::functionalItemRef">
            <xsl:text>Functional item </xsl:text>
            <xsl:value-of select="@functionalItemNumber"/>
          </xsl:when>
          <xsl:when test="self::controlIndicatorRef">
            <xsl:text>Control/indicator </xsl:text>
            <xsl:value-of select="@controlIndicatorNumber"/>
          </xsl:when>
          <xsl:when test="self::accessPointRef">
            <xsl:text>Access </xsl:text>
            <xsl:if test="@accessPointType">
              <xsl:apply-templates select="@accessPointType"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="@accessPointNumber"/>
          </xsl:when>
          <xsl:when test="self::zoneRef">
            <xsl:text>Zone </xsl:text>
            <xsl:value-of select="@zoneNumber"/>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="toolRef">
    <xsl:if test="$part.no.prefix != 0">
      <xsl:text>Part No. </xsl:text>
    </xsl:if>
    <xsl:if test="@manufacturerCodeValue">
      <xsl:value-of select="@manufacturerCodeValue"/>
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:value-of select="@toolNumber"/>
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

  <xsl:template match="acronym">
    <xsl:choose>
      <xsl:when test="$auto.expand.acronyms = 'before'">
        <xsl:apply-templates select="acronymDefinition"/>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="acronymTerm"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="$auto.expand.acronyms = 'after'">
        <xsl:apply-templates select="acronymTerm"/>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="acronymDefinition"/>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="acronymTerm"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="acronymTerm">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="acronymDefinition">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="data.module.type">
    <xsl:param name="info.code"/>
    <xsl:choose>
      <xsl:when test="contains($front.matter.info.codes, $info.code)">frontmatter</xsl:when>
      <xsl:when test="contains($simple.info.codes, $info.code)">simple</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Pass through MathML -->
  <xsl:template match="mml:*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mml:math">
    <inlineequation>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </inlineequation>
  </xsl:template>

  <xsl:template match="mml:math[@display = 'block']">
    <informalequation>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </informalequation>
  </xsl:template>

  <xsl:template match="caption">
    <fo:inline border="solid 1px black">
      <xsl:attribute name="background-color">
        <xsl:apply-templates select="@color"/>
      </xsl:attribute>
      <xsl:attribute name="color">
        <xsl:apply-templates select="@color" mode="text.color"/>
      </xsl:attribute>
      <xsl:apply-templates select="captionLine"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="captionLine">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="quantity">
    <xsl:apply-templates/>
    <xsl:if test="@quantityTypeSpecifics">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@quantityTypeSpecifics"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="quantityGroup">
    <xsl:choose>
      <xsl:when test="@quantityGroupType = 'minimum'">from </xsl:when>
      <xsl:when test="@quantityGroupType = 'maximum'"> to </xsl:when>
    </xsl:choose>
    <xsl:for-each select="quantityValue">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:if test="quantityValue and quantityTolerance">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:for-each select="quantityTolerance">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:apply-templates select="@quantityUnitOfMeasure"/>
  </xsl:template>

  <!-- Format xs:decimal value appropriately -->
  <xsl:template name="format.quantity.value">
    <xsl:param name="value" select="."/>
    <xsl:choose>
      <xsl:when test="$reformat.quantities = 'custom'">
        <xsl:value-of select="format-number($value, $quantity.format, $quantity.decimal.format)"/>
      </xsl:when>
      <xsl:when test="$reformat.quantities = 'basic' and $quantity.decimal.format = 'SI'">
        <xsl:value-of select="translate($value, '.', ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="quantityValue">
    <xsl:call-template name="format.quantity.value"/>
    <xsl:apply-templates select="@quantityUnitOfMeasure"/>
  </xsl:template>

  <xsl:template match="quantityTolerance">
    <xsl:call-template name="quantity.tolerance.type"/>
    <xsl:call-template name="format.quantity.value"/>
    <xsl:apply-templates select="@quantityUnitOfMeasure"/>
  </xsl:template>

  <xsl:template name="quantity.tolerance.type">
    <xsl:param name="type" select="@quantityToleranceType"/>
    <xsl:choose>
      <xsl:when test="$type = 'plus'">+</xsl:when>
      <xsl:when test="$type = 'minus'">-</xsl:when>
      <xsl:otherwise>± </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexFlag">
    <indexterm>
      <xsl:if test="$data.module.index != 0">
        <xsl:attribute name="type">
          <xsl:call-template name="get.dmcode"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@indexLevelOne|@indexLevelTwo|@indexLevelThree|@indexLevelFour"/>
    </indexterm>
  </xsl:template>

  <xsl:template match="@indexLevelOne">
    <primary>
      <xsl:value-of select="."/>
    </primary>
  </xsl:template>

  <xsl:template match="@indexLevelTwo">
    <xsl:if test="not(parent::indexFlag/@indexLevelOne)">
      <xsl:apply-templates select="preceding::*[@indexLevelOne]/@indexLevelOne"/>
    </xsl:if>
    <secondary>
      <xsl:value-of select="."/>
    </secondary>
  </xsl:template>

  <xsl:template match="@indexLevelThree">
    <xsl:if test="not(parent::indexFlag/@indexLevelOne)">
      <xsl:apply-templates select="preceding::*[@indexLevelOne]/@indexLevelOne"/>
    </xsl:if>
    <xsl:if test="not(parent::indexFlag/@indexLevelTwo)">
      <xsl:apply-templates select="preceding::*[@indexLevelTwo]/@indexLevelTwo"/>
    </xsl:if>
    <tertiary>
      <xsl:value-of select="."/>
    </tertiary>
  </xsl:template>

  <xsl:template name="gen.index">
    <xsl:choose>
      <xsl:when test="$index.type = 'docbook'">
        <index/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gen.index.table"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Get the last occurence of preceding index flag levels -->
  <xsl:template name="index.level">
    <xsl:param name="level"/>
    <xsl:choose>
      <xsl:when test="parent::indexFlag/@*[name() = $level]">
        <xsl:value-of select="parent::indexFlag/@*[name() = $level]"/>
      </xsl:when>
      <xsl:when
        test="(name() = 'indexLevelTwo' and
                ($level = 'indexLevelOne')) or
              (name()='indexLevelThree' and
                ($level='indexLevelOne' or
                 $level='indexLevelTwo')) or
              (name()='indexLevelFour' and
                ($level='indexLevelOne' or
                 $level='indexLevelTwo' or
                 $level='indexLevelThree'))">
        <xsl:value-of select="preceding::indexFlag[@*[name() = $level]]/@*[name() = $level]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dm.ref.link">
    <xsl:param name="dmcode">
      <xsl:call-template name="get.dmcode"/>
    </xsl:param>
    <link>
      <xsl:attribute name="linkend">
        <xsl:text>ID_</xsl:text>
        <xsl:value-of select="$dmcode"/>
      </xsl:attribute>
      <xsl:value-of select="$dmcode"/>
    </link>
  </xsl:template>

  <!-- List each unique dmCode where each unique flag occurs only once.
       
       Each unique flag is identified by the values of all four index levels
       together.
       
       If an index flag does not include preceding level, e.g.

          <indexFlag indexLevelThree="example"/>

       then the preceding levels are determined from other preceding indexFlag
       elements. -->
  <xsl:template match="@indexLevelOne|@indexLevelTwo|@indexLevelThree|@indexLevelFour" mode="gen.index.refs">
    <xsl:variable name="name" select="name()"/>
    <xsl:variable name="this" select="."/>
    <xsl:variable name="this.dmcode">
      <xsl:call-template name="get.dmcode"/>
    </xsl:variable>
    <xsl:variable name="this.level1">
      <xsl:call-template name="index.level">
        <xsl:with-param name="level">indexLevelOne</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="this.level2">
      <xsl:call-template name="index.level">
        <xsl:with-param name="level">indexLevelTwo</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="this.level3">
      <xsl:call-template name="index.level">
        <xsl:with-param name="level">indexLevelThree</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="this.level4">
      <xsl:call-template name="index.level">
        <xsl:with-param name="level">indexLevelFour</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <para>
      <xsl:call-template name="dm.ref.link">
        <xsl:with-param name="dmcode" select="$this.dmcode"/>
      </xsl:call-template>
    </para>
    <xsl:for-each select="$all.dmodules//indexFlag/@*[name() = $name and . = $this]">
      <xsl:variable name="cur.dmcode">
        <xsl:call-template name="get.dmcode"/>
      </xsl:variable>
      <xsl:variable name="cur.level1">
        <xsl:call-template name="index.level">
          <xsl:with-param name="level">indexLevelOne</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cur.level2">
        <xsl:call-template name="index.level">
          <xsl:with-param name="level">indexLevelTwo</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cur.level3">
        <xsl:call-template name="index.level">
          <xsl:with-param name="level">indexLevelThree</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cur.level4">
        <xsl:call-template name="index.level">
          <xsl:with-param name="level">indexLevelFour</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="(not($this.level1 or $cur.level1) or $this.level1 = $cur.level1) and
                    (not($this.level2 or $cur.level2) or $this.level2 = $cur.level2) and
                    (not($this.level3 or $cur.level3) or $this.level3 = $cur.level3) and
                    (not($this.level4 or $cur.level4) or $this.level4 = $cur.level4) and
                    ($this.dmcode != $cur.dmcode)">
        <para>
          <xsl:call-template name="dm.ref.link">
            <xsl:with-param name="dmcode" select="$cur.dmcode"/>
          </xsl:call-template>
        </para>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@indexLevelOne|@indexLevelTwo|@indexLevelThree|@indexLevelFour" mode="gen.index">
    <xsl:variable name="this" select="."/>
    <xsl:variable name="name" select="name()"/>
    <xsl:if test="not(preceding::indexFlag[@*[name() = $name and . = $this]])">
      <xsl:variable name="next">
        <xsl:choose>
          <xsl:when test="$name = 'indexLevelOne'">indexLevelTwo</xsl:when>
          <xsl:when test="$name = 'indexLevelTwo'">indexLevelThree</xsl:when>
          <xsl:when test="$name = 'indexLevelThree'">indexLevelFour</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <row>
        <!-- Empty entries to pad for each level -->
        <xsl:choose>
          <xsl:when test="$name = 'indexLevelTwo'">
            <entry/>
          </xsl:when>
          <xsl:when test="$name = 'indexLevelThree'">
            <entry/>
            <entry/>
          </xsl:when>
          <xsl:when test="$name = 'indexLevelFour'">
            <entry/>
            <entry/>
            <entry/>
          </xsl:when>
        </xsl:choose>
        <entry spanname="{$name}">
          <xsl:value-of select="$this"/>
        </entry>
        <entry>
          <xsl:apply-templates select="." mode="gen.index.refs"/>
        </entry>
      </row>
      <xsl:apply-templates select="//@*[name() = $next and (parent::indexFlag[@*[name() = $name and . = $this]] or preceding::indexFlag[@*[name() = $name and . = $this]])]" mode="gen.index">
        <xsl:sort/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template name="gen.index.table">
    <informaltable pgwide="1" frame="topbot" rowsep="0" colsep="0">
      <tgroup cols="5">
        <colspec colname="c1" colwidth="1*"/>
        <colspec colname="c2" colwidth="1*"/>
        <colspec colname="c3" colwidth="1*"/>
        <colspec colname="c4" colwidth="2*"/>
        <colspec colname="c5" colwidth="5*"/>
        <spanspec spanname="indexLevelOne" namest="c1" nameend="c4"/>
        <spanspec spanname="indexLevelTwo" namest="c2" nameend="c4"/>
        <spanspec spanname="indexLevelThree" namest="c3" nameend="c4"/>
        <spanspec spanname="indexLevelFour" namest="c4" nameend="c4"/>
        <thead>
          <row rowsep="1">
            <entry spanname="indexLevelOne">Term</entry>
            <entry>Data module code</entry>
          </row>
        </thead>
        <tbody>
          <xsl:apply-templates select="//@indexLevelOne" mode="gen.index">
            <xsl:sort/>
          </xsl:apply-templates>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

</xsl:stylesheet>
