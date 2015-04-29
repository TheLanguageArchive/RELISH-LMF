RELISH-LMF
==========

In 2008 ISO published the [Lexical Markup Framework](http://www.lexicalmarkupframework.org/) (LMF; [ISO 24613:2008](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=37327))
which provides an object model (specified in [UML](http://en.wikipedia.org/wiki/Unified_Modeling_Language)) for lexica. The object
model is a series of extensions of a LMF core model. When a user wants
to design a LMF compliant lexicon she needs to select not only the
needed extensions, i.e., objects and their associations, but also data
categories from the [ISOcat](http://www.isocat.org/) Data Category Registry (DCR) to adorn these
objects with, in general linguistic, features. In the informative Annex
R a [DTD](http://en.wikipedia.org/wiki/Document_Type_Declaration) is given to serialize the full LMF object model to XML. However,
this DTD has various shortcomings:

- the links from features to the ISOcat DCR are underspecified
  alternative feature structure representations, e.g., [TEI](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/FS.html)/[ISO feature structures](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=37324) and [feature system declarations](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=43823), are not supported
- there is no way to select the LMF extensions needed by the lexicon
  by default the schema contains all of them
  there is no way to add lexicon-specific extensions
- not all UML constructions and constraints can be supported by a DTD
  and as a result the schema is more lax then the standards UML model

The RELISH LMF schema overcomes these problems by adopting two more
modern XML schema languages: [Relax NG](http://relaxng.org/) ([ISO/IEC 19757-2:2008](http://standards.iso.org/ittf/PubliclyAvailableStandards/c052348_ISO_IEC_19757-2_2008(E).zip)) and
[Schematron](http://www.schematron.com/) ([ISO/IEC 19757-3:2006](http://standards.iso.org/ittf/PubliclyAvailableStandards/c040833_ISO_IEC_19757-3_2006(E).zip)). Also various recommended W3C XML
vocabularies are supported, e.g., `@xml:id` and `@xml:lang`.

This README describes the [usage](#usage) of the RELISH LMF schema, but also some of
the [design](#design) decisions. There are also some [publications](#pubs).

<a name="usage"></a>Usage
-----
To build a RELISH LMF schema for a lexicon the following template has to
be filled out:

```xml
<grammar
  xmlns="http://relaxng.org/ns/structure/1.0"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes"
  xmlns:lmf="http://www.lexicalmarkupframework.org/"
  xmlns:dcr="http://www.isocat.org/ns/dcr"
>

  <!-- 0. always -->
  <include href="path-to-relish-lmf/RELISH-LMF-common.rng"/>
  <include href="path-to-relish-lmf/RELISH-LMF-core.rng"/>

  <!-- 1. choose a feature structure representation -->

  <!-- 2. optionally: select LMF extensions -->

  <!-- 3. optionally: add your own extensions -->

</grammar>
```

Download the files you need using the links provided below and replace
in the template the path-to-relish-lmf by the path to these files. There
is also an archive containing all the files.

Two Relax NG modules are always needed:

1. [RELISH LMF common declarations](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-common.rng)
2. [LMF core package](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-core.rng)

Two feature structure serializations are provided:

1. [`<feat .../>` elements](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-fs-lmf.rng) as used in the ISO LMF standard but extended
with Data Category Reference attributes
2. [TEI/ISO feature structures and feature system declarations](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-fs-tei.rng) (also
needs [these files](https://github.com/TheLanguageArchive/RELISH-LMF/tree/master/schema/tei) in a tei subdirectory)

In the template one of them needs to be chosen:

```xml
<!-- 1. choose fs -->
<include href="path-to-relish-lmf/RELISH-LMF-fs-lmf.rng"/>
```

All the LMF extensions have been implemented as Relax NG modules:

1. [Morphology extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-morphology.rng)
2. [Machine readable dictionary extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-MRD.rng)
3. [NLP syntax extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-syntax.rng)
4. [NLP semantics extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-semantics.rng)
5. [NLP multilingual notations extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-multilingual-notations.rng)
6. [NLP morphological patterns extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-morphological-patterns.rng)
7. [NLP multiword expression patterns extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-MWE.rng)
8. [Constraint expression extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-constraint-expression.rng)

Pick the modules you need and add them to the schema:

```xml
<!-- 2. optionally: select LMF extensions -->
<include href="path-to-relish-lmf/RELISH-LMF-morphology.rng"/>
```

Notice that some extensions depend on each other. See comments in the
top of the Relax NG modules or Figure 2 in the LMF standard.

Due to the use feature structures LMF is already easily extensible.
However, sometimes extensions of the object model are needed. Your own
extensions can be declared in Relax NG (there is a good [online book](http://books.xmlschemata.org/relaxng/) by
Eric van der Vlist) and added to the lexicon schema. To make your
extensions explicit new elements or attributes should use your or their
own [XML namespace](http://en.wikipedia.org/wiki/XML_namespace) URL. RELISH LMF uses
`http://www.lexicalmarkupframework.org/` as its XML namespace URL.

```xml
<!-- 3. optionally: add your own extensions -->
<!-- Define an User element
  (using http://example.com as the XML namespace URL) -->

<define name="myexample.User">
  <element name="User" ns="http://example.com">
    <ref name="myexample.User.attributes"/>
    <ref name="myexample.User.content"/>
  </element>
</define>

<define name="myexample.User.attributes">
  <ref name="relish.lmf.common.attributes"/>
</define>

<define name="myexample.User.content">
  <interleave>
    <ref name="relish.lmf.fs"/>
  </interleave>
</define>

<!-- Link User to Lexical Resource -->
<define name="relish.lmf.LexicalResource.content" combine="interleave">
  <interleave>
    <zeroOrMore>
      <ref name="myexample.User"/>
    </zeroOrMore>
  </interleave>
</define>
```

This example shows the pattern used in RELISH LMF to declare an XML
element:

- a main definition of the element which refers to:
- a definition of the attributes, which should at least refer to
  `relish.lmf.common.attributes` or `relish.lmf.common.attributes.mandatory-id`
- a definition of the content, which should at least refer to
  `relish.lmf.fs` and use interleaving (allow child elements to appear in
  any order)

This allows extensions to add attributes or child elements as shown for
Lexical Resource.

RELISH LMF tries to retain some more information from the inheritance in
the LMF object model by requiring a `@type` which indicates the super
class. This allows Schematron rules to make the schema less lax, e.g.,
the core model requires that an valid lexical entry should always
contain an instance of a Form subclass like Lemma. So if your extension
includes a subclass the (highest) super class should be specified in
`@type`. See the `relish.lmf.Lemma.attributes definition` in the [Morphology
extension](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-morphology.rng) for an example.

Now that the lexicon schema is ready it can be used to validate XML
instantiations of it. First an instance has to be associated with the
schema using an [xml-model processing instruction](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/schema/RELISH-LMF-morphology.rng):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="path-to-your-lexicon/schema.rng"
type="application/xml"
  schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="path-to-your-lexicon/schema.rng"
type="application/xml"
  schematypens="http://purl.oclc.org/dsdl/schematron"?>
```

Notice that the same schema is associated twice. The first association
triggers the Relax NG validation and the second one Schematron
validation. For example, [oXygen](http://www.oxygenxml.com/) understands this processing instruction
will perform both Relax NG and Schematron validation.

```xml
<LexicalResource
  xmlns="http://www.lexicalmarkupframework.org/"
  lmfVersion="ISO 24613:2008"
  xmlns:dcr="http://www.isocat.org/ns/dcr"
  xmlns:ex="http://example.com"
>
  <ex:User xml:id="jd">
    <feat
      att="first name" dcr:datcat="http://www.isocat.org/datcat/DC-4194"
      val="John"
    />
    <feat
      att="last name" dcr:datcat="http://www.isocat.org/datcat/DC-4195"
      val="Doe"
    />
  </ex:User>
  <GlobalInformation>
    <feat
      att="languageCoding"
dcr:datcat="http://www.isocat.org/datcat/DC-2008"
      val="ISO 639-3"
    />
  </GlobalInformation>
  <Lexicon xml:lang="en">
    <feat
      att="language" dcr:datcat="http://www.isocat.org/datcat/DC-1969"
      val="eng"/>
    <LexicalEntry xml:id="le0001">
      <feat
        att="partOfSpeech"
dcr:datcat="http://www.isocat.org/datcat/DC-1345"
        val="commonNoun"
dcr:valueDatcat="http://www.isocat.org/datcat/DC-1256"
      />
      <Lemma type="Form">
        <feat
          att="writtenForm"
dcr:datcat="http://www.isocat.org/datcat/DC-1836"
          val="clergyman"
        />
      </Lemma>
    </LexicalEntry>
  </Lexicon>
</LexicalResource>
```

This instance exposes some of the changes compared to the LMF DTD RELISH
LMF introduces:

- there is a version attribute `@lmfVersion` which refers to the current
  ISO LMF standard
- IDs are specified using the W3C [`@xml:id`](http://www.w3.org/TR/xml-id/) recommendation which allows
  XML tools to exploit them even without loading the schema
- also [`@xml:lang`](http://www.w3.org/TR/REC-xml/#sec-lang-tag) is allowed which can, for example, be exploited by
  XML search engines to enable language specific stemming and stopping
- features can identify the ISOcat data categories they use using
  `@dcr:datcat` for features and `@dcr:valueDatcat` for feature values (where
  applicable); this is also [supported](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-att.datcat.html) by TEI feature structures
- the `@type` which indicates that *Lemma* is a subclass of *Form*

Notice that the annotating the individual feature instantiations with
data categories quickly becomes highly redundant. In general it's
advised to annotate a resource schema. However, in (RELISH) LMF the
schema (DTD or Relax NG) can only specify feature structures in a
generic way. Fortunately, the TEI feature structure representation also
supports feature system declarations. RELISH LMF supports a `tei:fsdDecl`
element under `LexicalResource`. The examples include an instance document
showing this.

Note: At the time of writing TEI P5 2.1.0 doesn't support `@dcr:datcat` on
`tei:fDecl`, which is clearly intended in the text. For now RELISH LMF has
added this via its TEI feature structure representation module. This
omission has been reported (see [bug report](https://sourceforge.net/tracker/?func=detail&aid=3569990&group_id=106328&atid=644062)).

Examples
--------
Here are some small examples. Some only differ in which feature
structure representation they use.

1. [schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example.rng) and [instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example.xml) (the example build up above)
2. [schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-1.rng) and [instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-1.xml) (using the LMF feature representation)
3. [schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-2.rng) and [instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-2.xml) (using the TEI feature structures)
4. [schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-3.rng) and [instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/example-3.xml) (using the TEI feature structures and also
   feature system declarations)

Tests
-----
To test the completeness and compliance of RELISH LMF a set of test
schemas and documents have been collected and created.

The following tests are examples taken from the standards text. Where
needed the example has been extended to get a valid document, e.g.,
outer elements have been added or stubs for referential integrity.

- ISO 24613:2008 Annex B Morphology examples ([schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/B.rng) and [instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/B-3-1.xml))
- ISO 24613:2008 Annex F NLP syntax examples ([schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/F.rng) and instances for [F.2.1](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/F-2-1.xml) and [F.2.2](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/F-2-2.xml))
- ISO 24613:2008 Annex H NLP semantic examples ([schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/H.rng) and instances for [H.1.2.1](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/H-1-2-1.xml), [H.1.2.2](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/H-1-2-2.xml) and [H.1.2.3](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/H-1-2-3.xml))
- ISO 24613:2008 Annex J NLP multilingual notations examples ([schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/J.rng) and instances for [J.2.1](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/J-2-1.xml) and [J.2.2](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/ISO-24613-2008-LMF/J-2-2.xml))

In the [LIRICS project](http://lirics.loria.fr/) LMF test documents have been created (see also the
[LMF website](http://www.lexicalmarkupframework.org/)). They have been adapted to RELISH LMF (but some needed some
fixes) and used as test cases.

- the [schema](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/LIRICS.rng)
- the [EnglishLMFTestSuites1 instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/EnglishLMFTestSuites1.xml)
- the [EnglishLMFTestSuites2 instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/EnglishLMFTestSuites2.xml) (the original version was invalid
  as the DTD is order specific and requires `SubcategorizationFrame` to
  precede `SubcategorizationFrameSet`, this isn't a problem in RELISH LMF
  which is order independent)
- the [EnglishLMFTestSuites3 instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/EnglishLMFTestSuites3.xml)
- the [FrenchLMFTestSuites1 instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/FrenchLMFTestSuites1.xml) (the original version was invalid
  as the DTD is order specific and requires `SubcategorizationFrame` to
  precede `SubcategorizationFrameSet`, this isn't a problem in RELISH LMF
  which is order independent)
- the [FrenchLMFTestSuites2 instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/FrenchLMFTestSuites2.xml)
- the [ItalianLMFTestSuites instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/ItalianLMFTestSuites.xml) (the original version was invalid
  as the DTD doesn't expect the attributes `synFeature` and `semFeature` for a
  `SynSemArgMap` element)
- the [SpanishLMFTestSuites instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/SpanishLMFTestSuites.xml)

<a name="design"></a>Design decisions
----------------
*ISOcat data categories*

RELISH LMF supports the [ISOcat Data Category Reference vocabulary](http://www.isocat.org/12620/schemas/DCR.html). This
allows to associate a feature with its proper data categories, e.g.,
`<feat att="languageCoding" dcr:datcat="http://www.isocat.org/datcat/DC-2008" val="ISO 639-3"/>`

*Schematron*

RELISH LMF embeds Schematron rules to check UML constraints and
constructs that can't be expressed in Relax NG:

- Global Information should contain the /*language coding*/ feature/data
category
- A Lexical Entry should contain at least one instance of a subclass
of Form
- A List of Components should contain at least 2 Components

*From UML to XML*

To be able to serialize to XML the UML construction used in LMF model
need to be expressed somehow in XML. The standard is not explicit (and
consistent) in this mapping. The following patterns were recognized and
used in RELISH LMF:
- Each non-abstract class is represented by an XML element, e.g.,
  *Lexical Resource* is represented by a `LexicalResource` element.
- If there is an aggregation the subordinate element is nested in the
  parent element, e.g., `GlobalInformation` is nested inside
  `LexicalResource`.
- If there is an aggregation with an abstract class any non-abstract
  subclass can be nested in the element corresponding to the parent class,
  e.g., `Lemma` is nested inside `LexicalEntry`.
- If there is a directed association the element corresponding to the
  originating class has an IDREF or IDREFS-typed attribute referring to an
  instance of the other class, e.g., a `LexicalEntry` instance can have an
  attribute `mwePattern` that refers to an instance of `MWEPattern` via its
  unique id.
- Cardinality constraints are taken over into the schema where
  possible, e.g., a `Lexicon` should contain at least one `LexicalEntry`.

RELISH LMF additionally uses the following patterns:
- In a specialized class the name of the parent (abstract) class is
  specified in the type attribute, e.g., `<Lemma type="Form"/>`.
- Cardinality constraints with an abstract class are checked using the
  type attribute and a Schematron rule, e.g., a `LexicalEntry` should at
  least contain one instance of a subclass of *Form*.
- Cardinality constraints inexpressible in the schema are checked by a
  Schematron rule, e.g., a `ListOfComponent` should contain at least two
  `Component` instances.

Using these patterns RELISH LMF mimics the LMF UML class model in XML
and tried to stay close to the original DTD. At some places the UML
class model contains undirected associations and then the DTD was used
to determine the direction:
- NLP semantics extension:
  - The association between *Sense* and *Synset* is expressed by the IDREF-typed `synset` attribute on `Sense`.
  - The association between *Predicative Representation* and *Semantic
    Predicate* is expressed by the IDREF-typed `predicate` attribute on
    `PredicativeRepresentation`.
  - The association between *Predicative Representation* and
    *SynSemCorrespondence* is expressed by the IDREFS-typed `correspondences`
    attribute on `PredicativeRepresentation`.
  - The association between *SynSemArgMap* and *Syntactic Argument* is
    expressed by the `synFeature` attribute on `SynSemArgMap`. Note: regarding
    the type of the attribute see the explanation of outliers below.
  - The association between *SenSemArgMap* and *Semantic Argument* is
    expressed by the `semfeatures` attribute on `SynSemArgMap`. Note: regarding
    the type of the attribute see the explanation of outliers below.
- NLP multilingual notations extension:
  - The association between *Sense Axis* and *Sense* is expressed by the IDREFS-typed `senses` attribute on `SenseAxis`.
  - The association between *Sense Axis* and *Synset* is expressed by
    the IDREFS-typed `synsets` attribute on `SenseAxis`.
  - The association between *Target Test* and *Syntactic Behaviour* is
    expressed by the IDREFS-typed `syntacticBehaviours` attribute on
    `TargetTest`.
  - The association between *Source Test* and *Syntactic Behaviour* is
    expressed by the IDREFS-typed `syntacticBehaviours` attribute on
    `SourceTest`.
  - The association between *Transfer Axis* and *Syntactic Behaviour* is
    expressed by the IDREFS-typed `syntacticBehaviours` attribute on
    `TransferAxis`.
  - The association between *Context Axis* and *Context* is expressed by
    the IDREFS-typed `examples` attribute on `ContextAxis`.
- NLP multiword experession patterns extension (MWE):
  - The association between *MWE Pattern* and *Lexical Entry* is
    expressed by the IDREF-typed `mwePattern` attribute on `LexicalEntry`.

Outliers, i.e., here the serialization is diverging from the patterns:
- Conform the DTD the directed association between *SynArgMap* and
  *Syntactic Argument* in the NLP syntax extension is not expressed in an
  IDREFS-typed attribute but in two IDREF attributes `arg1` and `arg2` to
  capture the cardinality constraint.
- The undirected associations between *SynSemArgMap* and *Syntactic
  Argument* and *Semantic Argument* are expressed by the attributes
  `synFeature` and `semFeatures` on `SynSemArgMap`, but these don't contain IDs
  conform the examples in H.1.2.3 and the [ItalianLMFTestSuites instance](https://github.com/TheLanguageArchive/RELISH-LMF/blob/master/examples/LIRICS/ItalianLMFTestSuites.xml)
  from LIRICs. (Note: the DTD doesn't contain these attributes and the
  example in H.1.2.3 puts the information inside the feature structure.
  RELISH LMF aims to be consistent and follow the pattern as much as
  possible.)
- The directed association between *MWE Lex* and *Component* isn't
  expressed at all. The standard says "the components are not referenced
  directly but, on the contrary, they are referenced by their respective
  ordering as specified in the *List of Component* instance". 

Unresolved issues where especially [any advice/feedback](mailto:Menzo.Windhouwer@mpi.nl) is highly
appreciated:
- The association between *Predicative Representation* and *Syntactic
  Behavior* isn't expressed in the DTD, and also not in RELISH LMF. What
  should the direction be and how should the role be named?
- A *Semantic Argument* instance must have an association with exactly
  one instance of *SynSemArgMap*, however these associations are not
  expressed in a resolvable fashion (see the outlier above). Is there a
  way to resolve these associations?
- *Affix Allomorph* is a subclass of *Form Representation*, which would
  mean that anywhere where `FormRepresentation` is allowed also
  `AffixAllomorph` should be allowed. The standard text contradicts the
  direction of the inheritance: "*Affix Allomorph* is a generalization of
  the *Form Representation* class ...". In the DTD the relationship is
  implemented as an aggregation, i.e., zero or more `FormRepresentation`
  instances can be nested in an `AffixAllomorph` instance. How to interpret
  and implement this inheritance relationship? For now RELISH LMF follows
  the UML class model, i.e., `<AffixAllomporh type="FormRepresentation"/>`,
  but `AffixAllomorph` is not yet allowed everywhere where
  `FormRepresentation` is allowed.

Additional differences with the DTD:
- `MWENode` allows to nest zero or more `MWELex` instances.

<a name="pubs"></a>Publications
------------
- Windhouwer, M., Petro, J., Shayan, S. [RELISH LMF: Unlocking the Full Power of the Lexical Markup Framework](http://www.lrec-conf.org/proceedings/lrec2014/summaries/154.html). In *Proceedings of the Ninth International Conference on Language Resources and Evaluation* ([LREC 2014](http://lrec2014.lrec-conf.org/en/)), European Language Resources Association ([ELRA](http://www.elra.info/)), Reykjavik, Iceland, May 28-30, 2014. 
- Windhouwer, M. RELISH LMF: unlocking the full power of the Lexical Markup Framework. At the *24th Meeting of Computational Linguistics in the Netherlands* ([CLIN 24](http://clin24.inl.nl/)), Leiden, The Netherlands, January 17, 2014. ([poster](http://www.windhouwer.nl/menzo/professional/papers/CLIN-2014-RELISH-LMF.pdf))
- Windhouwer, M., Petro, J., Nevskaya, I., Drude, S., Aristar-Dry, H. Gippert, J. Creating a Serialization of LMF: The experience of the RELISH project. In [*LMF: Lexical Markup Framework, Theory and Practice*](http://www.iste.co.uk/index.php?f=a&ACTION=View&id=566), Gil Francopoulo (ed). Iste (Europe)/Wiley (US). 2013.