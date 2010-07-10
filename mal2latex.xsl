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
                xmlns:cache="http://projectmallard.org/cache/1.0/"
                xmlns:mal="http://projectmallard.org/1.0/"
                exclude-result-prefixes="exsl mal"
                version="1.0">

<xsl:import href="/usr/share/yelp-xsl/xslt/common/color.xsl"/>
<xsl:import href="/usr/share/yelp-xsl/xslt/common/utils.xsl"/>
<xsl:import href="/usr/share/yelp-xsl/xslt/mallard/common/mal-link.xsl"/>
<xsl:import href="/usr/share/yelp-xsl/xslt/mallard/common/mal-sort.xsl"/>

<xsl:include href="mal2latex-block.xsl"/>
<xsl:include href="mal2latex-inline.xsl"/>
<xsl:include href="mal2latex-table.xsl"/>

<xsl:output method="text"/>

<xsl:param name="mal.cache" select="/cache:cache"/>

<xsl:template name="hex2dec">
  <xsl:param name="hex"/>
  <xsl:variable name="l">
    <xsl:choose>
      <xsl:when test="contains('0123456789', substring($hex, 1, 1))">
        <xsl:value-of select="number(substring($hex, 1, 1))"/>
      </xsl:when>
      <xsl:when test="contains('Aa', substring($hex, 1, 1))">
        <xsl:value-of select="10"/>
      </xsl:when>
      <xsl:when test="contains('Bb', substring($hex, 1, 1))">
        <xsl:value-of select="11"/>
      </xsl:when>
      <xsl:when test="contains('Cc', substring($hex, 1, 1))">
        <xsl:value-of select="12"/>
      </xsl:when>
      <xsl:when test="contains('Dd', substring($hex, 1, 1))">
        <xsl:value-of select="13"/>
      </xsl:when>
      <xsl:when test="contains('Ee', substring($hex, 1, 1))">
        <xsl:value-of select="14"/>
      </xsl:when>
      <xsl:when test="contains('Ff', substring($hex, 1, 1))">
        <xsl:value-of select="15"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="r">
    <xsl:choose>
      <xsl:when test="contains('0123456789', substring($hex, 2, 1))">
        <xsl:value-of select="number(substring($hex, 2, 1))"/>
      </xsl:when>
      <xsl:when test="contains('Aa', substring($hex, 2, 1))">
        <xsl:value-of select="10"/>
      </xsl:when>
      <xsl:when test="contains('Bb', substring($hex, 2, 1))">
        <xsl:value-of select="11"/>
      </xsl:when>
      <xsl:when test="contains('Cc', substring($hex, 2, 1))">
        <xsl:value-of select="12"/>
      </xsl:when>
      <xsl:when test="contains('Dd', substring($hex, 2, 1))">
        <xsl:value-of select="13"/>
      </xsl:when>
      <xsl:when test="contains('Ee', substring($hex, 2, 1))">
        <xsl:value-of select="14"/>
      </xsl:when>
      <xsl:when test="contains('Ff', substring($hex, 2, 1))">
        <xsl:value-of select="15"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="(16 * $l) + $r"/>
</xsl:template>

<xsl:template name="convert.color">
  <xsl:param name="color"/>
  <xsl:call-template name="hex2dec">
    <xsl:with-param name="hex" select="substring($color, 2, 2)"/>
  </xsl:call-template>
  <xsl:text>,</xsl:text>
  <xsl:call-template name="hex2dec">
    <xsl:with-param name="hex" select="substring($color, 4, 2)"/>
  </xsl:call-template>
  <xsl:text>,</xsl:text>
  <xsl:call-template name="hex2dec">
    <xsl:with-param name="hex" select="substring($color, 6, 2)"/>
  </xsl:call-template>
</xsl:template>

<xsl:variable name="blue_border">
  <xsl:call-template name="convert.color">
    <xsl:with-param name="color" select="$color.blue_border"/>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="gray_background">
  <xsl:call-template name="convert.color">
    <xsl:with-param name="color" select="$color.gray_background"/>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="yellow_background">
  <xsl:call-template name="convert.color">
    <xsl:with-param name="color" select="$color.yellow_background"/>
  </xsl:call-template>
</xsl:variable>

<xsl:variable name="yellow_border">
  <xsl:call-template name="convert.color">
    <xsl:with-param name="color" select="$color.yellow_border"/>
  </xsl:call-template>
</xsl:variable>

<xsl:template name="sty">
<xsl:text>
\usepackage{fullpage}
\usepackage[utf8]{inputenc}
\usepackage{alltt}
\usepackage{boxedminipage}
\usepackage{color}
\definecolor{blueborder}{RGB}{</xsl:text><xsl:value-of select="$blue_border"/><xsl:text>}
\definecolor{grayback}{RGB}{</xsl:text><xsl:value-of select="$gray_background"/><xsl:text>}
\definecolor{yellowback}{RGB}{</xsl:text><xsl:value-of select="$yellow_background"/><xsl:text>}
\definecolor{yellowborder}{RGB}{</xsl:text><xsl:value-of select="$yellow_border"/><xsl:text>}
\setlength{\parindent}{0in}
\setlength{\parskip}{1em}
\newenvironment{malexample}%
{\hskip -10pt \vrule width 2pt \hskip 8pt%
\begin{minipage}{\textwidth}%
\setlength{\parskip}{1em}}%
{\end{minipage}%
\par}
\newsavebox{\malnotecontainer}
\newenvironment{malnote}{%
\begin{lrbox}{\malnotecontainer}%
\begin{minipage}{\textwidth}}%
{\end{minipage}%
\end{lrbox}%
\fcolorbox{yellowborder}{yellowback}{\usebox{\malnotecontainer}}\par}
\newsavebox{\malscreencontainer}
\newenvironment{malscreen}{%
\begin{lrbox}{\malscreencontainer}%
\begin{minipage}{\textwidth}%
\begin{alltt}}%
{\end{alltt}%
\end{minipage}%
\end{lrbox}%
\fcolorbox{grayback}{grayback}{\usebox{\malscreencontainer}}\par}
\newsavebox{\malstepscontainer}
\newenvironment{malsteps}{%
\begin{lrbox}{\malstepscontainer}%
\begin{minipage}{\textwidth}%
\begin{enumerate}}%
{\end{enumerate}%
\end{minipage}%
\end{lrbox}%
\fcolorbox{blueborder}{yellowback}{\usebox{\malstepscontainer}}\par}
</xsl:text>
</xsl:template>

<xsl:template match="/cache:cache">
  <xsl:text>\documentclass{article}&#x000A;</xsl:text>
  <xsl:call-template name="sty"/>
  <xsl:text>\begin{document}&#x000A;</xsl:text>
  <xsl:variable name="sorted">
    <xsl:call-template name="mal.sort.tsort"/>
  </xsl:variable>
  <xsl:for-each select="exsl:node-set($sorted)/mal:link">
    <xsl:variable name="linkid">
      <xsl:call-template name="mal.link.xref.linkid"/>
    </xsl:variable>
    <xsl:for-each select="$mal.cache">
      <xsl:apply-templates select="document(key('mal.cache.key', $linkid)/@cache:href, /)/mal:page"/>
    </xsl:for-each>
  </xsl:for-each>
  <xsl:text>&#x000A;\end{document}&#x000A;</xsl:text>
</xsl:template>

<xsl:template match="mal:page">
  <xsl:text>\pagebreak&#x000A;\section{</xsl:text>
  <xsl:value-of select="mal:title"/>
  <xsl:text>}&#x000A;</xsl:text>
  <xsl:apply-templates mode="mal2latex.block.mode"
                       select="*[not(self::mal:info or self::mal:title or self::mal:subtitle or self::mal:section)]"/>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

<xsl:template match="mal:section">
  <xsl:choose>
    <xsl:when test="count(ancestor::mal:section) = 0">
      <xsl:text>\subsection*{</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\subsubsection*{</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="mal:title"/>
  <xsl:text>}&#x000A;</xsl:text>
  <xsl:apply-templates mode="mal2latex.block.mode"
                       select="*[not(self::mal:info or self::mal:title or self::mal:subtitle or self::mal:section)]"/>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

</xsl:stylesheet>
