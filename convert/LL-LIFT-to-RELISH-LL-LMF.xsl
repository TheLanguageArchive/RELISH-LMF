<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0"
    xmlns:lmf="http://www.lexicalmarkupframework.org/"
    xmlns:dcr="http://www.isocat.org/ns/dcr" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:relish="http://www.mpi.nl/relish"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.0/"
    xmlns:lego="http://purl.org/linguistics/lego/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance/">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- XSLT Stylesheet to Convert LEGO Output format to LEGO-RELISH -->
    
    <xsl:param name="schema" select="'../../Schemata/RELISH-LMF/schema/RELISH-LL-LMF/RELISH-LL-LMF.rng'"/>
   
    <!-- Validates Output Against RELISH Schema -->
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$schema"/>" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <xsl:processing-instruction name="xml-model">href="<xsl:value-of select="$schema"/>" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:value-of select="system-property('line.separator')"/>
        <!-- Creates root tag -->
        <lmf:LexicalResource>
            <xsl:attribute name="lmfVersion">
                <xsl:value-of select="'ISO 24613:2008'"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </lmf:LexicalResource>
    </xsl:template>
    
    
    <!-- Removes LIFT tag -->
    <xsl:template match="lift">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Main Content Template -->
    <xsl:template match="header">
        <!-- Transforms <header> to Global Information.
            Please note that header info will need to be transformed;
            this is currently just a placeholder    -->
        <lmf:GlobalInformation>
            <tei:f name="languageCoding" dcr:datcat="http://www.isocat.org/datcat/DC-2482">
                <tei:string>ISO639-3</tei:string>
            </tei:f>
        </lmf:GlobalInformation>
        <!-- End Global Information -->
        <!-- Creates Lexicon Element -->
        <lmf:Lexicon>
            <!-- Creates LexicalEntry -->
            <xsl:for-each select="following-sibling::entry">
                <lmf:LexicalEntry>
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <!-- Creates Lemma -->
                    <xsl:if test="./lexical-unit">
                        <lmf:Lemma type="Form">
                            <lmf:FormRepresentation>
                                <xsl:attribute name="type">
                                    <xsl:value-of select="'Representation'"/>
                                </xsl:attribute>
                                <tei:f name="text">
                                    <tei:string>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="./lexical-unit/form/@lang"/>
                                        </xsl:attribute>
                                     <xsl:value-of select="lexical-unit/form/text"/>
                                    </tei:string>
                                </tei:f>
                            </lmf:FormRepresentation>
                        </lmf:Lemma>
                    </xsl:if>   
                    <!-- End Lemma -->
                    <!-- Creates Sense -->
                    <xsl:for-each select="./sense">
                        <lmf:Sense>
                            <!-- Creates Definition -->
                            <xsl:if test="./definition">
                                <lmf:Definition>
                                    <xsl:for-each select="./definition/form">
                                        <lmf:TextRepresentation>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="'Representation'"/>
                                            </xsl:attribute>
                                            <tei:f name="text">
                                                <tei:string>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:value-of select="./@lang"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="./text"/>
                                                </tei:string>
                                            </tei:f>
                                        </lmf:TextRepresentation>
                                    </xsl:for-each>
                                </lmf:Definition>
                            </xsl:if>
                            <!-- Ends Definition -->
                            <!-- Creates Context -->
                            <xsl:for-each select="./example">
                                <lmf:Context>
                                    <lmf:TextRepresentation>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'Representation'"/>
                                        </xsl:attribute>
                                        <tei:f name="text">
                                            <tei:string>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:value-of select="./form/@lang"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="./form/text"/>
                                            </tei:string>
                                        </tei:f>
                                    </lmf:TextRepresentation>
                                    <!-- Creates TextRepresentations for each Translation -->
                                    <xsl:for-each select="./translation">
                                        <lmf:TextRepresentation>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="'Representation'"/>
                                            </xsl:attribute>
                                            <tei:f name="text">
                                                <tei:string>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:value-of select="./form/@lang"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="./form/text"/>
                                                </tei:string>
                                            </tei:f>
                                        </lmf:TextRepresentation>
                                    </xsl:for-each>
                                    <!-- End Translation -->
                                </lmf:Context>
                            </xsl:for-each>
                            <!-- Ends SenseExample -->
                            <!-- Creates SenseRelation -->
                            <xsl:for-each-group select="relation" group-by="@type">
                                <lmf:SenseRelation>
                                    <xsl:attribute name="targets">
                                        <xsl:value-of select="string-join(current-group()/@ref,' ')"/>
                                    </xsl:attribute>
                                    <tei:f name="type">
                                        <tei:string>
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </tei:string>
                                    </tei:f>
                                </lmf:SenseRelation>
                            </xsl:for-each-group>
                        </lmf:Sense>
                    </xsl:for-each>
                    <!-- End Sense -->
                    <!-- Creates RelatedForm -->
                    <xsl:for-each-group select="relation" group-by="@type">
                        <lmf:RelatedForm>
                            <xsl:attribute name="targets">
                                <xsl:value-of select="string-join(current-group()/@ref,' ')"/>
                            </xsl:attribute>
                            <tei:f name="type">
                                <tei:string>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </tei:string>
                            </tei:f>
                        </lmf:RelatedForm>
                    </xsl:for-each-group>
                    <!-- Creates grammaticalInfo -->
                    <xsl:if test="./sense/grammatical-info">
                        <tei:f name="grammaticalInfo">
                            <tei:string>
                                <xsl:value-of select="./sense/grammatical-info/@value"/>
                            </tei:string>
                        </tei:f>
                    </xsl:if>
                    <!-- End grammatical-Info -->
                   </lmf:LexicalEntry>
            </xsl:for-each>
            <!-- End LexicalEntry -->
        </lmf:Lexicon>
        <!-- End Lexicon -->
    </xsl:template>
  
<!-- removes entry -->  
 <xsl:template match="entry"/>

    <!-- Copies everything over from the original document -->
    <xsl:template match="*">
        <xsl:copy-of select="self::node()"/>
    </xsl:template>
</xsl:stylesheet>
