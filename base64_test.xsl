<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:b64="https://github.com/ilyakharlamov/xslt_base64"
    xmlns:b64local="http://localhost/base64.xsl"
    version="1.0">
    <xsl:import href="base64.xsl"/>
    <xsl:template match="/">
        <xsl:call-template name="b64local:asciiStringToBinary">
            <xsl:with-param name="string" select="'AA'">
            </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#x0A;</xsl:text>
        <xsl:value-of select="1 mod 2"/>
    </xsl:template>
    
    <xsl:template name="pow">
        <xsl:param name="m"/>
        <xsl:param name="n"/>
        <xsl:param name="result"/>
        <xsl:choose>
            <xsl:when test="$n &gt;= 1">
                <xsl:call-template name="pow">
                    <xsl:with-param name="m" select="$m"/>
                    <xsl:with-param name="n" select="$n - 1"/>
                    <xsl:with-param name="result" select="$result * $m"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$result"/>
            </xsl:otherwise>			
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>