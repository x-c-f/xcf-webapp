<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:irt="http://www.irt.de/subcheck" exclude-result-prefixes="xs irt" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>

    <xsl:param name="tag_validation" as="xs:string" select="''"/>
    <xsl:param name="tag_standard" as="xs:string" select="''"/>

    <xsl:variable name="constraints" select="document('../constraints/IMSC1Constraints.xml')"/>

    <xsl:function name="irt:cleanup_message" as="xs:string">
        <xsl:param name="text" as="xs:string"/>

        <xsl:variable name="x0" select="$text"/>
        <xsl:variable name="x1" select="replace($x0, '(^[^:]+:[ ])', '')"/>
        <xsl:variable name="x2" select="replace($x1, '\.$', '')"/>
        <xsl:value-of select="$x2"/>
    </xsl:function>

    <xsl:function name="irt:generalized_message" as="xs:string">
        <xsl:param name="text" as="xs:string"/>

        <xsl:variable name="r01_old">^'[^']+' is not a valid value</xsl:variable>
        <xsl:variable name="r01_new">*VALUE* is not a valid value</xsl:variable>

        <xsl:variable name="r02_old">^The value '[^']+'</xsl:variable>
        <xsl:variable name="r02_new">The value *VALUE*</xsl:variable>

        <xsl:variable name="r03_old">^Value '[^']+'</xsl:variable>
        <xsl:variable name="r03_new">Value *VALUE*</xsl:variable>

        <xsl:variable name="x00" select="irt:cleanup_message($text)"/>
        <xsl:variable name="x01" select="replace($x00, $r01_old, $r01_new)"/>
        <xsl:variable name="x02" select="replace($x01, $r02_old, $r02_new)"/>
        <xsl:variable name="x03" select="replace($x02, $r03_old, $r03_new)"/>
        <xsl:value-of select="$x03"/>
    </xsl:function>

    <xsl:template match="/report">
        <results>
            <xsl:for-each-group select="message" group-by="irt:generalized_message(text())">
                <xsl:sort select="irt:generalized_message(text())"/>

                <result>
                    <message><xsl:value-of select="current-grouping-key()"/></message>
                    <locations>
                        <xsl:for-each select="current-group()">
                            <xsl:sort select="@line"/>

                            <location>
                                <message>
                                    <xsl:value-of select="concat('Line ', @line, ': ', irt:cleanup_message(text()))"/>
                                </message>
                            </location>
                        </xsl:for-each>
                    </locations>
                    <tags>
                        <xsl:if test="$tag_validation ne ''">
                            <xsl:call-template name="insert_tag">
                                <xsl:with-param name="tag_name" select="$tag_validation"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$tag_standard ne ''">
                            <xsl:call-template name="insert_tag">
                                <xsl:with-param name="tag_name" select="$tag_standard"/>
                            </xsl:call-template>
                        </xsl:if>
                    </tags>
                </result>
            </xsl:for-each-group>
        </results>
    </xsl:template>

    <xsl:template name="insert_tag">
        <xsl:param name="tag_name" as="xs:string"/>
        <xsl:variable name="tag" select="$constraints/SpecificationConstraints/Tags/Tag[@ID = $tag_name]"/>
        <Tag>
            <Type><xsl:value-of select="$tag/@type"/></Type>
            <Long><xsl:value-of select="$tag/DisplaynameLong"/></Long>
            <Short><xsl:value-of select="$tag/DisplaynameShort"/></Short>
        </Tag>
    </xsl:template>
</xsl:stylesheet>
