<?xml version="1.0" encoding="UTF-8"?>
<!-- RELISH-LL-LMF to LL-LIFT Stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="1.0"
    xmlns:lmf="http://www.lexicalmarkupframework.org/"
    xmlns:dcr="http://www.isocat.org/ns/dcr" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs lmf dcr tei">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/ ">       
        <xsl:processing-instruction name="oxygen">
            RNGSchema="../../Schemata/LL-LIFT/linguist-lift.rng" type="xml"
        </xsl:processing-instruction>
        <xsl:processing-instruction name="oxygen">
            SCHSchema="../../Schemata/LL-LIFT/linguist-lift.sch"
        </xsl:processing-instruction>
        <lift version="0.13">
            <xsl:apply-templates/>        
        </lift>       
    </xsl:template>
    
    <!-- Remove lmf root tag -->
    <xsl:template match="lmf:LexicalResource">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Removes lmf:GlobalInformation -->
    <xsl:template match="lmf:GlobalInformation"/>
    
    <!-- Removes lmf:Lexicon -->
    <xsl:template match="lmf:Lexicon">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Creates <entry> -->
    <xsl:template match="lmf:LexicalEntry">
        <entry>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <!-- Creates Sense -->
            <xsl:for-each select="lmf:Sense">
                <sense>
                <!-- Creates grammatical-info for first <sense> only -->
                <xsl:if test="self::lmf:Sense=parent::lmf:LexicalEntry/lmf:Sense[1]">
                    <xsl:for-each select="following-sibling::tei:f[@name='grammaticalInfo']">
                        <grammatical-info>
                            <xsl:attribute name="value">
                                <xsl:value-of select="tei:string"/>
                            </xsl:attribute>
                        </grammatical-info>
                    </xsl:for-each>
                    <!-- End <grammatical-info> -->
                </xsl:if>
                <xsl:for-each select="lmf:Definition">
                    <definition>
                        <xsl:for-each select="lmf:TextRepresentation">
                            <xsl:call-template name="form"/>
                        </xsl:for-each>
                    </definition>
                </xsl:for-each>
                <!-- Creates <example> -->
                <xsl:for-each select="lmf:Context">
                    <xsl:variable name="main-lang">
                        <xsl:value-of select="parent::lmf:Sense/preceding-sibling::lmf:Lemma/lmf:FormRepresentation/tei:f/tei:string/@xml:lang"/>
                    </xsl:variable>
                    <xsl:for-each select="lmf:TextRepresentation">
                        <xsl:if test="tei:f/tei:string/@xml:lang=$main-lang">
                            <example>
                                <xsl:call-template name="form"/>
                                <!-- Creates <translation> -->
                                <xsl:for-each select="parent::lmf:Context/lmf:TextRepresentation">
                                    <xsl:if test="tei:f/tei:string/@xml:lang!=$main-lang">
                                        <translation>
                                            <xsl:call-template name="form"/>
                                        </translation>
                                    </xsl:if>
                                </xsl:for-each>
                                <!-- End <translation> -->
                            </example>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
                <!-- End <example> -->
                </sense>
            </xsl:for-each>
            <!-- End <sense> -->
            <xsl:apply-templates/>
        </entry>
    </xsl:template>
    
    <!-- Creates <lexical-unit> -->
    <xsl:template match="lmf:Lemma">
        <lexical-unit>
            <xsl:for-each select="lmf:FormRepresentation">
                <xsl:call-template name="form"/>
            </xsl:for-each>
        </lexical-unit>
    </xsl:template>
    
    <!-- Removes <lmf:Sense> and its children -->
    <xsl:template match="lmf:Sense"/>
    
    <!-- Removes the TEI feature grammaticalInfo -->
    <xsl:template match="tei:f[@name='grammaticalInfo']"/>
       
    <!-- Creates <relation> -->
    <xsl:template match="lmf:RelatedForm">
        <relation>
            <xsl:attribute name="type">
                <xsl:value-of select="tei:f[@name='type']/tei:string"/>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="@targets"/>
            </xsl:attribute>
        </relation>
    </xsl:template>
    
    <!-- Default template for <form> -->
    <xsl:template name="form">
        <form>
            <xsl:attribute name="lang">
                <xsl:value-of select="child::tei:f/tei:string/@xml:lang"/>
            </xsl:attribute>
            <text>
                <xsl:value-of select="child::tei:f/tei:string"/>
            </text>
        </form>
    </xsl:template>
    
    <!-- Creates a copy of every LMF element -->
    <xsl:template match="*">
        <xsl:copy-of select="self::node()"/>
    </xsl:template>
    
</xsl:stylesheet>
