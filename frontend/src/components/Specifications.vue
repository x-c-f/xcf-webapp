<template>
  <div class="spec">
    <div v-if="specifications.length === 0">
      There are no specifications for this message.
    </div>
        <div v-for="spec in specs" :key="spec.nameAcronym + '' + spec.errorLevel" class="bs-callout" :class="spec.className">
          <h4>{{spec.nameAcronym}} <small>{{ spec.errorLevel }}</small></h4>
          <h6>{{spec.name}}</h6>
          <dd><i class="fa fa-external-link"></i> <a :href="spec.uri" target="_blank">{{ spec.nameAcronym ||""}} {{ spec.section || "Open Reference" }}</a></dd>
          <dd>{{ spec.text}}</dd>
        </div>
  </div>
</template>

<script>
export default {
  name: 'specifications',
  props: ['specifications', "FILTERS"],
  computed: {
    specs () {
      return this.specifications.map(spec => {
        switch (spec.errorLevel) {
          case 'ERROR':
            spec.className = "bs-callout-danger";
            break;
          case 'WARNING':
            spec.className = "bs-callout-warning";
            break;
          case 'INFO':
            spec.className = "bs-callout-info";
            break;
          default:
            spec.className = "bs-callout-default";
        }
        spec.className += this.FILTERS.Specifications.length === 0 || this.FILTERS.Specifications.indexOf(spec.nameAcronym) !== -1 ? '' : ' filtered';
        return spec;
      });
    }
  }
};
</script>

<style lang="less" scoped="true">
h6 {
  font-size:95%;
  margin-top:0;
}
</style>
