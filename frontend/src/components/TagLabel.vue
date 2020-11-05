<template>
  <transition-group name="list" tag="label">
    <label
      class="btn btn-default btn-filter button-label"
      :key="filter.Long + ':' + TagGroup.TagGroup.type"
      @mouseenter="hoverclass = true"
      @mouseleave="hoverclass = false"
      v-if="FILTERS[TagGroup.TagGroup.type].indexOf(filter.Long) > -1"
    >
      <input
        type="checkbox"
        class="hidden-checkbox"
        :value="filter.Long"
        v-model="FILTERS[TagGroup.TagGroup.type]"
        @change="updateFilter"
      />
      <transition name="fade">
        <i
          key="check"
          class="fawidth fa"
          :class="{
            'fa-check-square-o': !hoverclass,
            'fa-square-o': hoverclass,
            empty: hoverclass
          }"
        />
      </transition>
      {{ TagGroup.TagGroup.type | tagType }} {{ filter.Long }}
    </label>
  </transition-group>
</template>
<script>
// require("font-awesome-webpack!../../font-awesome.config.js");
export default {
  name: "TagLabel",
  props: ["filter", "FILTERS", "TagGroup"],
  mounted() {},
  data: () => {
    return {
      show: false,
      hoverclass: false
    };
  },
  filters: {
    tagType(tagname) {
      var tagType;
      switch (tagname) {
        case "Specifications":
          tagType = "Spec:";
          break;
        case "Error Level":
          tagType = "";
          break;
        case "Error type":
          tagType = "Type:";
          break;
        case "Editorial constraints":
          tagType = "Editorial:";
          break;
        default:
          tagType = tagname;
      }
      return tagType;
    }
  },
  methods: {
    updateFilter() {
      this.$store.commit("filter", this.FILTERS);
    }
  }
};
</script>

<style lang="less" scoped="true">
.bg {
  padding: 0 4px 0 4px;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  -webkit-touch-callout: none; /* iOS Safari */
  -webkit-user-select: none; /* Safari */
  -khtml-user-select: none; /* Konqueror HTML */
  -moz-user-select: none; /* Firefox */
  -ms-user-select: none; /* Internet Explorer/Edge */
  user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome and Opera */
}
.fawidth {
  width: 11px;
  opacity: 1;
}
.empty {
  opacity: 0.5;
}
label.bolder {
  font-weight: bold;
  color: #3d3d3d;
}
label.disabled {
  color: #5c5c5c;
}

.float-left {
  float: left;
}
.btn-filter {
  margin-right: 3px;
  margin-bottom: 2px;
  font-size: 84%;
  cursor: pointer;
  padding: 0;
}
.button-label {
  font-weight: normal;
  cursor: pointer;
  padding: 6px 12px;
  margin-bottom: 0px;
}

.hidden-checkbox {
  display: none;
}

.tagsFilter {
  max-height: 200px;
  overflow: scroll;
}

.list-item {
  display: inline-block;
  margin-right: 10px;
  max-width: 400px;
}
.list-enter-active,
.list-leave-active {
  transition: all 0.5s;
}
.list-enter, .list-leave-to /* .list-leave-active below version 2.1.8 */ {
  opacity: 0;
  max-width: 0px;
  margin-right: 0px;
  padding-left: 0;
  padding-right: 0;
  transform: translateY(-90px);
}
.push-enter,
.push-leave-to
/* .fade-leave-active in <2.1.8 */
 {
  opacity: 0;
  max-height: 0;
  overflow: hidden;
}
</style>
