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
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="mal str"
                version="1.0">

<xsl:template mode="mal.link.content.mode" match="*">
  <xsl:apply-templates mode="mal2latex.inline.mode" select="."/>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:app">
  <xsl:text>\textit{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:cmd">
  <xsl:text>\framebox{\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:code">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:em">
  <xsl:text>\textit{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:file">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:gui">
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:guiseq">
  <xsl:for-each select="* | text()[normalize-space(.) != '']">
    <xsl:if test="position() != 1">
      <xsl:text> \verb|>| </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="mal2latex.inline.mode" select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:input">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:key">
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:keyseq">
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="@type = 'sequence'">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' hyphen ')">
        <xsl:text>-</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>+</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="* | text()[normalize-space(.) != '']">
    <xsl:if test="position() != 1">
      <xsl:value-of select="$joinchar"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="./self::text()">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mal2latex.inline.mode" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:link">
  <xsl:choose>
    <xsl:when test="@xref and normalize-space(.) = ''">
      <xsl:call-template name="mal.link.content">
        <xsl:with-param name="role" select="@role"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="mal2latex.inline.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:span">
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:output">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:sys">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="mal:var">
  <xsl:text>\textit{</xsl:text>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched inline element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates mode="mal2latex.inline.mode"/>
</xsl:template>

<xsl:template mode="mal2latex.inline.mode" match="text()"
              name="mal2latex.inline.escape">
  <xsl:param name="node" select="."/>
  <xsl:param name="text" select="string(.)"/>
  <xsl:variable name="verbatim"
                select="$node/ancestor::mal:code or $node/ancestor::mal:screen "/>
  <xsl:for-each select="str:split($text, '')">
    <xsl:choose>
      <xsl:when test=". = '&#x000A;'">
        <xsl:choose>
          <xsl:when test="$verbatim">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test=". = '&lt;'">
        <xsl:text>{\textless}</xsl:text>
      </xsl:when>
      <xsl:when test=". = '&gt;'">
        <xsl:text>{\textgreater}</xsl:text>
      </xsl:when>
      <xsl:when test=". = '\'">
        <xsl:text>{\textbackslash}</xsl:text>
      </xsl:when>
      <xsl:when test="contains('$&amp;#_{}', .)">
        <xsl:text>\</xsl:text>
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
