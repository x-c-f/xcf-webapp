<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:subcheck="http://www.irt.de/subcheck" xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter" xmlns:ebuttm="urn:ebu:tt:metadata">


    <!--#########
        Functions
        #########-->

    <xsl:function name="subcheck:is_ttml_color" as="xs:boolean">
        <!-- returns true if a string value is a TTML color expression, otherwise false -->
        <!-- Expects a normalized string -->
        <xsl:param name="s" as="xs:string"/>
        <xsl:variable name="named_colors" select="('transparent', 'black', 'silver', 'gray', 'white', 'maroon', 'red', 'purple', 'fuchsia', 'magenta', 'green', 'lime', 'olive', 'yellow', 'navy', 'blue', 'teal', 'aqua', 'cyan' )"/>
        <xsl:value-of select="
            matches($s, '^#[0-9a-fA-F]{6}$') or
            matches($s, '^#[0-9a-fA-F]{8}$') or
            matches($s, '^rgb\(((0*25[0-5]|0*2[0-4]\d|0*1\d{1,2}|0*\d\d?),){2}(0*25[0-5]|0*2[0-4]\d|0*1\d{1,2}|0*\d\d?)\)$') or
            matches($s, '^rgba\(((0*25[0-5]|0*2[0-4]\d|0*1\d{1,2}|0*\d\d?),){3}(0*25[0-5]|0*2[0-4]\d|0*1\d{1,2}|0*\d\d?)\)$') or
            exists(index-of($named_colors, $s))
            "/>
    </xsl:function>

    <xsl:function name="subcheck:remove_ttml_color_components" as="xs:string*">
        <!-- removes all color components from a sequence and returns the resulting sequence -->
        <xsl:param name="s" as="xs:string*"/>
        <xsl:sequence select="$s[not(subcheck:is_ttml_color(.))]"/>
    </xsl:function>

    <xsl:function name="subcheck:string_to_units" as="xs:string*">
        <!-- splits a (space-normalized) string at spaces into its components and returns all units -->
        <xsl:param name="s" as="xs:string?"/>
        <xsl:sequence select="
            for $token in tokenize(normalize-space($s), ' ')
            return replace($token, '^[-+]?\d*\.?\d+', '')
            "/>
    </xsl:function>

    <xsl:function name="subcheck:time_expression_to_format" as="xs:string">
        <!-- returns the format (clock-time, offset-time) of a timeExpression (if possible) -->
        <xsl:param name="s" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="matches(normalize-space($s), '^\d{2,}:\d\d:\d\d(:\d{2,})?(\.\d+)?$')">clock-time</xsl:when>
            <xsl:when test="matches(normalize-space($s), '^\d+(\.\d+)?([hmsft]|ms)$')">offset-time</xsl:when>
            <xsl:otherwise>unsupported-time</xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="subcheck:imsc1_signalling_present" as="xs:boolean">
        <!-- returns if the signalling for a specific IMSC1 profile is present -->
        <xsl:param name="tt" as="node()"/>
        <xsl:param name="designator" as="xs:string"/>
        <xsl:value-of select="
            (normalize-space($tt/@ttp:profile) eq $designator) or
            (some $p in $tt/tt:head/ttp:profile/@use satisfies (normalize-space($p) eq $designator)) or
            (some $p in $tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:conformsToStandard satisfies (normalize-space($p) eq $designator))
            "/>
    </xsl:function>

    <xsl:function name="subcheck:ttml_style_chain_exists" as="xs:boolean">
        <!-- returns a string sequence of the affected styles, if a specific style is present through chained references (loop presence check, if current == checked) -->
        <xsl:param name="start" as="node()"/>
        <xsl:param name="end" as="node()"/>
        <xsl:param name="checkedStyles" as="xs:string*"/>
        <xsl:value-of select="
            some $s in tokenize(normalize-space($start/@style), ' ') satisfies (
                if ($s eq $end/@xml:id)
                then true()
                else (
                    (: ignore non-existing styles :)
                    if ($start/../tt:style[@xml:id eq $s] and
                        empty(index-of($checkedStyles, $s)))
                    then subcheck:ttml_style_chain_exists($start/../tt:style[@xml:id eq $s], $end, ($checkedStyles, $s))
                    else false()
                )
            )
            "/>
    </xsl:function>
</xsl:stylesheet>
