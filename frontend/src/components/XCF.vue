<template>
      <div class="row">
        <div >
          <div  class="col-xs-12">
            <tags-filter :hasFilters="hasFilters" :tags="tags" :FILTERS="FILTERS"/>
          </div>
          <div class=""><hr style="margin:5px 0"/></div>
          <div class="grow" :class="{ 'col-xs-3': !isInitial, 'col-xs-12': isInitial }">
            <form id="uploadform" class="upload" enctype="multipart/form-data" novaliadate>
              <!-- <h2>Upload File</h2> -->
              <div class="dropbox" :class="{'uploading': isSaving}">
                <input type="file" :name="uploadFieldName" :disabled="isSaving"
                @change="filesChange($event.target.name, $event.target.files);"
                class="input-file">
                <p class="overlay" v-if="isSaving">
                  <i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
                  <span class="sr-only">Loading...</span>
                </p>
              <p :class="{dimmmed: isSaving }">
                Drag your XML file here to begin.<br>
                You may also click the gray area to browse your computer.<br />
                <small>We will only store your file temporarily—a few seconds at most—to analyze its contents.</small>
                <div class="text-center">
                  You may also load our example report:<br /><br />
                  <div :class="{ 'col-xs-2 col-xs-offset-4': isInitial, 'col-xs-12 mb-2': !isInitial }">
                    <div class="btn-group btn-group-sm">
                      <button type="button" @click="loadEaxmple('example-1')" class="btn btn-default">Example 1</button>
                      <a href="https://github.com/IRT-Open-Source/xcf_suite_sample/blob/master/instance.xml" target="_blank" class="btn btn-default" title="Show Source"><i class="fa fa-file-code-o"/></a>
                    </div>
                  </div>
                </div>
              </p>
            </div>
            </form>
          </div>
          <transition name="appear" mode="out-in">
            <div class="grow cut-content" :class="{ 'col-xs-9': !isInitial, 'col-xs-0': isInitial }">
            <div key="failed" v-if="isFailed">
              <error-panel :message="uploadError"/>
            </div>
            <div key="report" v-else-if="!isSaving && !isInitial">
              <h2>Validation Results <small v-if="report.length>0">{{filtered.length}} of {{ report.length }}</small></h2>
              <validation-results :filtered="filtered" :FILTERS="FILTERS" :report="report" :rawReport="rawReport"/>
            </div>
            <div  v-else-if="isSaving">
              <h2>Working <i class="fa fa-gears"/></h2>
              <p>Your file is being processed…</p>
            </div>
          </div>
        </transition>
      </div>
  </div>
</template>

<script>
import ErrorPanel from './Panel.vue';
import ValidationResults from './ValidationResults.vue';
import TagsFilter from './TagsFilter.vue';
// import f from "../store/more";

const STATUS_INITIAL = 0;
const STATUS_SAVING = 1;
const STATUS_SUCCESS = 2;
const STATUS_FAILED = 3;
const protocol = location.protocol;
const slashes = protocol.concat("//");
const port = window.location.port === "80" || window.location.hostname === "443" ? "" : ":" + window.location.port;
const host = slashes.concat(window.location.hostname) + port;
const URL = process.env.NODE_ENV === 'production' ? host : "http://localhost:8080";
export default {
  name: 'XCF',
  components: {
    ValidationResults,
    TagsFilter,
    ErrorPanel
  },
  mounted () {
    this.reset();
  },
  computed: {
    showToken () {
      return this.$store.state.showToken;
    },
    FILTERS () {
      return this.$store.state.FILTERS;
    },
    hasFilters () {
      return this.$store.getters.hasFilters;
    },
    tags () {
      return this.$store.getters.filteredTags;
    },
    filtered () {
      return this.$store.getters.filteredReport;
    },
    report () {
      return this.$store.state.report;
    },
    rawReport () {
      return this.$store.state.rawReport;
    },
    isInitial () {
      return this.currentStatus === STATUS_INITIAL;
    },
    isSaving () {
      return this.currentStatus === STATUS_SAVING;
    },
    isSuccess () {
      return this.currentStatus === STATUS_SUCCESS;
    },
    isFailed () {
      return this.currentStatus === STATUS_FAILED;
    }
  },

  methods: {
    reset () {
      // reset form to initial state

      this.currentStatus = STATUS_INITIAL;
      this.uploadedFiles = [];
      this.uploadError = null;
      this.$store.commit('setActive', 0);
      fetch(URL + "/app/tags/").then(data => {
        data.json().then(tags => {
          this.$store.commit('tags', tags.Data);
          const filters = {};
          tags.Data.Tags.map(t => {
            filters[t.TagGroup.type] = [];
            t.TagGroup.TagList.forEach(it => {
              if (it.hasOwnProperty('selectFilterInitial') &&
                it.selectFilterInitial
              ) {
                filters[t.TagGroup.type].push(it.ID);
              }
            });
          });

          this.$store.commit('filter',
            filters
          );
        });
      });
    },
    loadEaxmple (name) {
      this.currentStatus = STATUS_SAVING;
      var data;
      switch (name) {
        case 'example-1':
          data = require('../store/example-1.json');
          break;
      }
      var that = this;
      window.setTimeout(function () {
        that.currentStatus = STATUS_SUCCESS;
        that.$store.dispatch('report', data);
      }, 700);
    },
    save (formData) {
      // upload data to the server
      this.currentStatus = STATUS_SAVING;
      fetch(URL + "/app/validate-form-data",
        {
          "method": "POST",
          "body": formData
        }).then(data => {
          return data.json();
        })
        .then(report => {
          if (report.hasOwnProperty('desc') || report.hasOwnProperty('error')) {
            throw new Error(report.desc + report.code || report.message);
          } else {
            this.currentStatus = STATUS_SUCCESS;
            this.$store.dispatch('report', report);
          }
        })
        .catch(err => {
          this.currentStatus = STATUS_FAILED;
          this.$store.commit('report', []);
          this.uploadError = err;
        });
    },
    filesChange (fieldName, fileList) {
      // handle file changes
      var formData = new FormData();
      this.$store.commit('setActive', 0);
      if (!fileList.length) return;
      formData.append(fieldName, fileList[0], fileList[0].name);
      this.save(formData);
      document.getElementById('uploadform').reset();
    }
  },
  data: () => {
    return {
      currentStatus: STATUS_INITIAL,
      uploadError: null,
      uploadFieldName: 'subtitle'
    };
  }
};
</script>

<style >
.appear-enter-active > .cut-content  {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

ul {
  list-style-type: none;
  padding: 0;
}

/** File Upload */
.col-xs-12>form>.dropbox {
    font-size: 140%;
}
.mb-2 {
  margin-bottom: 2px;
}
.dropbox {
  border-radius: 15px;
  border: 4px dashed #3d3d3d; /* the dash box */
  /*outline-offset: -10px;*/
  background: #efefef;
  color: dimgray;
  padding: 10px 10px;
  min-height: 200px; /* minimum height */
  position: relative;
  cursor: pointer;
}

.input-file {
  opacity: 0; /* invisible but it's there! */
  width: 100%;
  height: 200px;
  position: absolute;
  cursor: pointer;
}
div.col-xs-0 {
  width:0 !important;
}
.dropbox:hover {
  background: #cfcfcf; /* when mouse over to the drop zone, change color */
}

.dropbox p {
  font-size: 1.2em;
  text-align: center;
  padding: 50px 0;
}
.padding-top {
 padding-top: 20px;
 margin:10px;
}
/* Animation */
/* Enter and leave animations can use different */
/* durations and timing functions.              */
.grow {
  transition: all 0.55s ease-in-out;
}
.grow-enter-active {
  position: absolute;
}
.appear-enter-active, .appear-leave-active {
  transition: all 0.4s ease-in-out;
  overflow: hidden;
}
.appear-enter-active .nav {
  overflow: hidden;
  opacity: 0.55;
}

.appear-enter, .appear-leave-to /* .fade-leave-active in <2.1.8 */ {
  /*width: 0%;*/
  /*height: 0;
  padding: 0;*/
  transform: translate(0,-300px);
  opacity: 0;
  transform-origin: bottom;
  overflow: hidden;
}
.overlay {
  position:absolute;
  left:40%;
}
p.dimmmed {
  color: #cfcfcf;
}

.uploading {
  animation: pulse 1.5s  infinite;
}
@keyframes pulse {
  0% {
    border-left-color: #8d8d8d;
  }

  25% {
    border-top-color: #8d8d8d;

  }
  50% {
    border-right-color: #8d8d8d;

  }

  75% {
    border-bottom-color: #8d8d8d;
  }
}
</style>
