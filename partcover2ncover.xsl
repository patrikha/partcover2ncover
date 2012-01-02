<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxml="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" version="1.0" indent="yes"/>
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>href="coverage.xsl" type="text/xsl"</xsl:text>
		</xsl:processing-instruction>
		<xsl:variable name="now" select="current-dateTime()"/>
		<xsl:variable name="date" select="/PartCoverReport[@version='4.0']/@date"/>
		<coverage profilerVersion="1.5.8 Beta" driverVersion="1.5.8.0" startTime="{$date}" measureTime="{format-dateTime($now, '[Y]-[M]-[D]T[H]:[m]:[s].[f][Z]')}">
			<xsl:for-each select="/PartCoverReport[@version='4.0']/Assembly">
				<xsl:variable name="id" select="./@id"/>
				<xsl:variable name="name" select="./@module"/>
				<xsl:variable name="assembly" select="./@name"/>
				<module moduleId="{$id}" name="{$name}" assembly="{$assembly}" assemblyIdentity="{$assembly}">
					<xsl:for-each select="/PartCoverReport[@version='4.0']/Type[@asmref=$id]">
						<xsl:variable name="class" select="./@name"/>
						<xsl:for-each select="./Method">
							<xsl:variable name="name" select="./@name"/>
							<method name="{$name}" excluded="false" instrumented="true" class="{$class}">
								<xsl:for-each select="./pt">
									<xsl:variable name="visitcount" select="./@visit"/>
									<xsl:variable name="line" select="./@sl"/>
									<xsl:variable name="column" select="./@sc"/>
									<xsl:variable name="endline" select="./@el"/>
									<xsl:variable name="endcolumn" select="./@ec"/>
									<xsl:variable name="fid" select="./@fid"/>
									<xsl:variable name="document" select="/PartCoverReport[@version='4.0']/File[@id=$fid]/@url"/>
									<seqpnt visitcount="{$visitcount}" line="{$line}" column="{$column}" endline="{$endline}" endcolumn="{$endcolumn}" excluded="false" document="{$document}"/>
								</xsl:for-each>
							</method>
						</xsl:for-each>
					</xsl:for-each>
				</module>
			</xsl:for-each>
		</coverage>
	</xsl:template>
</xsl:stylesheet>
