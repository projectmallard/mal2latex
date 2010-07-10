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
                xmlns:exsl="http://exslt.org/common"
                xmlns:mal="http://projectmallard.org/1.0/"
                exclude-result-prefixes="exsl mal"
                version="1.0">

<xsl:template name="_repeat_cols">
  <xsl:param name="num"/>
  <xsl:if test="$num &gt; 0">
    <mal:col/>
    <xsl:call-template name="_repeat_cols">
      <xsl:with-param name="num" select="$num - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template mode="mal2latex.block.mode" match="mal:table">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="mal:col | mal:colgroup">
        <xsl:copy-of select="mal:col | mal:colgroup"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select=".//mal:tr[1]/mal:td">
          <xsl:choose>
            <xsl:when test="@colspan">
              <xsl:call-template name="_repeat_cols">
                <xsl:with-param name="num" select="number(@colspan)"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <mal:col/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="colrules">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @rules, ' '), 'cols')">
        <xsl:text>cols</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @rules, ' '), 'colgroups')">
        <xsl:text>colgroups</xsl:text>
      </xsl:when>
      <xsl:when test="@rules = 'all'">
        <xsl:text>cols</xsl:text>
      </xsl:when>
      <xsl:when test="@rules = 'colgroups'">
        <xsl:text>colgroups</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>\begin{tabular}{</xsl:text>
  <xsl:for-each select="exsl:node-set($cols)/*">
    <xsl:choose>
      <xsl:when test="self::mal:colgroup">
        <xsl:if test="$colrules = 'colgroups'">
          <xsl:text>|</xsl:text>
        </xsl:if>
        <xsl:for-each select="mal:col">
          <xsl:if test="$colrules = 'cols'">
            <xsl:text>|</xsl:text>
          </xsl:if>
          <xsl:text>l</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="self::mal:col">
        <xsl:if test="$colrules = 'cols'">
          <xsl:text>|</xsl:text>
        </xsl:if>
        <xsl:text>l</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>
  <xsl:if test="$colrules != ''">
    <xsl:text>|</xsl:text>
  </xsl:if>
  <xsl:text>}&#x000A;</xsl:text>
  <xsl:for-each select="mal:tr | mal:thead/mal:tr | mal:tfoot/mal:tr | mal:tbody/mal:tr">
    <xsl:for-each select="mal:td">
      <xsl:text>\begin{minipage}{1in}&#x000A;</xsl:text>
      <xsl:apply-templates mode="mal2latex.block.mode"/>
      <xsl:text>\end{minipage}</xsl:text>
      <xsl:choose>
        <xsl:when test="position() = last()">
          <xsl:text>\\&#x000A;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> &amp; </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:for-each>
  <xsl:text>\end{tabular}&#x000A;</xsl:text>
  <xsl:text>\par&#x000A;</xsl:text>
</xsl:template>

</xsl:stylesheet>
