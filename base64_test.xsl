<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:b64="https://github.com/ilyakharlamov/xslt_base64"
    xmlns:b64local="http://localhost/base64.xsl"
    xmlns:test="http://localhost/base64_test.xsl"
    version="1.0">
    <xsl:import href="base64.xsl"/>
    <xsl:template match="/">
        <xsl:call-template name="test:encodeEquals">
            <xsl:with-param name="expected" select="'MQ=='"/>
            <xsl:with-param name="source" select="'1'"/>
            <xsl:with-param name="name" select="'Digit to b64'"/>
        </xsl:call-template>
        <xsl:call-template name="test:encodeEquals">
            <xsl:with-param name="expected" select="'TWFu'"/>
            <xsl:with-param name="source" select="'Man'"/>
            <xsl:with-param name="name" select="'Digit to b64'"/>
        </xsl:call-template>
        <xsl:call-template name="test:test">
            <xsl:with-param name="asciiString" select="'Hello World!'"/>
        </xsl:call-template>
        <xsl:call-template name="test:test">
            <xsl:with-param name="asciiString" select="'This is a base64 encoding'"/>
        </xsl:call-template>
        <xsl:call-template name="test:test">
            <xsl:with-param name="asciiString" select="'1'"/>
        </xsl:call-template>
        <xsl:call-template name="test:decodeEquals">
            <xsl:with-param name="expected" select="'1'"/>
            <xsl:with-param name="encodedResult" select="'MQ'"/>
            <xsl:with-param name="name" select="'Missing padding'"/>
        </xsl:call-template>
        <xsl:call-template name="test:equals">
            <xsl:with-param name="expected" select="'UGFyYWdyYXBoU3R5bGUvU3RvcnkgQm9keQ'"/>
            <xsl:with-param name="result">
                <xsl:call-template name="b64:encode">
                    <xsl:with-param name="asciiString" select="'ParagraphStyle/Story Body'"/>
                    <xsl:with-param name="padding" select="false()"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="name" select="'nopadding'"/>
        </xsl:call-template>
        <xsl:call-template name="test:equals">
            <xsl:with-param name="expected" select="'Li5hPzw-Pz8_'"></xsl:with-param>
            <xsl:with-param name="result">
                <xsl:call-template name="b64:encode">
                    <xsl:with-param name="asciiString" select="'..a?&lt;&gt;???'"/>
                    <xsl:with-param name="padding" select="false()"/>
                    <xsl:with-param name="urlsafe" select="true()"></xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="name" select="'urls'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="test:test">
        <xsl:param name="asciiString"/>
        <xsl:variable name="encoded">
            <xsl:variable name="tmp">
                <xsl:call-template name="b64:encode">
                    <xsl:with-param name="asciiString" select="$asciiString"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="normalize-space($tmp)"/>
        </xsl:variable>
        <xsl:text>String text '</xsl:text>
        <xsl:value-of select="$asciiString"/>
        <xsl:text>' is '</xsl:text>
        <xsl:value-of select="$encoded"/>
        <xsl:text>'</xsl:text>
        <xsl:variable name="decoded">
            <xsl:call-template name="b64:decode">
                <xsl:with-param name="base64String" select="$encoded"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$asciiString = $decoded">
                <xsl:text>&#xa;Decode is OK</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Decode failed: '</xsl:text>
                <xsl:value-of select="$decoded"/>
                <xsl:text>'</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;------------------------&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template name="test:equals">
        <xsl:param name="expected"/>
        <xsl:param name="result"/>
        <xsl:param name="name"/>
        <xsl:choose>
            <xsl:when test="$expected = $result">
                <xsl:text>Test '</xsl:text>
                <xsl:value-of select="$name"/>
                <xsl:text>' PASSED&#xa;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Test '</xsl:text>
                <xsl:value-of select="$name"/>
                <xsl:text>' FAILED. Expected: '</xsl:text>
                <xsl:value-of select="$expected"/>
                <xsl:text>' but result was: '</xsl:text>
                <xsl:value-of select="$result"/>
                <xsl:text>'&#xa;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="test:decodeEquals">
        <xsl:param name="expected"/>
        <xsl:param name="encodedResult"/>
        <xsl:param name="name"/>
        <xsl:variable name="tmp">
            <xsl:call-template name="b64:decode">
                <xsl:with-param name="base64String" select="normalize-space($encodedResult)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="test:equals">
            <xsl:with-param name="expected" select="normalize-space($expected)"/>
            <xsl:with-param name="result" select="normalize-space($tmp)"/>
            <xsl:with-param name="name" select="$name"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="test:encodeEquals">
        <xsl:param name="expected"/>
        <xsl:param name="source"/>
        <xsl:param name="name"/>
        <xsl:variable name="tmp">
            <xsl:call-template name="b64:encode">
                <xsl:with-param name="asciiString" select="$source"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="test:equals">
            <xsl:with-param name="expected" select="$expected"/>
            <xsl:with-param name="result" select="normalize-space($tmp)"/>
            <xsl:with-param name="name" select="$name"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>