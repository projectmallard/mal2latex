<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mal="http://projectmallard.org/1.0/"
                exclude-result-prefixes="mal"
                version="1.0">

<xsl:template mode="mal2latex.block.mode" match="mal:comment"/>

<xsl:template mode="mal2latex.block.mode" match="mal:code">
  <xsl:variable name="first" select="node()[1]/self::text()"/>
  <xsl:variable name="last" select="node()[last()]/self::text()"/>
  <xsl:text>\begin{boxedminipage}{\textwidth}&#x000A;</xsl:text>
  <xsl:text>\begin{alltt}&#x000A;</xsl:text>
  <xsl:if test="$first">
    <xsl:variable name="text">
      <xsl:call-template name="utils.strip_newlines">
        <xsl:with-param name="string" select="$first"/>
        <xsl:with-param name="leading" select="true()"/>
        <xsl:with-param name="trailing" select="count(node()) = 1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="mal2latex.inline.escape">
      <xsl:with-param name="node" select="$first"/>
      <xsl:with-param name="text" select="$text"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates mode="mal2latex.inline.mode"
                       select="node()[not(self::text() and (position() = 1 or position() = last()))]"/>
  <xsl:if test="$last and (count(node()) != 1)">
    <xsl:variable name="text">
      <xsl:call-template name="utils.strip_newlines">
        <xsl:with-param name="string" select="$last"/>
        <xsl:with-param name="leading" select="false()"/>
        <xsl:with-param name="trailing" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="mal2latex.inline.escape">
      <xsl:with-param name="node" select="$last"/>
      <xsl:with-param name="text" select="$text"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>\end{alltt}&#x000A;</xsl:text>
  <xsl:text>\end{boxedminipage}&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:example">
  <xsl:text>\begin{malexample}&#x000A;</xsl:text>
  <xsl:apply-templates mode="mal2latex.block.mode"/>
  <xsl:text>\end{malexample}&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:list">
  <xsl:choose>
    <xsl:when test="@type = 'numbered'">
      <xsl:text>\begin{enumerate}&#x000A;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\begin{itemize}&#x000A;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:for-each select="mal:item">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates mode="mal2latex.block.mode"/>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="@type = 'numbered'">
      <xsl:text>\end{enumerate}&#x000A;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\end{itemize}&#x000A;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:note">
  <xsl:text>\begin{malnote}&#x000A;</xsl:text>
  <xsl:apply-templates mode="mal2latex.block.mode"/>
  <xsl:text>\end{malnote}&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:screen">
  <xsl:variable name="first" select="node()[1]/self::text()"/>
  <xsl:variable name="last" select="node()[last()]/self::text()"/>
  <xsl:text>\begin{malscreen}&#x000A;</xsl:text>
  <xsl:if test="$first">
    <xsl:variable name="text">
      <xsl:call-template name="utils.strip_newlines">
        <xsl:with-param name="string" select="$first"/>
        <xsl:with-param name="leading" select="true()"/>
        <xsl:with-param name="trailing" select="count(node()) = 1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="mal2latex.inline.escape">
      <xsl:with-param name="node" select="$first"/>
      <xsl:with-param name="text" select="$text"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates mode="mal2latex.inline.mode"
                       select="node()[not(self::text() and (position() = 1 or position() = last()))]"/>
  <xsl:if test="$last and (count(node()) != 1)">
    <xsl:variable name="text">
      <xsl:call-template name="utils.strip_newlines">
        <xsl:with-param name="string" select="$last"/>
        <xsl:with-param name="leading" select="false()"/>
        <xsl:with-param name="trailing" select="true()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="mal2latex.inline.escape">
      <xsl:with-param name="node" select="$last"/>
      <xsl:with-param name="text" select="$text"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:text>\end{malscreen}&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:steps">
  <xsl:text>\begin{malsteps}&#x000A;</xsl:text>
  <xsl:for-each select="mal:item">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates mode="mal2latex.block.mode"/>
  </xsl:for-each>
  <xsl:text>\end{malsteps}&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:synopsis">
  <xsl:message>
    <xsl:text>FIXME: synopsis</xsl:text>
  </xsl:message>
  <xsl:apply-templates mode="mal2latex.block.mode"/>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:p">
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>&#x000A;&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:title">
  <xsl:text>{\bf </xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}&#x000A;&#x000A;</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched block element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
</xsl:template>

</xsl:stylesheet>
