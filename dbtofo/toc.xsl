<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions" version="1.0">
  
  <!-- TOC ********************************************************************** -->

  <xsl:param name="generate.toc">chapter toc,title,figure,table,example</xsl:param>

  <xsl:param name="toc.indent.width">0</xsl:param>

  <xsl:template name="table.of.contents.titlepage">
    <fo:block xsl:use-attribute-sets="section.title.level1.properties"
      space-before="1cm" space-before.conditionality="retain" space-after="12pt"
      font-size="{$font.size.heading}" font-weight="bold" start-indent="0pt">
      <fo:table>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell text-align="left">
              <fo:block>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'TableofContents'"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block font-size="10pt" font-weight="normal">Page</fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="list.of.figures.titlepage">
    <fo:block xsl:use-attribute-sets="list.of.figures.titlepage.recto.style"
      space-before.minimum="1em" space-before.optimum="1.5em"
      space-before.maximum="2em" space-after="0.5em"
      start-indent="0pt" font-size="{$font.size.heading}"
      font-weight="bold" font-family="{$title.fontset}">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'ListofFigures'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="list.of.tables.titlepage">
    <fo:block xsl:use-attribute-sets="list.of.tables.titlepage.recto.style"
      space-before.minimum="1em" space-before.optimum="1.5em"
      space-before.maximum="2em" space-after="0.5em"
      start-indent="0pt"
      font-size="{$font.size.heading}"
      font-weight="bold" font-family="{$title.fontset}">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'ListofTables'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="NOTANODE"/>

    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>

    <fo:table width="100%" table-layout="fixed">
      <fo:table-column column-width="{$toc.section.width}"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell start-indent="0pc">
            <fo:block text-align="left" text-align-last="justify">
              <fo:basic-link internal-destination="{$id}">
                <xsl:if test="$label != ''">
                  <xsl:copy-of select="$label"/>
                </xsl:if>
                <fo:leader leader-pattern="space"/>
              </fo:basic-link>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell start-indent="0pc">
            <fo:block text-align="left" text-align-last="justify" width="90%">
              <fo:basic-link internal-destination="{$id}">
                <xsl:apply-templates select="." mode="title.markup"/>
                <fo:inline keep-together.within-line="always">
                  <fo:leader leader-pattern="dots" keep-with-next.within-line="always"/>
                  <fo:page-number-citation ref-id="{$id}"/>
                </fo:inline>
              </fo:basic-link>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template match="d:bridgehead" mode="toc">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <fo:table width="100%" table-layout="fixed">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell start-indent="0pc">
            <fo:block text-align="left" text-align-last="justify">
              <fo:basic-link internal-destination="{$id}">
                <xsl:apply-templates select="." mode="title.markup"/>
                <fo:inline keep-together.within-line="always">
                  <fo:leader leader-pattern="dots" keep-with-next.within-line="always"/>
                  <fo:page-number-citation ref-id="{$id}"/>
                </fo:inline>
              </fo:basic-link>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template match="d:chapter" mode="toc">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <fo:table width="100%" table-layout="fixed">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell start-indent="0pc">
            <fo:block text-align="left" text-align-last="justify">
              <fo:basic-link internal-destination="{$id}">
                <xsl:choose>
                  <xsl:when test="d:info/d:subtitle != ''">
                    <xsl:apply-templates select="." mode="subtitle.markup"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="." mode="title.markup"/>
                  </xsl:otherwise>
                </xsl:choose>
                <fo:inline keep-together.within-line="always">
                  <fo:leader leader-pattern="dots" keep-with-next.within-line="always"/>
                  <fo:page-number-citation ref-id="{$id}"/>
                </fo:inline>
              </fo:basic-link>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="component.toc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="toc.title.p" select="true()"/>

    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="cid">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$toc-context"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="nodes"
      select="d:section|d:sect1|d:refentry
      |d:article|d:bibliography|d:glossary
      |d:qandaset[$qanda.in.toc != 0]
      |d:appendix|d:index|d:bridgehead[@renderas='centerhead']
      |d:para[@labeltitle]"/>

    <xsl:variable name="chapter" select="ancestor-or-self::d:chapter"/>

    <!-- Don't show TOC on authored "frontmatter" data modules even if they
         contain the nodes specified above.

         Currently these are (crudely) identified by their lack of centerheads
         and only the descriptive schema is really supported for authoring them.

         TODO: Find more robust way of determining "frontmatter" vs "normal"
               data modules.

         TODO: Hide LOF and LOTBL on frontmatter data modules too. -->
    <xsl:if test="$nodes and $chapter//d:bridgehead[@renderas='centerhead']">
      <fo:block id="toc...{$id}" xsl:use-attribute-sets="toc.margin.properties">
        <xsl:if test="$toc.title.p">
          <xsl:call-template name="table.of.contents.titlepage"/>
        </xsl:if>
        <xsl:if test="$include.title.in.toc != 0">
          <xsl:apply-templates select="$chapter" mode="toc"/>
        </xsl:if>
        <xsl:apply-templates select="$nodes" mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:para[@labeltitle]" mode="label.markup">
    <xsl:value-of select="@label"/>
  </xsl:template>
  <xsl:template match="d:para[@labeltitle]" mode="title.markup">
    <xsl:value-of select="@labeltitle"/>
  </xsl:template>
  <xsl:template match="d:para[@labeltitle]" mode="toc">
    <xsl:param name="toc-context"/>
    <xsl:call-template name="toc.line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
