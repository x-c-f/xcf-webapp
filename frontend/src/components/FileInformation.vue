<template>
  <div class="bs-callout bs-callout-default">
    <h4>File Information</h4>
      <dl class="dl-horizontal">
       <dt>Filename</dt>
       <dd><kbd v-html="rawReport.filename"/>, {{rawReport.filesize}}</dd>
       <dt>Total Words</dt>
       <dd><kbd>{{ rawReport.totalWords }}</kbd></dd>
       <dt>Words/minute </dt>
       <dd><kbd>{{ rawReport.wpm | numeral }}</kbd></dd>
      </dl>
  </div>
</template>

<script>

export default {
  name: 'file-information',
  props: ["rawReport"],
  components: {
  }
};
</script>

<style scoped="true" lang="less">
 .bs-callout {
   margin: 0 0 .5em 0;
   padding: .7em;
   dl {
     margin-bottom: 5px;
   }
 }
</style>
