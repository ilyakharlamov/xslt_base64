<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:b64="https://github.com/ilyakharlamov/xslt_base64" 
	xmlns:local="http://localhost/base64.xsl"
	xmlns:test="http://localhost/test">
	<xsl:variable name="datamap" select="document('base64_datamap.xml')"/>
	<xsl:variable name="binarydatamap" select="document('base64_binarydatamap.xml')"/>
	

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

	<!-- Template to convert the Ascii string into base64 representation -->
	<xsl:template name="b64:encode">
		<xsl:param name="asciiString"/>
		<xsl:param name="padding" select="true()"/>
		<xsl:param name="urlsafe" select="false()"/>
		<xsl:variable name="result">
			<xsl:variable name="binary">
				<xsl:call-template name="local:asciiStringToBinary">
					<xsl:with-param name="string" select="$asciiString"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:binaryToBase64">
				<xsl:with-param name="binary" select="$binary"/>
				<xsl:with-param name="padding" select="$padding"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$urlsafe">
				<xsl:value-of select="translate($result,'+/','-_')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$result"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="local:binaryToBase64">
		<xsl:param name="binary"/>
		<xsl:param name="padding"/>
		<xsl:call-template name="local:sixbitToBase64">
			<xsl:with-param name="sixbit" select="substring($binary, 1, 6)"/>
			<xsl:with-param name="padding" select="$padding"/>
		</xsl:call-template>
		<xsl:call-template name="local:sixbitToBase64">
			<xsl:with-param name="sixbit" select="substring($binary, 7, 6)"/>
			<xsl:with-param name="padding" select="$padding"/>
		</xsl:call-template>
		<xsl:call-template name="local:sixbitToBase64">
			<xsl:with-param name="sixbit" select="substring($binary, 13, 6)"/>
			<xsl:with-param name="padding" select="$padding"/>
		</xsl:call-template>
		<xsl:call-template name="local:sixbitToBase64">
			<xsl:with-param name="sixbit" select="substring($binary, 19, 6)"/>
			<xsl:with-param name="padding" select="$padding"/>
		</xsl:call-template>
		<xsl:variable name="remaining" select="substring($binary, 25)"/>
		<xsl:if test="$remaining != ''">
			<xsl:call-template name="local:binaryToBase64">
				<xsl:with-param name="binary" select="$remaining"/>
				<xsl:with-param name="padding" select="$padding"/>
			</xsl:call-template>
		</xsl:if>		
	</xsl:template>
	<xsl:template name="local:sixbitToBase64">
		<xsl:param name="sixbit"/>
		<xsl:param name="padding"/>
		<xsl:variable name="len" select="string-length($sixbit)"></xsl:variable>
		<xsl:variable name="realsixbit">
			<xsl:value-of select="$sixbit"/>
			<xsl:if test="$len=1">00000</xsl:if>
			<xsl:if test="$len=2">0000</xsl:if>
			<xsl:if test="$len=3">000</xsl:if>
			<xsl:if test="$len=4">00</xsl:if>
			<xsl:if test="$len=5">0</xsl:if>
		</xsl:variable>
		<xsl:variable name="result" select="$binarydatamap/datamap/binarybase64/item[binary = $realsixbit]/base64/text()"/>
		<xsl:value-of select="$result"/>
		<xsl:if test="string-length($realsixbit) = 0 and $padding">=</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="b64:encode2">
		<xsl:param name="asciiString"/>
		<xsl:param name="padding" select="true()"/>
		<xsl:param name="urlsafe" select="false()"/>
		<xsl:variable name="binaryAsciiString">
			<xsl:call-template name="local:asciiStringToBinary">
				<xsl:with-param name="string" select="substring($asciiString, 1, 3)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:variable name="digit1">
				<xsl:call-template name="local:binaryToDecimal">
					<xsl:with-param name="binary" select="substring($binaryAsciiString, 1, 6)"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length($asciiString) &gt;= 3">
					<xsl:variable name="digit2">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary" select="substring($binaryAsciiString, 7, 6)"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="digit3">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary" select="substring($binaryAsciiString, 13, 6)"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="digit4">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary" select="substring($binaryAsciiString, 19, 6)"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit1]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit2]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit3]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit4]/base64"/>
					<xsl:call-template name="b64:encode">
						<xsl:with-param name="asciiString" select="substring($asciiString, 4)"/>
						<xsl:with-param name="padding" select="$padding"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="string-length($asciiString) = 2">
					<xsl:variable name="digit2">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary" select="substring($binaryAsciiString, 7, 6)"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="digit3">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary"
								select="concat(substring($binaryAsciiString, 13), '00')"/>
						</xsl:call-template>
					</xsl:variable>
					
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit1]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit2]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit3]/base64"/>
					<xsl:if test="$padding">=</xsl:if>
				</xsl:when>
				
				<xsl:when test="string-length($asciiString) = 1">
					<xsl:variable name="digit2">
						<xsl:call-template name="local:binaryToDecimal">
							<xsl:with-param name="binary"
								select="concat(substring($binaryAsciiString, 7),'0000')"/>
							<xsl:with-param name="sum" select="0"/>
							<xsl:with-param name="index" select="0"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit1]/base64"/>
					<xsl:value-of select="$datamap/datamap/decimalbase64/item[decimal = $digit2]/base64"/>
					<xsl:if test="$padding">==</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		

		<xsl:choose>
			<xsl:when test="$urlsafe">
				<xsl:value-of select="translate($result,'+/','-_')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$result"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template to convert a binary number to decimal representation; this template calls template pow -->
	<xsl:template name="local:binaryToDecimal">
		<xsl:param name="binary"/>
		<xsl:param name="sum" select="0"/>
		<xsl:param name="index" select="0"/>
		<xsl:choose>
			<xsl:when test="substring($binary,string-length($binary) - 1) != ''">
				<xsl:variable name="power">
					<xsl:call-template name="local:pow">
						<xsl:with-param name="m" select="2"/>
						<xsl:with-param name="n" select="$index"/>
						<xsl:with-param name="result" select="1"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="local:binaryToDecimal">
					<xsl:with-param name="binary"
						select="substring($binary, 1, string-length($binary) - 1)"/>
					<xsl:with-param name="sum"
						select="$sum + substring($binary,string-length($binary) ) * $power"/>
					<xsl:with-param name="index" select="$index + 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sum"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template to calculate m to the power n -->
	<!--xsl:template name="local:pow">
		<xsl:param name="m"/>
		<xsl:param name="n"/>
		<xsl:param name="result"/>
		<xsl:if test="$n &gt;= 1">
			<xsl:call-template name="local:pow">
				<xsl:with-param name="m" select="$m"/>
				<xsl:with-param name="n" select="$n - 1"/>
				<xsl:with-param name="result" select="$result * $m"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$n = 0">
			<xsl:value-of select="$result"/>
		</xsl:if>
	</xsl:template-->

	<xsl:template name="local:pow">
		<xsl:param name="m"/>
		<xsl:param name="n"/>
		<xsl:param name="result"/>
		<xsl:choose>
			<xsl:when test="$n = 0">
				<xsl:value-of select="$result"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="local:pow">
					<xsl:with-param name="m" select="$m"/>
					<xsl:with-param name="n" select="$n - 1"/>
					<xsl:with-param name="result" select="$result * $m"/>
				</xsl:call-template>				
			</xsl:otherwise>			
		</xsl:choose>
		
	</xsl:template>

	<!-- Template to convert an ascii string to binary representation; this template calls template decimalToBinary -->
	<xsl:template name="local:asciiStringToBinary">
		<xsl:param name="string"/>
		<xsl:variable name="char" select="substring($string, 1, 1)"/>
		<xsl:if test="$char != ''">
			<xsl:variable name="binary" select="$binarydatamap/datamap/asciibinary/item[ascii = $char]/binary"/>
			<xsl:choose>
				<xsl:when test="string-length($binary) = 6">
					<xsl:text>00</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$binary"/>
		</xsl:if>
		<xsl:variable name="remaining" select="substring($string, 2)"/>
		<xsl:if test="$remaining != ''">
			<xsl:call-template name="local:asciiStringToBinary">
				<xsl:with-param name="string" select="$remaining"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Template to convert a decimal number to binary representation -->
	<xsl:template name="local:decimalToBinary">
		<xsl:param name="decimal"/>
		<xsl:param name="prev" select="''"/>

		<xsl:variable name="divresult" select="floor($decimal div 2)"/>
		<xsl:variable name="modresult" select="$decimal mod 2"/>
		<xsl:choose>
			<xsl:when test="$divresult &gt; 1">
				<xsl:call-template name="local:decimalToBinary">
					<xsl:with-param name="decimal" select="$divresult"/>
					<xsl:with-param name="prev" select="concat($modresult, $prev)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$divresult = 0">
				<xsl:value-of select="concat($modresult, $prev)"/>
			</xsl:when>
			<xsl:when test="$divresult = 1">
				<xsl:text>1</xsl:text>
				<xsl:value-of select="concat($modresult, $prev)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Template to convert the base64 string to ascii representation -->
	<xsl:template name="b64:decode">
		<xsl:param name="base64String"/>
		<!-- support for urlsafe -->
		<xsl:variable name="base64StringUniversal" select="translate($base64String, '-_','+/')"/>
		<!-- execute if last 2 characters do not contain = character-->
		<xsl:if
			test="not(contains(substring($base64StringUniversal, string-length($base64StringUniversal) - 1), '='))">
			<xsl:variable name="binaryBase64String">
				<xsl:call-template name="local:base64StringToBinary">
					<xsl:with-param name="string" select="$base64StringUniversal"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="$binaryBase64String"/>
			</xsl:call-template>
		</xsl:if>

		<!-- extract last two characters -->
		<xsl:variable name="secondLastChar"
			select="substring($base64StringUniversal, string-length($base64StringUniversal) - 1, 1)"/>
		<xsl:variable name="lastChar"
			select="substring($base64StringUniversal, string-length($base64StringUniversal), 1)"/>

		<!-- execute if 2nd last character is not a =, and last character is = -->
		<xsl:if test="($secondLastChar != '=') and ($lastChar = '=')">
			<xsl:variable name="binaryBase64String">
				<xsl:call-template name="local:base64StringToBinary">
					<xsl:with-param name="string"
						select="substring($base64StringUniversal, 1, string-length($base64StringUniversal) - 4)"
					/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="$binaryBase64String"/>
			</xsl:call-template>
			<xsl:variable name="partialBinary">
				<xsl:call-template name="local:base64StringToBinary">
					<xsl:with-param name="string"
						select="substring($base64StringUniversal, string-length($base64StringUniversal) - 3, 3)"
					/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="substring($partialBinary, 1, 8)"/>
			</xsl:call-template>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="substring($partialBinary, 9, 8)"/>
			</xsl:call-template>
		</xsl:if>

		<!-- execute if last 2 characters are both = -->
		<xsl:if test="($secondLastChar = '=') and ($lastChar = '=')">
			<xsl:variable name="binaryBase64String">
				<xsl:call-template name="local:base64StringToBinary">
					<xsl:with-param name="string"
						select="substring($base64StringUniversal, 1, string-length($base64StringUniversal) - 4)"
					/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="$binaryBase64String"/>
			</xsl:call-template>
			<xsl:variable name="partialBinary">
				<xsl:call-template name="local:base64StringToBinary">
					<xsl:with-param name="string"
						select="substring($base64StringUniversal, string-length($base64StringUniversal) - 3, 2)"
					/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="substring($partialBinary, 1, 8)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Template to convert the base64 binary string to ascii representation -->
	<xsl:template name="local:base64BinaryStringToAscii">
		<xsl:param name="binaryString"/>
		<xsl:if test="substring($binaryString, 1, 8) != ''">
			<xsl:variable name="asciiDecimal">
				<xsl:call-template name="local:binaryToDecimal">
					<xsl:with-param name="binary" select="substring($binaryString, 1, 8)"/>
					<xsl:with-param name="sum" select="0"/>
					<xsl:with-param name="index" select="0"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$datamap/datamap/asciidecimal/item[decimal = $asciiDecimal]/ascii"/>
			<xsl:call-template name="local:base64BinaryStringToAscii">
				<xsl:with-param name="binaryString" select="substring($binaryString, 9)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Template to convert a base64 string to binary representation; this template calls template decimalToBinary -->
	<xsl:template name="local:base64StringToBinary">
		<xsl:param name="string"/>

		<xsl:if test="substring($string, 1, 1) != ''">
			<xsl:variable name="binary">
				<xsl:call-template name="local:decimalToBinary">
					<xsl:with-param name="decimal"
						select="$datamap/datamap/decimalbase64/item[base64 = substring($string, 1, 1)]/decimal"/>
					<xsl:with-param name="prev" select="''"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="local:padZeros">
				<xsl:with-param name="string" select="$binary"/>
				<xsl:with-param name="no" select="6 - string-length($binary)"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="substring($string, 2) != ''">
			<xsl:call-template name="local:base64StringToBinary">
				<xsl:with-param name="string" select="substring($string, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Template to left pad a binary string, with the specified no of 0s, to make it of length 6 -->
	<xsl:template name="local:padZeros">
		<xsl:param name="string"/>
		<xsl:param name="no"/>

		<xsl:if test="$no &gt; 0">
			<xsl:call-template name="local:padZeros">
				<xsl:with-param name="string" select="concat('0', $string)"/>
				<xsl:with-param name="no" select="6 - string-length($string) - 1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$no = 0">
			<xsl:value-of select="$string"/>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>
