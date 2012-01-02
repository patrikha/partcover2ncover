<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxml="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" version="1.0" indent="yes"/>
	<xsl:param name="coveragefile"/>
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>href="CoverageReport.xsl" type="text/xsl"</xsl:text>
		</xsl:processing-instruction>
		<xsl:variable name="now" select="current-dateTime()"/>
		<xsl:variable name="files" select="count(/PartCoverReport[@version='4.0']/File)"/>
		<xsl:variable name="classes" select="count(/PartCoverReport[@version='4.0']/Type)"/>
		<xsl:variable name="members" select="count(/PartCoverReport[@version='4.0']/Type/Method)"/>
		<xsl:variable name="uncoveredmembers" select="count(/PartCoverReport[@version='4.0']/Type/Method[count(pt)=0])"/>
		<xsl:variable name="membercoverage" select="round(100 - (uncoveredmembers * 100 div members))"/>
		<xsl:variable name="codesize" select="sum(/PartCoverReport[@version='4.0']/Type/Method/pt/@len) + sum(/PartCoverReport[@version='4.0']/Type/Method[count(pt)=0]/@bodysize)"/>
		<xsl:variable name="coveredcodesize" select="sum(/PartCoverReport[@version='4.0']/Type/Method/pt[@visit>0]/@len)"/>
		<xsl:variable name="uncoveredcodesize" select="$codesize - $coveredcodesize"/>
		<xsl:variable name="coverage" select="round($coveredcodesize * 100 div $codesize)"/>
		<coverageReport reportTitle="Module Class Summary" date="{format-dateTime($now, '[Y]-[M]-[D]')}" time="{format-dateTime($now, '[H]:[m]:[s]')}" version="1.3.5.1789">
			<project name="StruxureWare" files="{$files}" classes="{$classes}" members="{$members}" nonCommentLines="0" sequencePoints="{$codesize}" unvisitedPoints="{$uncoveredcodesize}" unvisitedFunctions="{$uncoveredmembers}" coverage="{$coverage}" acceptable="80" functionCoverage="{$membercoverage}" acceptableFunction="80" filteredBy="None" sortedBy="Name">
				<coverageFiles>
					<coverageFile><xsl:value-of select="$coveragefile"/></coverageFile>
				</coverageFiles>
			</project>
			<modules>
				<xsl:for-each select="/PartCoverReport[@version='4.0']/Assembly">
					<xsl:variable name="id" select="./@id"/>
					<xsl:variable name="codesize" select="sum(/PartCoverReport[@version='4.0']/Type[@asmref=$id]/Method/pt/@len) + sum(/PartCoverReport[@version='4.0']/Type[@asmref=$id]/Method[count(pt)=0]/@bodysize)"/>
					<xsl:variable name="coveredcodesize" select="sum(/PartCoverReport[@version='4.0']/Type[@asmref=$id]/Method/pt[@visit>0]/@len)"/>
					<xsl:variable name="uncoveredcodesize" select="$codesize - $coveredcodesize"/>
					<xsl:variable name="coverage" select="round($coveredcodesize * 100 div $codesize)"/>
					<module name="{./@name}" sequencePoints="{$codesize}" unvisitedPoints="{$uncoveredcodesize}" coverage="{$coverage}" acceptable="80">
						<xsl:variable name="asmref" select="./@id"/>
						<xsl:for-each-group select="/PartCoverReport[@version='4.0']/Type[@asmref=$asmref]" group-by="replace(@name, '\.[_a-zA-Z0-9]*$', '')">
							<xsl:variable name="namespace" select="current-grouping-key()"/>
							<namespace name="{$namespace}" sequencePoints="0" unvisitedPoints="0" coverage="0">
								<xsl:for-each select="/PartCoverReport[@version='4.0']/Type[replace(./@name, '\.[_a-zA-Z0-9]*$', '')=$namespace]">
									<xsl:variable name="classname" select="replace(./@name, '^.*\.', '')"/>
									<xsl:variable name="codesize" select="sum(./Method/pt/@len) + sum(./Method[count(pt)=0]/@bodysize)"/>
									<xsl:variable name="coveredcodesize" select="sum(./Method/pt[@visit>0]/@len)"/>
									<xsl:variable name="uncoveredcodesize" select="$codesize - $coveredcodesize"/>
									<xsl:variable name="coverage">
										<xsl:choose>
											<xsl:when test="$codesize = 0">
												<xsl:value-of select="0"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="round($coveredcodesize * 100 div $codesize)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<class name="{$classname}" sequencePoints="{$codesize}" unvisitedPoints="{$uncoveredcodesize}" coverage="{$coverage}">
										<xsl:if test="false">
											<xsl:for-each select="./Method">
												<xsl:variable name="methodname" select="./@name"/>
												<xsl:if test="count(pt) = 0">
													<xsl:variable name="codesize" select="sum(./pt/@len)"/>
													<xsl:variable name="codesize" select="$codesize + @bodysize"/>
												</xsl:if>
												<xsl:variable name="codesize" select="sum(./pt/@len)"/>
												<xsl:variable name="coveredcodesize" select="sum(./pt[@visit>0]/@len)"/>
												<xsl:variable name="uncoveredcodesize" select="$codesize - $coveredcodesize"/>
												<xsl:variable name="coverage">
													<xsl:choose>
														<xsl:when test="$codesize = 0">
															<xsl:value-of select="0"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="round($coveredcodesize * 100 div $codesize)"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<method name="{$methodname}" sequencePoints="{$codesize}" unvisitedPoints="{$uncoveredcodesize}" coverage="{$coverage}"/>
											</xsl:for-each>
										</xsl:if>
									</class>
								</xsl:for-each>
							</namespace>
						</xsl:for-each-group>
					</module>
				</xsl:for-each>
			</modules>
		</coverageReport>
	</xsl:template>
</xsl:stylesheet>
