<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:template name="repeater">
		<xsl:param name="theString" select="''"/>
		<xsl:param name="numberOfTimes" select="0"/>
		<xsl:if test="$numberOfTimes > 0">
			<xsl:value-of select="$theString"/>
			<xsl:call-template name="repeater">
				<xsl:with-param name="theString" select="$theString"/>
				<xsl:with-param name="numberOfTimes" select="$numberOfTimes - 1"/>
			</xsl:call-template>		
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="replace">
		<xsl:param name="text"/>
		<!--<xsl:param name="replace"/>-->
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="contains($text,'&#10;')">
				<xsl:value-of select="substring-before($text,'&#10;')"/>
				<xsl:value-of select="$by"/>
				<xsl:call-template name="replace">
					<xsl:with-param name="text" select="substring-after($text,'&#10;')"/>
					<!--<xsl:with-param name="replace" select="$replace"/>-->
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:output method="text" encoding="UTF-8" />
	<xsl:strip-space elements="*"/>

	<xsl:template match="/map/node">
		<xsl:value-of select="@TEXT"/><xsl:text>&#10;</xsl:text>
		<xsl:call-template name="repeater">
			<xsl:with-param name="theString" select="'='"/>
			<xsl:with-param name="numberOfTimes" select="string-length(@TEXT)"/>
		</xsl:call-template>
		<xsl:text>&#10;&#10;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="/map/node/node">
		<xsl:text>&#10;&#10;</xsl:text>
		<xsl:value-of select="@TEXT"/><xsl:text>&#10;</xsl:text>
		<xsl:call-template name="repeater">
			<xsl:with-param name="theString" select="'-'"/>
			<xsl:with-param name="numberOfTimes" select="string-length(@TEXT)"/>
		</xsl:call-template>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="hook[@NAME='accessories/plugins/NodeNote.properties']/text">
		<xsl:text>&#10;&#10;</xsl:text>
		<xsl:variable name="indent">
			<xsl:call-template name="repeater">
				<xsl:with-param name="theString" select="'  '"/>
				<xsl:with-param name="numberOfTimes" select="count(ancestor::*) - 4"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$indent"/>
		<xsl:call-template name="replace">
			<xsl:with-param name="text" select="text()"/>
			<xsl:with-param name="by" select="concat('&#10;', $indent)"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="node[not(child::icon) and not(count(ancestor::*) &lt;= 2)]">
		<xsl:text>&#10;&#10;</xsl:text>
		<xsl:call-template name="repeater">
			<xsl:with-param name="theString" select="'  '"/>
			<xsl:with-param name="numberOfTimes" select="count(ancestor::*) - 3"/>
		</xsl:call-template>
		<xsl:text>* </xsl:text><xsl:value-of select="@TEXT"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="node[child::icon]">
		<xsl:text>&#10;&#10;</xsl:text>
		<xsl:call-template name="repeater">
			<xsl:with-param name="theString" select="'  '"/>
			<xsl:with-param name="numberOfTimes" select="count(ancestor::*) - 3"/>
		</xsl:call-template>
		<xsl:text>.. </xsl:text><xsl:value-of select="@TEXT"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="icon"/>
</xsl:stylesheet>
