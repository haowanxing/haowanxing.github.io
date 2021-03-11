<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Author:Anthony
uid:201321092028
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="html" encoding="gb2312"/>
<xsl:template match="/">
	<html>
		<head>
			<title>BOOKS</title>
		</head>
		<body>
			<h2 align="center">BOOKS</h2>
			<xsl:apply-templates select="BOOKS"/>
		</body>
	</html>
</xsl:template>
<xsl:template match="BOOKS">
	<table border="1" cellpadding="0" align="center">
		<tbody>
			<tr>
				<th>NAME</th><th>PUBLISHER</th><th>PRICE</th><th>DESCROPTION</th><th>STATUS</th>
			</tr>
			<xsl:for-each select="BOOK">
			<tr>
				<td><xsl:value-of select="NAME"/></td>
				<td><xsl:value-of select="PUBLISHER"/></td>
				<td><xsl:value-of select="PRICE"/></td>
				<td><xsl:value-of select="DESCRIPTION"/></td>
				<td><xsl:value-of select="STATUS"/></td>
			</tr>
			</xsl:for-each>
		</tbody>
	</table>
</xsl:template>
</xsl:stylesheet>
