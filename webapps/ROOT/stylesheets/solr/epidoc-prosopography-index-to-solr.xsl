<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl"/>

  <xsl:param name="index_type"/>
  <xsl:param name="subdirectory"/>

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:listPerson/tei:person" group-by="tei:persName[@xml:lang='en']">
        <xsl:sort select="current-grouping-key()"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type"/>
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path"/>
          <field name="index_item_name">
            <!--
            <xsl:variable name="name">
              <xsl:for-each select="current-group()/tei:persName">
                <name>
                  <xsl:value-of select="concat(./@xml:lang,'|',./tei:forename, ' ', ./tei:surname)"/>
                </name>
              </xsl:for-each>
            </xsl:variable>
            -->
            <xsl:value-of select="current-grouping-key()"/>

          </field>
          <field name="index_ext_reference">
            <xsl:variable name="pers-id" select="substring-after(@ref, '#')"/>
            <!--
            <xsl:variable name="bibl-string">
              <xsl:for-each
                select="$prosopography//tei:person[@xml:id = $pers-id]//tei:bibl[tei:link]">
                <val>
                  <xsl:value-of select="concat(./tei:citedRange, '_', ./tei:link/@target)"/>
                </val>
              </xsl:for-each>
              
            </xsl:variable>
            <xsl:value-of select="string-join($bibl-string/val, '|')"/>
            -->
          </field>
          <xsl:apply-templates select="current-group()">
            <xsl:sort/>
          </xsl:apply-templates>
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location"/>
  </xsl:template>

</xsl:stylesheet>
