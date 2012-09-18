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
            <xsl:with-param name="asciiString" select="'Man'"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>&#x0A;decoded MQ== is </xsl:text>
        <xsl:call-template name="b64:decode">
            <xsl:with-param name="base64String" select="'MQ=='"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
```

Output:
```
encoded Man is TWFu
decoded MQ== is 1
```
Also supports 'url safe' and 'no padding' syntax via params to b64:encode template