<template>
  <div class="panel panel-default" :class="{ last: isLast }">
    <div class="panel-heading">
      <h5
        class="panel-title"
        v-on:click="toggle()"
        :title="errorCategory.constraintID"
      >
        <span v-for="(tag, index) in tagslist" :key="'' + index + tag">
          <span v-show="tag === 'ERROR'" class="mr15 label label-danger">
            ERROR
          </span>
          <span v-show="tag === 'WARNING'" class="mr15 label label-warning">
            WARNING
          </span>
          <span v-show="tag === 'INFO'" class="mr15 label label-info">
            INFO
          </span>
        </span>
        <span v-if="errorCategory.title">{{ errorCategory.title }}</span>
        <span v-else>Untitled message</span>
      </h5>
    </div>
    <transition name="grow">
      <div class="panel-body" v-if="show">
        <div class="row">
          <div class="col-xs-3">
            <ul class="nav nav-pills nav-stacked text-left">
              <li :class="{ active: activeIndex === 0 }">
                <a v-on:click="setActive(0)">Description</a>
              </li>
              <li
                v-if="
                  errorCategory.longUserDesc ||
                    (errorCategory.tags && errorCategory.tags.length > 0)
                "
                :class="{ active: activeIndex === 1 }"
              >
                <a v-on:click="setActive(1)">
                  More Information
                </a>
              </li>

              <li :class="{ active: activeIndex === 2 }">
                <a v-on:click="setActive(2)">
                  Specifications
                  <span class="badge badge-default">{{
                    errorCategory.specs.length
                  }}</span>
                </a>
              </li>

              <li :class="{ active: activeIndex === 3 }">
                <a v-on:click="setActive(3)">
                  Error Details
                  <span class="badge badge-default">{{
                    errorCategory.errors.length
                  }}</span>
                </a>
              </li>
            </ul>
          </div>
          <div class="col-xs-9" v-if="activeIndex === 0">
            <div v-if="errorCategory.shortUserDesc">
              {{ errorCategory.shortUserDesc }}
              <hr />

              <button
                class="btn btn-xs btn-outline"
                v-for="spec in errorCategory.specs"
                v-on:click="setActive(2)"
                :title="
                  'Violates the ' + spec.name + ' with ' + spec.errorLevel
                "
                :class="{
                  filtered:
                    FILTERS['Specifications'].length > 0 &&
                    FILTERS['Specifications'].indexOf(spec.nameAcronym) === -1,
                  'btn-danger': spec.errorLevel === 'ERROR',
                  'btn-warning': spec.errorLevel === 'WARNING',
                  'btn-info': spec.errorLevel === 'INFO'
                }"
                :key="spec"
              >
                <i class="fa fa-book" /> {{ spec.nameAcronym }}
              </button>
              <template v-for="tag in errorCategory.tags">
                <button
                  :key="tag"
                  class="btn btn-xs btn-default btn-outline"
                  v-on:click="setActive(1)"
                >
                  <i class="fa fa-tag" /> {{ tag.longDesc }}
                </button>
              </template>
            </div>
          </div>
          <div class="col-xs-9" v-if="activeIndex === 1">
            {{ errorCategory.longUserDesc }}
            <tags :tags="errorCategory.tags" />
          </div>
          <div class="col-xs-9" v-if="activeIndex === 2">
            <Specifications
              :FILTERS="FILTERS"
              :specifications="errorCategory.specs"
            />
          </div>
          <div class="col-xs-9" v-if="activeIndex === 3">
            <Errors :errors="errorCategory.errors" />
          </div>
          <div class="col-xs-9" v-if="activeIndex === 4">
            <tags :tags="errorCategory.tags" />
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import Specifications from "./Specifications.vue";
import tags from "./Tags.vue";
import Errors from "./Errors.vue";
export default {
  name: "validation-result",
  computed: {
    show() {
      return this.$store.state.activeTab === this.ErrorIndex;
    },
    tagslist() {
      const vals = this.errorCategory.specs.map(it => it.errorLevel);
      return Array.from(new Set(vals));
    },
    isLast() {
      return this.$store.getters.filteredReport.length - 1 === this.ErrorIndex;
    },
    activeIndex() {
      return this.$store.state.tabForError[this.ErrorIndex] || 0;
    }
  },
  methods: {
    toggle() {
      this.$store.commit("setActive", this.ErrorIndex);
    },
    setActive(newIndex) {
      this.$store.commit("tabForError", { [this.ErrorIndex]: newIndex });
    }
  },
  props: ["errorCategory", "ErrorIndex", "FILTERS"],
  components: {
    Specifications,
    tags,
    Errors
  }
};
</script>

<style lang="less" scoped="true">
.label {
  padding: 2px 0.3em 0;
}
h5 {
  line-height: 125%;
}
a {
  cursor: pointer;
}
h5 {
  cursor: pointer;
}
.mr15 {
  margin-right: 15px;
}
.panel {
  margin-bottom: 0;
  border-bottom-width: 0;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
  &.last {
    margin-bottom: 20px;
    border-bottom-width: 1px;
    border-top-right-radius: 0;
    border-top-left-radius: 0;
    border-bottom-right-radius: 4px;
    border-bottom-left-radius: 4px;
  }
}
.grow-enter-active,
.grow-leave-active {
  transition: all 0.3s ease-in-out;
  max-height: 300px;
  overflow: hidden;
}
.grow-enter,
.grow-leave-to {
  max-height: 0px;
  opacity: 0;
  overflow: hidden;
  &.panel-body {
    padding: 0;
  }
}
.btn-outline {
  background-color: transparent;
  color: inherit;
  transition: all 0.5s;
  margin: 0 5px 5px 0;
}

.btn-primary.btn-outline {
  color: #428bca;
}

.btn-success.btn-outline {
  color: #5cb85c;
}

.btn-info.btn-outline {
  color: darken(#5bc0de, 25%);
}

.btn-warning.btn-outline {
  color: darken(#f0ad4e, 20%);
}

.btn-danger.btn-outline {
  color: #d9534f;
}
.btn.filtered {
  color: gray;
  border-style: dotted;
  border-color: gray;
}

.btn-primary.btn-outline:hover,
.btn-success.btn-outline:hover,
.btn-info.btn-outline:hover,
.btn-warning.btn-outline:hover,
.btn-danger.btn-outline:hover {
  color: #cfcfcf;
}
</style>
