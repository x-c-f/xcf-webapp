<template>
  <div class="Tags">
    <h2><i class="fa fa-tags"/> Tags</h2>
    <template v-for="tag in tags">
      <button class="btn  btn-sm btn-default">
        <i class="fa fa-tag"/>
        {{tag.type}}: {{ tag.longDesc}}
      </button>
  </template>
</div>
</template>
<script>
export default {
  name: 'tags',
  props: ['tags'],
  computed: {
    filters () {
      return this.$store.state.FILTERS;
    }
  }

};
</script>

<style lang="less" scoped="true">
h2 {
  color:gray;
  font-size:97%;
}
.Tags {
  margin-top: 1.5em;
  button {
    margin-right: 3px;
    margin-top: 3px;
    font-size: 86%;
  }
}
</style>
