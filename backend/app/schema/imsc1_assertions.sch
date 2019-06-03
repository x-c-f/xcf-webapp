<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://www.irt.de/subcheck" prefix="subcheck"/>

    <sch:ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#metadata" prefix="ttm"/>
    <sch:ns uri="urn:ebu:tt:style" prefix="ebutts"/>
    <sch:ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#parameter" prefix="ittp"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#styling" prefix="itts"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#metadata" prefix="ittm"/>
    <sch:ns uri="http://www.smpte-ra.org/schemas/2052-1/2010/smpte-tt" prefix="smpte"/>

    <!--##############
        XSLT functions
        ##############-->

    <xsl:include href="../schema/imsc1_functions.xsl"/>


    <!--#############
        shared values
        #############-->

    <!-- matches clock-time with frames / offset-time with f -->
    <sch:let name="regex_frames" value="'^\d{2,}:\d\d:\d\d:\d{2,}(\.\d+)?$|^\d+(\.\d+)?f$'"/>
    <!-- matches offset-time with t -->
    <sch:let name="regex_ticks" value="'^\d+(\.\d+)?t$'"/>

    <!--######
        phases
        ######-->


    <!-- TODO -->


    <!--########
        patterns
        ########-->

    <!-- This PATTERN tests if attributes are present that are in a TTML namespace but not defined by TTML -->
    <!--                                                                                                   -->
    <sch:pattern id="attributeDefined">
        <sch:rule context="attribute::ttm:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-1"
                test="
                    node-name(.) = (
                        xs:QName('ttm:agent'), xs:QName('ttm:role')
                    )">
                All TTML namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-2"
                test="
                    node-name(.) = (
                        xs:QName('ttp:cellResolution'), xs:QName('ttp:clockMode'), xs:QName('ttp:dropMode'), xs:QName('ttp:frameRate'), xs:QName('ttp:frameRateMultiplier'), xs:QName('ttp:markerMode'),
                        xs:QName('ttp:pixelAspectRatio'), xs:QName('ttp:profile'), xs:QName('ttp:subFrameRate'), xs:QName('ttp:tickRate'), xs:QName('ttp:timeBase')
                    )">
                All TTML namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-3"
                test="
                    node-name(.) = (
                        xs:QName('tts:backgroundColor'), xs:QName('tts:color'), xs:QName('tts:direction'), xs:QName('tts:display'), xs:QName('tts:displayAlign'), xs:QName('tts:extent'),
                        xs:QName('tts:fontFamily'), xs:QName('tts:fontSize'), xs:QName('tts:fontStyle'), xs:QName('tts:fontWeight'), xs:QName('tts:lineHeight'), xs:QName('tts:opacity'),
                        xs:QName('tts:origin'), xs:QName('tts:overflow'), xs:QName('tts:padding'), xs:QName('tts:showBackground'), xs:QName('tts:textAlign'), xs:QName('tts:textDecoration'),
                        xs:QName('tts:textOutline'), xs:QName('tts:unicodeBidi'), xs:QName('tts:visibility'), xs:QName('tts:wrapOption'), xs:QName('tts:writingMode'),xs:QName('tts:zIndex')
                    )">
                All TTML namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if attributes are on elements where explicitely forbidden -->
    <!--                                                                              -->
    <sch:pattern id="attributeNamespace">
        <sch:rule context="attribute::ttp:*">
            <sch:assert test="parent::tt:tt" diagnostics="attributeDefinedOn" id="assert-w0ab1b5d181-1" see="http://www.irt.de/subcheck/constraints/w0ab1b5d181">Attributes on the
                parameter namespace appear only on the tt element.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:*[local-name() != 'extent' ]">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183" id="assert-w0ab1b5d183-1">With the exception of tts:extent all attributes in the style namespace appear only on
                the following elements: body, div, span, p, br, style, region or set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert
                test="parent::tt:tt | parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183" id="assert-w0ab1b5d183-2">The tts:extent attribute appears only on
                the following elements: tt, body, div, span, p, br, style, region or set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttm:*[local-name() != 'role']">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:metadata"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d185" id="assert-w0ab1b5d185-1">With the exception of ttm:role all attributes in the TTML metadata namespace appear
                only on the following elements: body, div, p, span, br and metadata. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttm:role">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:metadata | parent::tt:region"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183" id="assert-w0ab1b5d185-2">The ttm:role attribute appears only on
                the following elements: body, div, span, p, br, metadata or region.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests generic aspects e.g. the document encoding and the root element -->
    <!--                                                                                    -->
    <sch:pattern id="generic">
        <sch:rule context="/">
            <sch:let name="doc_raw" value="unparsed-text(document-uri(.))"/>
            <sch:let name="doc_decl"
                value="
                    if (starts-with($doc_raw, '&lt;?xml')) then
                        concat(substring-before($doc_raw, '?&gt;'), '?&gt;')
                    else
                        ''"/>
            <sch:let name="doc_encoding"
                value="
                    if (contains($doc_decl, 'encoding=')) then
                        replace($doc_decl, '^.*encoding=(.)(.*?)\1.*$', '$2')
                    else
                        ''"/>
            <!-- using backref here, as double quotes do not seem to be possible-->
            <sch:assert test="matches($doc_encoding, '^(UTF-8|)$')" id="assert-d1e1004-1"
                see="http://www.irt.de/subcheck/constraints/d1e1004">
                The document encoding (if set) is 'UTF-8'.</sch:assert>

            <sch:assert test="tt:tt" id="assert-d1e1164-1"
                see="http://www.irt.de/subcheck/constraints/d1e1164">
                The root element is the tt:tt element.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if and which TTML profile(s) is/are signalled by the document -->
    <!--                                                                                  -->
    <sch:pattern id="profileSignalling">
        <sch:rule context="/tt:tt">
            <sch:let name="signalling_present_imsc1_text"
                value="subcheck:imsc1_signalling_present(., 'http://www.w3.org/ns/ttml/profile/imsc1/text')"/>
            <sch:let name="signalling_present_imsc1_image"
                value="subcheck:imsc1_signalling_present(., 'http://www.w3.org/ns/ttml/profile/imsc1/image')"/>
            <sch:assert test="$signalling_present_imsc1_text" id="assert-d1e1126-1"
                see="http://www.irt.de/subcheck/constraints/d1e1126">The IMSC1 Text profile should be signalled.</sch:assert>
            <!--<sch:assert test="$signalling_present_imsc1_image" id="assert-jhv_htn_fz-1" see="http://www.irt.de/subcheck/constraints/jhv_htn_fz">The IMSC1 Image profile should be signalled.</sch:assert>-->
            <sch:assert
                test="not($signalling_present_imsc1_text and $signalling_present_imsc1_image)"
                id="assert-d1e2288-1"
                see="http://www.irt.de/subcheck/constraints/d1e2288">Either the IMSC1 Text profile or the IMSC1 Image Profile is signalled at the same time.</sch:assert>
            <sch:assert test="not(@ttp:profile and tt:head/ttp:profile)"
                id="assert-d1e2589-1"
                see="http://www.irt.de/subcheck/constraints/d1e2589">
                The ttp:profile attribute is not used when the tt:profile element is present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if every content is convered by timing information -->
    <!--                                                                       -->
    <sch:pattern id="contentTimingInformation">
        <sch:rule context="/tt:tt/tt:body//tt:div//*[(self::tt:p or self::tt:span) and (child::text()[normalize-space(.) ne ''] or child::tt:br)]">
            <sch:assert test="ancestor-or-self::*[@begin] and ancestor-or-self::*[@end]"
                id="assert-d1e1528-1"
                see="http://www.irt.de/subcheck/constraints/d1e1528">The begin and end attributes
                should be present on the containing element or one of its ancestors.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the ittm:altText constraints -->
    <!--                                                 -->
    <sch:pattern id="altTextConstraints">
        <sch:rule context="ittm:altText">
            <sch:assert test="not(child::*)" id="assert-d1e2152-1"
                see="http://www.irt.de/subcheck/constraints/d1e2152">
                The ittm:altText element has solely #PCDATA content.</sch:assert>
            <sch:assert test="parent::tt:metadata" id="assert-d1e2179-1" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/d1e2179">
                The ittm:altText element is child of a tt:metadata element.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if a style reference loop is present -->
    <!--                                                         -->
    <sch:pattern id="styleReferenceLoop">
        <sch:rule context="/tt:tt/tt:head/tt:styling/tt:style">
            <sch:assert test="not(subcheck:ttml_style_chain_exists(., ., ()))" id="assert-d1e2616-1"
                see="http://www.irt.de/subcheck/constraints/d1e2616">There is no loop in the style references.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests for the presence of forbidden elements -->
    <!--                                                           -->
    <sch:pattern id="elementPresence">
        <sch:rule context="smpte:image">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c37Aa" id="assert-w0ab1b7c37Aa-1"
                test="false()">The element smpte:image is not present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests whether attributes are significant on the respective element -->
    <!--                                                                                 -->
    <sch:pattern id="attributeSignificance">
        <sch:rule context="attribute::tts:backgroundColor">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e2" id="assert-d1e2-1"
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:style | parent::tt:region"
                > The attribute tts:backgroundColor is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:span, tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:display">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e23" id="assert-d1e23-1"
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:style | parent::tt:region"
                > The attribute tts:display is defined on one of the following elements: tt:body,
                tt:div, tt:p, tt:span, tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:displayAlign">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e44" id="assert-d1e44-1"
                test="parent::tt:region | parent::tt:style"> The attribute tts:displayAlign is defined
                on one of the following elements: tt:region, tt:style. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e65" id="assert-d1e65-1"
                test="parent::tt:tt | parent::tt:region | parent::tt:style"> The attribute tts:extent is
                defined on one of the following elements: tt:tt, tt:region, tt:style. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:opacity">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e86" id="assert-d1e86-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:opacity is defined on one
                of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e107" id="assert-d1e107-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:origin is defined on one
                of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:overflow">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e128" id="assert-d1e128-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:overflow is defined on
                one of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e149" id="assert-d1e149-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:padding is defined on one
                of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:showBackground">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e170" id="assert-d1e170-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:showBackground is defined on one of the
                following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:unicodeBidi">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e191" id="assert-d1e191-1"
                test="parent::tt:p | parent::tt:style | parent::tt:span"> The attribute tts:unicodeBidi
                is defined on one of the following elements: tt:p, tt:style, tt:span. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:writingMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e212" id="assert-d1e212-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:writingMode is defined on
                one of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:zIndex">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e234" id="assert-d1e234-1"
                test="parent::tt:style | parent::tt:region"> The attribute tts:zIndex is defined on one
                of the following elements: tt:style, tt:region. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e1797" id="assert-d1e1797-1"
                test="parent::tt:tt">The attribute ittp:aspectRatio is defined on one of the
                following elements: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:forcedDisplay">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e2014" id="assert-d1e2014-1"
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region"
                >The attribute itts:forcedDisplay is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:span, tt:region.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:progressivelyDecodable">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e1960" id="assert-d1e1960-1"
                test="parent::tt:tt">The attribute ittp:progressivelyDecodable is defined on one of
                the following elements: tt:tt.</sch:assert>
        </sch:rule>
        <!-- also check e.g. @ebutts:linePadding ? -->
    </sch:pattern>

    <!-- This PATTERN tests for the presence of required attributes -->
    <!--                                                            -->
    <sch:pattern id="attributeRequirement">
        <sch:rule context="/tt:tt/tt:head/tt:layout/tt:region">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/d1e1321" id="assert-d1e1321-1"
                test="attribute::tts:extent">The attribute tts:extent is present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests for the presence of forbidden attributes -->
    <!--                                                             -->
    <sch:pattern id="attributePresence">
        <sch:rule context="attribute::ttp:clockMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e199" id="assert-d1e199-1"
                test="false()">The attribute ttp:clockMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:dropMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e228" id="assert-d1e228-1"
                test="false()">The attribute ttp:dropMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:pixelAspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e341" id="assert-d1e341-1"
                test="false()">The attribute ttp:pixelAspectRatio is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:markerMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e314" id="assert-d1e314-1"
                test="false()">The attribute ttp:markerMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:subFrameRate">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e368" id="assert-d1e368-1"
                test="false()">The attribute ttp:subFrameRate is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImage">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e508" id="assert-d1e508-1"
                test="false()">The attribute smpte:backgroundImage is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImageVertical">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c31" id="assert-w0ab1b7c31-1"
                test="false()">The attribute smpte:backgroundImageVertical is not
                used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImageHorizontal">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/unm_ytj_lz" id="assert-unm_ytj_lz-1"
                test="false()">The attribute smpte:backgroundImageHorizontal is not
                present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests for the correctness of attribute values -->
    <!--                                                            -->
    <sch:pattern id="attributeValues">
        <sch:rule context="attribute::ttp:timeBase">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e398" id="assert-d1e398-1"
                test="normalize-space(.) eq 'media'">The ttp:timeBase attribute has one of the following values: 'media'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::region">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1044" id="assert-d1e1044-1"
                test="some $x in /tt:tt/tt:head/tt:layout/tt:region satisfies $x/@xml:id eq normalize-space(.)">
                The region attribute refers to an existing region.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::style">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1086" id="assert-d1e1086-1"
                test="every $s in tokenize(normalize-space(.), ' ') satisfies (some $x in /tt:tt/tt:head/tt:styling/tt:style satisfies $x/@xml:id eq $s)">
                The style attribute refers to an existing style.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontSize">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e427" id="assert-d1e427-1"
                test="count(tokenize(normalize-space(.), ' ')) eq 1">The tts:fontSize attribute contains only one value.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-1"
                test="not(contains(., '-'))">The tts:fontSize attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:lineHeight">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-2"
                test="not(contains(., '-'))">The tts:lineHeight attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-3"
                test="not(contains(., '-'))">The tts:origin attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-4"
                test="not(contains(., '-'))">The tts:padding attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textOutline">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e481" id="assert-d1e481-1"
                test="count(subcheck:remove_ttml_color_components(tokenize(normalize-space(.), ' '))) eq 1">The tts:textOutline attribute contains only one value.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-5"
                test="not(contains(., '-'))">The tts:textOutline attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-6"
                test="not(contains(., '-'))">The tts:extent attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio">
            <sch:let name="values" value="tokenize(normalize-space(.), ' ')"/>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1770" id="assert-d1e1770-1"
                test="(count($values) eq 2) and (every $x in $values satisfies (matches($x, '^\d+$') and number($x) ne 0))">
                The ittp:aspectRatio attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:forcedDisplay">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1987" id="assert-d1e1987-1"
                test="matches(normalize-space(.), '^(true|false)$')">The itts:forcedDisplay attribute has one of the following values: 'true', 'false'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:progressivelyDecodable">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1933" id="assert-d1e1933-1"
                test="matches(normalize-space(.), '^(true|false)$')">The ittp:progressivelyDecodable attribute has one of the following values: 'true', 'false'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:linePadding">
            <!-- TODO: remove negative len check, as already covered? -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-7"
                test="not(contains(., '-'))">The ebutts:linePadding attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e2369" id="assert-d1e2369-1"
                test="matches(normalize-space(.), '^(\d*\.)?\d+c$')">The ebutts:linePadding attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:multiRowAlign">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e2424" id="assert-d1e2424-1"
                test="matches(normalize-space(.), '^(start|center|end|auto)$')">The ebutts:multiRowAlign attribute has one of the following values: 'start', 'center', 'end', 'auto'</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests for the correctness of attribute value units -->
    <!--                                                                 -->
    <sch:pattern id="attributeUnits">
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1281" id="assert-d1e1281-1"
                test="(normalize-space(.) eq 'auto') or (every $x in subcheck:string_to_units(.) satisfies matches($x, '^(px|%)$'))">
                The tts:origin attribute uses the following units only: 'px', '%'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-1"
                test="not(some $x in subcheck:string_to_units(.) satisfies $x eq 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:origin attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c89" id="assert-w0ab1b7c89-1"
                test="(normalize-space(.) eq 'auto') or (every $x in subcheck:string_to_units(.) satisfies matches($x, '^(px|%)$'))">
                The tts:extent attribute uses the following units only: 'px', '%'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-2"
                test="not(some $x in subcheck:string_to_units(.) satisfies $x eq 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:extent attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontSize">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-1"
                test="every $x in subcheck:string_to_units(.) satisfies ($x ne 'c')">
                The tts:fontSize attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:lineHeight">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-2"
                test="every $x in subcheck:string_to_units(.) satisfies ($x ne 'c')">
                The tts:lineHeight attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-3"
                test="every $x in subcheck:string_to_units(.) satisfies ($x ne 'c')">
                The tts:padding attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textOutline">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-4"
                test="every $x in subcheck:string_to_units(.) satisfies ($x ne 'c')">
                The tts:textOutline attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:linePadding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1241" id="assert-d1e1241-1"
                test="not(some $x in subcheck:string_to_units(.) satisfies $x eq 'c') or (/tt:tt/@ttp:cellResolution ne '')">
                If an ebutts:linePadding attribute uses the 'c' unit, the ttp:cellResolution on the tt:tt element is set.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the timing information attributes in general -->
    <!--                                                      -->
    <sch:pattern id="attributeTimingGeneral">
        <sch:rule context="/tt:tt">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/d1e1488" id="assert-d1e1488-1"
                test="
                count(
                distinct-values(
                for $x
                in (//attribute::begin[. ne ''] | //attribute::dur[. ne ''] | //attribute::end[. ne ''])
                return subcheck:time_expression_to_format($x)
                )
                ) le 1
                ">All time expressions in a document should use the same syntax.</sch:assert>
        </sch:rule>
        <!-- TODO: implement w0ab1b7c99 -->
    </sch:pattern>

    <!-- This PATTERN tests the timing information attributes in case no ttp:frameRate is set -->
    <!--                                                                                      -->
    <sch:pattern id="attributeTimingFrameRate">
        <sch:rule context="/tt:tt[not(@ttp:frameRate ne '')]">
            <sch:assert diagnostics="beginValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-1"
                test="not(//attribute::begin[matches(normalize-space(.), $regex_frames)])">
                If a begin attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="durValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-2"
                test="not(//attribute::dur[matches(normalize-space(.), $regex_frames)])">
                If a dur attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="endValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-3"
                test="not(//attribute::end[matches(normalize-space(.), $regex_frames)])">
                If an end attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the timing information attributes in case no ttp:tickRate is set -->
    <!--                                                                                     -->
    <sch:pattern id="attributeTimingTickRate">
        <sch:rule context="/tt:tt[not(@ttp:tickRate ne '')]">
            <sch:assert diagnostics="beginValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-1"
                test="not(//attribute::begin[matches(normalize-space(.), $regex_ticks)])">
                If a begin attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="durValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-2"
                test="not(//attribute::dur[matches(normalize-space(.), $regex_ticks)])">
                If a dur attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="endValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-3"
                test="not(//attribute::end[matches(normalize-space(.), $regex_ticks)])">
                If an end attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
        </sch:rule>
    </sch:pattern>


    <!--###########
        diagnostics
        ###########-->
    <sch:diagnostics>
        <sch:diagnostic id="elementChildOf" fpi="definedOn">The element
            <sch:value-of select="name()"/> is a child of element <sch:value-of
                select="parent::*/name()"/>.</sch:diagnostic>
        <sch:diagnostic id="attributeDefinedOn" fpi="definedOn">The attribute
                <sch:value-of select="name()"/> appears on element <sch:value-of
                select="parent::*/name()"/>.</sch:diagnostic>
        <sch:diagnostic id="attributeValue">The value of the attribute <sch:value-of select="name()"/> is <sch:value-of
                select="."/>.</sch:diagnostic>
        <sch:diagnostic id="beginValueFrameRate">The framerate is not specified and at least one begin attribute uses frames (e.g.
            <sch:value-of select="//attribute::begin[matches(normalize-space(.), $regex_frames)][1]"/>).</sch:diagnostic>
        <sch:diagnostic id="durValueFrameRate">The framerate is not specified and at least one dur attribute uses frames
            <sch:value-of select="//attribute::dur[matches(normalize-space(.), $regex_frames)][1]"/>).</sch:diagnostic>
        <sch:diagnostic id="endValueFrameRate">The framerate is not specified and at least one end attribute value uses frames
            <sch:value-of select="//attribute::end[matches(normalize-space(.), $regex_frames)][1]"/>).</sch:diagnostic>
        <sch:diagnostic id="beginValueTickRate">The tickrate is not specified and at least one begin attribute uses ticks
            <sch:value-of select="//attribute::begin[matches(normalize-space(.), $regex_ticks)][1]"/>).</sch:diagnostic>
        <sch:diagnostic id="durValueTickRate">The tickrate is not specified and at least one dur attribute uses ticks
            <sch:value-of select="//attribute::dur[matches(normalize-space(.), $regex_ticks)][1]"/>).</sch:diagnostic>
        <sch:diagnostic id="endValueTickRate">The tickrate is not specified and at least one end attribute uses ticks
            <sch:value-of select="//attribute::end[matches(normalize-space(.), $regex_ticks)][1]"/>).</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
