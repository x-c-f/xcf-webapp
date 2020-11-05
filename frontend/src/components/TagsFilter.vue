<template>
  <div style="background-color:#e7e7e7;padding: 1em 1em;margin-bottom:0.5em;">
    <div class="row">
      <div class="col-xs-3">
        <button class="btn btn-default" v-on:click="show = !show">
          <i v-if="!show" class="fa fa-search" />
          <i v-if="show" class="fa fa-close" />
          Filter Options
        </button>
      </div>
      <div class="col-xs-9">
        <transition name="push">
          <div>
            <span v-if="hasFilters">Selected filters:</span>
            <template v-for="TagGroup in tags.Tags">
              <template v-for="filter in TagGroup.TagGroup.TagList">
                <TagLabel
                  :filter="filter"
                  :FILTERS="FILTERS"
                  :TagGroup="TagGroup"
                  :key="filter.Long + ':' + TagGroup.TagGroup.type"
                />
              </template>
            </template>
          </div>
        </transition>
      </div>
    </div>
    <transition name="push">
      <div class="TagsFilter row" v-if="show">
        <div class="col-xs-3" v-for="TagGroup in tags.Tags" :key="TagGroup">
          <h5 class="text-left">{{ TagGroup.TagGroup.type }}</h5>
          <div
            class="checkbox"
            v-for="filter in TagGroup.TagGroup.TagList"
            :key="filter"
          >
            <label
              :class="{ disabled: filter.disabled, bolder: !filter.disabled }"
            >
              <input
                type="checkbox"
                :value="filter.Long"
                v-model="FILTERS[TagGroup.TagGroup.type]"
                @change="updateFilter"
              />
              {{ filter.Long }}
            </label>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>
<script>
require("font-awesome-webpack!../../font-awesome.config.js");
import TagLabel from "./TagLabel";
export default {
  name: "tagsFilter",
  components: { TagLabel },
  props: ["tags", "FILTERS", "hasFilters"],
  mounted() {},
  data: () => {
    return {
      show: false,
      hoverclass: ""
    };
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

.push-enter,
.push-leave-to
/* .fade-leave-active in <2.1.8 */
 {
  opacity: 0;
  max-height: 0;
  overflow: hidden;
}
</style>
