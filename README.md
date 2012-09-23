Library to represent binary data in an ASCII characters.
Base64-encoded data takes about 33% more space than the original data.
Allows encoding and decoding

Usage example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:b64="https://github.com/ilyakharlamov/xslt_base64"
    version="1.0">
    <xsl:output method="text"/>
    <xsl:include href="base64.xsl"/>
    <xsl:template match="/">
        <xsl:text>encoded Man is </xsl:text>
        <xsl:call-template name="b64:encode">
            <xsl:with-param name="asciiString" select="'Man'"/>
        </xsl:call-template>
        <xsl:text>&#x0A;encoded 1 with padding is </xsl:text>
        <xsl:call-template name="b64:encode">
            <xsl:with-param name="asciiString" select="'1'"/>
        </xsl:call-template>
        <xsl:text>&#x0A;encoded 1 without padding is </xsl:text>
        <xsl:call-template name="b64:encode">
            <xsl:with-param name="asciiString" select="'1'"/>
            <xsl:with-param name="padding" select="false()"/>
        </xsl:call-template>
        <xsl:text>&#x0A;encoded ..a?&lt;&gt;???!????? as regular is </xsl:text>
        <xsl:call-template name="b64:encode">
            <xsl:with-param name="asciiString" select="'..a?&lt;&gt;???!?????'"/>
        </xsl:call-template>
        <xsl:text>&#x0A;encoded ..a?&lt;&gt;???!????? as urlsafe is </xsl:text>
        <xsl:call-template name="b64:encode">
            <xsl:with-param name="asciiString" select="'..a?&lt;&gt;???!?????'"/>
            <xsl:with-param name="urlsafe" select="true()"/>
        </xsl:call-template>
        <xsl:text>&#x0A;decoded MQ== is </xsl:text>
        <xsl:call-template name="b64:decode">
            <xsl:with-param name="base64String" select="'MQ=='"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
```

Output:
<pre>encoded Man is TWFu
encoded 1 with padding is MQ==
encoded 1 without padding is MQ
encoded ..a?<>???!????? as regular is Li5hPzw+Pz8/IT8/Pz8/
encoded ..a?<>???!????? as urlsafe is Li5hPzw-Pz8_IT8_Pz8_
decoded MQ== is 1</pre>

Also supports 'url safe' and 'no padding' syntax via params to b64:encode template