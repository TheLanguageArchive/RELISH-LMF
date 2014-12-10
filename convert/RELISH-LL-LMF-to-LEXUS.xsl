<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:lx="http://tla.mpi.nl/lexus"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:lmf="http://www.lexicalmarkupframework.org/"
    xmlns:dcr="http://www.isocat.org/ns/dcr"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:relish="http://www.mpi.nl/relish"
    exclude-result-prefixes="lx lmf dcr tei relish">
    
    <xsl:param name="templates"/>
    <xsl:param name="template"/>
    <xsl:variable name="lex-template" select="(if ($templates instance of node()) then ($templates) else (document($templates)))//template[@id=$template]"/>
    
    <xsl:param name="lexicon"/>
    
    <!-- main -->
    <xsl:template match="/">
        <xsl:message>?INFO: template[<xsl:value-of select="$template"/>][<xsl:value-of select="$lex-template/descendant-or-self::template/@id"/>]</xsl:message>
        <xsl:variable name="data">
            <xsl:apply-templates mode="data"/>
        </xsl:variable>
        <xsl:variable name="schema">
            <xsl:apply-templates mode="schema" select="$lex-template//schema">
                <xsl:with-param name="data" select="$data" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="sync">
            <xsl:apply-templates  select="$data/lexus:lexicon/*" mode="sync">
                <xsl:with-param name="schema" select="$schema" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:variable>
        <!--<lexus:lexicon version="1.0">
            <lexus:meta>
                <xsl:copy-of select="$schema"/>
            </lexus:meta>
            <xsl:copy-of select="$sync"/>
        </lexus:lexicon>-->
        <xsl:result-document href="{$lexicon}-LEXUS-schema.xml">
            <xsl:processing-instruction name="xml-model">href="../../Schemata/LEXUS/schema.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:value-of select="system-property('line.separator')"/>
            <lexus:meta version="1.0">
                <xsl:copy-of select="$schema"/>
            </lexus:meta>
        </xsl:result-document>
        <!--<xsl:result-document href="{$lexicon}-LEXUS-lexicon.xml">-->
            <xsl:processing-instruction name="xml-model">href="../../Schemata/LEXUS/lexicon.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:value-of select="system-property('line.separator')"/>
            <lexus:lexicon version="1.0">
                <xsl:copy-of select="$sync"/>
            </lexus:lexicon>
        <!--</xsl:result-document>-->
    </xsl:template>
    
    <!-- mode=data -->
    <xsl:template match="text()" mode="data"/>
    
    <xsl:template name="id">
        <xsl:if test="exists(@xml:id)">
            <xsl:attribute name="id" select="@xml:id"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="lang">
        <xsl:if test="exists(tei:string/@xml:lang)">
            <lexus:data name="language">
                <lexus:value>
                    <xsl:value-of select="tei:string/@xml:lang"/>
                </lexus:value>
            </lexus:data>
        </xsl:if>
    </xsl:template>
    
    <xsl:function name="lx:schema-lookup">
        <xsl:param name="context"/>
        <xsl:param name="name"/>
        <xsl:variable name="lex-name">
            <xsl:choose>
                <xsl:when test="$name = 'LexicalEntry'">
                    <xsl:sequence select="'lexical-entry'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="schema-entry" select="$lex-template//container[(lower-case(replace(@name,'\s+','')),lower-case(replace(@type,'\s+','')))=lower-case($lex-name)]"/>
        <xsl:choose>
            <xsl:when test="count($schema-entry)=1">
                <xsl:sequence select="$schema-entry"/>
            </xsl:when>
            <xsl:when test="count($schema-entry)&gt;1">
                <xsl:variable name="ctxt-schema-entry" select="$schema-entry[parent::container/@id=$context]"/>
                <xsl:choose>
                    <xsl:when test="count($ctxt-schema-entry)=1">
                        <xsl:sequence select="$ctxt-schema-entry"/>
                    </xsl:when>
                    <xsl:when test="count($ctxt-schema-entry)&gt;1">
                        <xsl:message>!WARNING: multiple matches[<xsl:value-of select="string-join($ctxt-schema-entry/@id,', ')"/>] for container[<xsl:value-of select="$context"/>][<xsl:value-of select="$name"/>] selecting the first</xsl:message>
                        <xsl:sequence select="($ctxt-schema-entry)[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>!WARNING: multiple matches[<xsl:value-of select="string-join($schema-entry/@id,', ')"/>] for container[<xsl:value-of select="$name"/>] selecting the first</xsl:message>
                        <xsl:sequence select="($schema-entry)[1]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">!ERROR: unknown container[<xsl:value-of select="$name"/>]</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="lmf:LexicalResource" mode="data">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="lmf:GlobalInformation" mode="data"/>
    
    <xsl:template match="lmf:Lexicon" mode="data">
        <lexus:lexicon version="1.0">
            <lexus:lexicon-information>
                <lexus:name/>
                <lexus:description/>
                <lexus:note/>
            </lexus:lexicon-information>
            <xsl:apply-templates mode="#current"/>
        </lexus:lexicon>
    </xsl:template>
    
    <xsl:template match="lmf:LexicalEntry" mode="data">
        <xsl:variable name="schema-ref" select="$lex-template//container[@type='lexical-entry']/@id"/>
        <lexus:lexical-entry schema-ref="{$schema-ref}">
            <xsl:call-template name="id"/>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="context" select="$schema-ref" tunnel="yes"/>
            </xsl:apply-templates>
        </lexus:lexical-entry>
    </xsl:template>
    
    <xsl:template match="lmf:*" mode="data">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="schema-entry" select="lx:schema-lookup($context,local-name())"/>
        <lexus:container name="{$schema-entry/@name}"  schema-ref="{$schema-entry/@id}">
            <xsl:call-template name="id"/>
            <xsl:apply-templates mode="#current">
                <xsl:with-param name="context" select="$schema-entry/@id" tunnel="yes"/>
            </xsl:apply-templates>
        </lexus:container>
    </xsl:template>
    
    <xsl:template match="lmf:*[exists(@targets)]" mode="data">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="schema-entry" select="lx:schema-lookup($context,local-name())"/>
        <xsl:variable name="node" select="."/>
        <xsl:for-each select="tokenize(@targets,'\s+')">
            <xsl:variable name="ref" select="."/>
            <xsl:variable name="target" select="id($ref,$node)"/>
            <xsl:if test="exists($target)">
                <lexus:container name="{$schema-entry/@name}" schema-ref="{$schema-entry/@id}">
                    <xsl:for-each select="$node">
                        <xsl:apply-templates mode="#current">
                            <xsl:with-param name="context" select="$schema-entry/@id" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                    <lexus:data name="target">
                        <lexus:value>
                            <xsl:value-of select="$target/(.//tei:f/tei:string)[1]"/>
                        </lexus:value>
                        <lexus:resource archive="lexicon" type="entry-link" value="{lx:schema-lookup((),local-name($target))}" id="{$target/@xml:id}" mimetype=""/>
                    </lexus:data>
                </lexus:container>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:f" mode="data">
        <lexus:data name="{@name}">
            <xsl:call-template name="id"/>
            <lexus:value>
                <xsl:value-of select="tei:string"/>
            </lexus:value>
        </lexus:data>
        <xsl:call-template name="lang"/>
    </xsl:template>
    
    <!-- mode=schema -->
    
    <xsl:template match="text()" mode="schema"/>
    
    <xsl:template match="schema" mode="schema">
        <lexus:schema>
            <xsl:apply-templates mode="#current"/>
        </lexus:schema>
    </xsl:template>
    
    <xsl:template match="container" mode="schema">
        <xsl:param name="data" tunnel="yes"/>
        <xsl:variable name="schema" select="current()"/>
        <xsl:variable name="id" select="@id"/>
        <lexus:container>
            <xsl:copy-of select="@*"/>
            <xsl:for-each-group select="$data//(lexus:lexical-entry|lexus:container)[@schema-ref=$id]/lexus:data" group-by="@name">
                <xsl:variable name="name" select="current-grouping-key()"/>
                <xsl:variable name="datcat" select="$schema/datacategory[lower-case(replace(@name,'\s+',''))=lower-case(replace($name,'\s+',''))]"/>
                <xsl:choose>
                    <xsl:when test="count($datcat)=1">
                        <lexus:datacategory>
                            <xsl:copy-of select="$datcat/@*"/>
                        </lexus:datacategory>
                    </xsl:when>
                    <xsl:when test="count($datcat)&gt;1">
                        <xsl:message>!WARNING: multiple matches[<xsl:value-of select="string-join($datcat/@id,', ')"/>] for datacategory[<xsl:value-of select="$name"/>] selecting the first</xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <lexus:datacategory id="{$id}-{position()}" mandatory="false" multiple="true" name="{$name}" type="data" description=""/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
            <xsl:apply-templates mode="#current"/>
        </lexus:container>
    </xsl:template>
    
    <!-- mode=sync -->
    
    <xsl:template match="@*|element()" mode="sync">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="lexus:data[empty(@schema-ref)]" mode="sync">
        <xsl:param name="schema" tunnel="yes"/>
        <xsl:copy>
            <xsl:attribute name="schema-ref" select="$schema//lexus:container[@id=current()/parent::lexus:*/@schema-ref]/lexus:datacategory[@name=current()/@name]/@id"/>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>