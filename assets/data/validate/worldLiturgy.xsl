<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:template match="/">
  <html>
  <body>
    <div style="width:500px;" align="center">
      <h1>Prayer Books</h1>
      <xsl:for-each select="prayer_books/prayer_book">
        <h1><xsl:value-of select='title'/></h1>
        <xsl:for-each select="service">

          <xsl:for-each select="section">
            <h2><xsl:value-of select='major_header'/></h2>
            <h3><xsl:value-of select='number'/> &#160;&#160;<xsl:value-of select='title'/></h3>
            <p style='text-transform: uppercase; font-size:.8rem'><xsl:value-of select='rubric'/></p>

            <xsl:choose>
              <xsl:when test="@visibility = 'indexed'">
                  <p style='font-style:italic; font-size:0.6rem'>Indexed: Items in this section will show title and ref, then a tap will open the rest.</p>

                  <div style='border:3px solid blue'>
                    <xsl:for-each select="item">
                      <h4><xsl:value-of select='title'/> &#160;
                      <i><xsl:value-of select="ref"/></i></h4>
                      <p style='text-transform:uppercase; font-size:0.8rem;'>Tap to Expand</p>
                    </xsl:for-each>
                    <p style='font-style:italic; font-size:0.6rem'>Below are the expanded items:</p>
                    <div style='border:1px dotted blue; margin-top:5px;'></div>

                    <xsl:apply-templates select="item" />
                  </div>

              </xsl:when >
              <xsl:when test="@visibility = 'collapsed'">
                <p style='text-transform:uppercase; font-size:0.8rem;'>Tap to Expand</p>
                <p style='font-style:italic; font-size:0.6rem'>Collapsed: the rest of this section will be displayed on click</p>
                <div style='border:3px solid green'>
                  <xsl:apply-templates select="item" />
                </div>

                </xsl:when>
                <xsl:when test="@type ='collectsSeasons' or @type = 'collectsFeasts' ">
                  <xsl:for-each select="collect">
                    <h5>id:<xsl:value-of select='@id'/></h5>
                    <h3><xsl:value-of select='title'/></h3>
                    <h4><xsl:value-of select='subtitle'/></h4>
                    <p><i><xsl:value-of select='ref'/></i></p>
                    <p style='text-transform: uppercase; font-size:.8rem'><xsl:value-of select="rubric[not(@type='postCommunion')]"/></p>

                    <xsl:apply-templates select="prayer" />
                    <xsl:if test='post_communion_prayer'><p><i>Post Communion</i></p></xsl:if>
                    <p style='text-transform: uppercase; font-size:.8rem'><xsl:value-of select="rubric[@type='postCommunion']"/></p>

                    <xsl:apply-templates select="post_communion_prayer" />

                    <div style='border:1px dotted grey; margin-top:5px;'></div>
                    </xsl:for-each>

                  </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="item" />
              </xsl:otherwise>
            </xsl:choose>
            <div style='border:1px dashed grey; margin-top:5px;'></div>

          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </div>
  </body>
  </html>
</xsl:template>

<xsl:template match='item | prayer | post_communion_prayer'>
  <div style='width:100%; display:flow-root'>
    <xsl:choose>
      <xsl:when test="@type = 'rubric'">
        <p style='text-transform: uppercase; font-size:.8rem'><xsl:value-of select='current()'/></p>
      </xsl:when>
      <xsl:when test="@type = 'title'">
        <h3><xsl:value-of select='current()'/></h3>
      </xsl:when>
      <xsl:when test="@who = 'people' or @who = 'all'">
          <div style='float:right; font-size:0.8rem;'>
            <b><xsl:value-of select='@who'/></b>
          </div>
          <div style='float:right; width 100%; margin-left:50px;'>
            <xsl:choose>
              <xsl:when test="@type = 'stanzas' or @type = 'versedStanzas'">
                <xsl:apply-templates select='stanza'/>
              </xsl:when>
              <xsl:otherwise>
                <p align='right'><xsl:value-of select='text()[normalize-space()]'/>&#160;<i><xsl:value-of select='ref'/></i></p>
              </xsl:otherwise>
            </xsl:choose>
          </div>
      </xsl:when>
      <xsl:when test="@who = 'leader' or @who = 'minister' or @who = 'bishop' or @who = 'assistant' or @who = 'reader'">
          <div style='float:left; font-size:0.8rem;'>
            <b><xsl:value-of select='@who'/></b>
          </div>
          <div style='float:left; width 100%; margin-right:50px;'>

            <p align='left'><xsl:value-of select='text()[normalize-space()]'/>&#160;<i><xsl:value-of select='ref'/></i></p>
          </div>
      </xsl:when>
      <xsl:when test="@who = 'none'">
      </xsl:when>
      <xsl:when test="@type = 'stanzas' or @type = 'versedStanzas'">
        <h3><xsl:value-of select='number'/> &#160;&#160;<xsl:value-of select='title'/></h3>
        <p style='text-transform: uppercase; font-size:.8rem'><xsl:value-of select='rubric'/></p>
        <p style='font-style:italic; font-size:.8rem'><xsl:value-of select='ref'/></p>
        <xsl:apply-templates select='stanza'/>

      </xsl:when>


      <xsl:otherwise>
        <p align='left'><xsl:value-of select='text()[normalize-space()]'/>&#160;<i><xsl:value-of select='ref'/></i></p>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match='stanza'>
  <xsl:choose>
    <xsl:when test='@indent'>
      <xsl:variable name='indent' select='number(@indent)'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name='indent' select='0'/>
      </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="../@type = 'versedStanzas'">
      <xsl:choose>
        <xsl:when test="@verse">
          <p align='left' style='margin:0px 0px 3px 0px'><xsl:value-of select='@verse'/><xsl:text>&#160;&#160;&#160;</xsl:text><xsl:value-of select='text()'/></p>
        </xsl:when>
        <xsl:when test="@type='gloria'">
          <xsl:choose>
            <xsl:when test='@indent'>
              <xsl:variable name='calculatedIndent' select="number(0 + number(@indent)*15)" />
              <p align='left' style='margin:10px 0px 3px {$calculatedIndent}px;'><xsl:value-of select='text()'/></p>
            </xsl:when>
            <xsl:otherwise>
              <p align='left' style='margin:10px 0px 3px 0px;'><xsl:value-of select='text()'/></p>
            </xsl:otherwise>
          </xsl:choose>
          </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test='@indent'>
              <xsl:variable name='calculatedIndent' select="number(50 + number(@indent)*15)" />
              <p align='left' style='margin:0px 0px 3px {$calculatedIndent}px;'><xsl:value-of select='text()'/></p>
            </xsl:when>
            <xsl:otherwise>
              <p align='left' style='margin:0px 0px 3px 50px;'><xsl:value-of select='text()'/></p>
            </xsl:otherwise>
          </xsl:choose>

          </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="../@type = 'stanzas'">
      <xsl:choose>
      <xsl:when test='@indent'>
        <xsl:variable name='calculatedIndent' select="number( number(@indent)*15)" />
        <p align='left' style='margin:0px 0px 3px {$calculatedIndent}px;'><xsl:value-of select='text()'/></p>
      </xsl:when>

      <xsl:otherwise>
        <p align='left' style='margin:0px 0px 3px 0px;'><xsl:value-of select='text()'/></p>
      </xsl:otherwise>
</xsl:choose>

    </xsl:when>
  </xsl:choose>

</xsl:template>

    <!-- <p align='left'><xsl:value-of select='normalize-space(text())'/></p> -->

    <!-- <p align='left'><xsl:value-of select='ref'/></p> -->

    <!-- when rubric
    when title
    when who
       versed and stanzas -->





</xsl:stylesheet>
