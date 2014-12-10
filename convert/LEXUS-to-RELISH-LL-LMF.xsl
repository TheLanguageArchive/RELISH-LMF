<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:lx="http://tla.mpi.nl/lexus"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:lmf="http://www.lexicalmarkupframework.org/"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:relish="http://www.mpi.nl/relish"
    exclude-result-prefixes="lx lexus">
    
    <!--<xsl:param name="lexicon"/>
    <xsl:variable name="lex-schema" select="document(concat($lexicon,'-schema.xml'))"/>-->

    <xsl:param name="templates" select="'LEXUS-resources/RELISH-LL-LMF-template.xml'"/>
    <xsl:param name="template" select="'relish-ll-lmf'"/>
    <xsl:variable name="lex-template" select="(if ($templates instance of node()) then ($templates) else (document($templates)))//template[@id=$template]"/>
    
    <xsl:param name="schema" select="'../../Schemata/RELISH-LMF/schema/RELISH-LL-LMF/RELISH-LL-LMF.rng'"/>
    
    <xsl:variable name="lmf-classes" as="element()*">
        <class name="Lemma" type="Form"/>
        <class name="FormRepresentation" type="Representation"/>
        <class name="Sense"/>
        <class name="Definition"/>
        <class name="Statement"/>
        <class name="TextRepresentation" type="Representation"/>
        <class name="Context"/>
        <class name="SenseRelation"/>
        <class name="RelatedForm"/>
    </xsl:variable>
    
    <xsl:template match="text()"/>
        
    <xsl:template name="id">
        <xsl:if test="exists(@id)">
            <xsl:attribute name="xml:id" select="@id"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="targets">
        <xsl:if test="exists(lexus:data[@name='target'])">
            <xsl:choose>
                <xsl:when test="exists(lexus:data[@name='target']/lexus:resource[@type='entry-link'])">
                    <xsl:attribute name="targets" select="string-join(lexus:data[@name='target']/lexus:resource/@id,'')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="language">
        <xsl:if test="exists(../lexus:data[@name='language'])">
            <xsl:attribute name="xml:lang" select="../lexus:data[@name='language']/lexus:value"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="/lexus:lexicon">
        <xsl:message>?INFO: template[<xsl:value-of select="$template"/>][<xsl:value-of select="$lex-template/descendant-or-self::template/@id"/>]</xsl:message>
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$schema"/>" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$schema"/>" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <lmf:LexicalResource xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
            xmlns:lmf="http://www.lexicalmarkupframework.org/"
            xmlns:dcr="http://www.isocat.org/ns/dcr"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:relish="http://www.mpi.nl/relish"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:olac="http://www.language-archives.org/OLAC/1.0/"
            xmlns:lego="http://purl.org/linguistics/lego/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance/"
            lmfVersion="ISO 24613:2008">
            <lmf:GlobalInformation>
                <tei:f name="languageCoding" dcr:datcat="http://www.isocat.org/datcat/DC-2482">
                    <tei:string>ISO639-3</tei:string>
                </tei:f>
            </lmf:GlobalInformation>
            <lmf:Lexicon>
                <xsl:variable name="lex">
                    <xsl:apply-templates/>
                </xsl:variable>
                <xsl:apply-templates select="$lex" mode="fsr-cleanup"/>
            </lmf:Lexicon>
        </lmf:LexicalResource>
    </xsl:template>
    
    <xsl:template match="lexus:lexical-entry">
        <lmf:LexicalEntry xml:id="{@id}">
            <xsl:apply-templates>
                <xsl:with-param name="context" select="$lex-template//container[@type='lexical-entry']/@id" tunnel="yes"/>
            </xsl:apply-templates>
        </lmf:LexicalEntry>
    </xsl:template>
    
    <xsl:template match="lexus:container">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:message>DBG: context[<xsl:value-of select="$context"/>] container[<xsl:value-of select="@name"/>][<xsl:value-of select="lower-case(replace(current()/@name,'\s+',''))"/>]</xsl:message>
        <xsl:variable name="schema-context" select="$lex-template//container[@id=$context]"/>
        <xsl:variable name="schema-entry" select="$schema-context/container[@type='container'][lower-case(replace(@name,'\s+',''))=lower-case(replace(current()/@name,'\s+',''))]"/>
        <xsl:message>DBG: schema[<xsl:value-of select="count($schema-context)"/>/<xsl:value-of select="count($schema-entry)"/>]</xsl:message>
        <xsl:choose>
            <xsl:when test="exists($schema-entry)">
                <!-- known LMF class element -->
                <xsl:message>DBG: classes[<xsl:value-of select="string-join($lmf-classes/@name,', ')"/>] class[<xsl:value-of select="replace($schema-entry/@name,'\s+','')"/>]?[<xsl:value-of select="$lmf-classes[@name=replace($schema-entry/@name,'\s+','')]/@name"/>]</xsl:message>
                <xsl:variable name="class" select="$lmf-classes[@name=replace($schema-entry/@name,'\s+','')]"/>
                <xsl:element name="lmf:{replace($schema-entry/@name,'\s+','')}" namespace="http://www.lexicalmarkupframework.org/">
                    <xsl:copy-of select="$class/@type"/>
                    <xsl:call-template name="id"/>
                    <xsl:call-template name="targets"/>
                    <xsl:apply-templates>
                        <xsl:with-param name="context" select="$schema-entry/@id" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="fsr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="fsr"/>
    
    <xsl:template match="lexus:container" mode="fsr">
        <tei:f name="{@name}">
            <tei:fs>
                <xsl:apply-templates mode="fsr"/>
            </tei:fs>
        </tei:f>
    </xsl:template>
    
    <xsl:template match="lexus:data[@name='target']" mode="#all"/>
    
    <xsl:template match="lexus:data[@name='language']" mode="#all">
        <xsl:if test="empty((preceding-sibling::lexus:data,following-sibling::lexus:data)[@name!='language'][@name!='target'])">
            <tei:f name="{@name}">
                <tei:string>
                    <xsl:value-of select="lexus:value"/>
                </tei:string>
            </tei:f>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="lexus:data" mode="#all">
        <tei:f name="{@name}">
            <tei:string>
                <xsl:call-template name="language"/>
                <xsl:value-of select="lexus:value"/>
            </tei:string>
        </tei:f>
    </xsl:template>
    
    <!-- FSR cleanup: if there is a redundant tei:f/@name group their content in a tei:f/tei:vColl -->
    
    <xsl:template match="text()" mode="fsr-cleanup">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="@*|node()" mode="fsr-cleanup">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>        
    
    <xsl:template match="lmf:*|tei:fs" mode="fsr-cleanup">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="* except tei:*" mode="#current"/>
            <xsl:for-each-group select="tei:f" group-by="@name">
                <xsl:choose>
                    <xsl:when test="count(current-group()) gt 1">
                        <tei:f name="{current-grouping-key()}">
                            <tei:vColl>
                                <xsl:apply-templates select="current-group()/*" mode="#current"/>
                            </tei:vColl>
                        </tei:f>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template> 

</xsl:stylesheet>