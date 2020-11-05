import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    FILTERS: {},
    activeTab: -1,
    tabForError: {},
    tags: {},
    report: [],
    rawReport: {}
  },
  getters: {
    hasFilters: (state) => {
      Object.keys(state.FILTERS).some(key => {
        state.FILTERS[key].some(it => {
          !!it;
        });
      });
    },
    filteredTags: (state) => {
      const its = {};
      store.getters.filteredReport.forEach(it => {
        it.errorCategory.specs.forEach(spec => {
          const type = "Specifications";
          const type2 = "Error Level";
          const val2 = spec.errorLevel;
          const val = spec.nameAcronym;
          its[type] = its[type] ? its[type] : {};
          its[type2] = its[type2] ? its[type2] : {};

          its[type][val] = its[type][val] ? its[type][val] + 1 : 1;
          its[type2][val2] = its[type2][val2] + 1 || 1;
        });
        it.errorCategory.tags.forEach(tag => {
          const type = tag.type;
          const val = tag.longDesc;
          its[type] = its[type] || {};
          its[type][val] = its[type][val] + 1 || 1;
        });
      });
      if (state.tags.Tags) {
        state.tags.Tags.forEach(tg => {
          tg.TagGroup.TagList.forEach((tl, i) => {
            let foo = its && its[tg.TagGroup.type] && its[tg.TagGroup.type][tl.Long] ? its[tg.TagGroup.type][tl.Long] : 0;
            Vue.set(tg.TagGroup.TagList, i,
              Object.assign({},
                tl, {
                  "count": foo,
                  "disabled": foo === 0
                }
              ));
          });
        });
      }
      return state.tags;
    },
    filteredReport: (state) => {
      if (state.report.length === 0) return [];
      return state.report.filter(it => {
        const tags = Object.keys(state.FILTERS).filter(it => it !== 'Error Level' && it !== 'Specifications').every(tag => {
          const checkedItems = state.FILTERS[tag];
          if (checkedItems.length === 0) return true;
          const reportedTags = it.errorCategory.tags.filter(it => it.type === tag).map(it => it.longDesc);
          return checkedItems.some(checkedItem => reportedTags.indexOf(checkedItem) !== -1);
        });
        const err = it.errorCategory.specs.some(spec => {
          const userFilter = state.FILTERS["Error Level"];
          return userFilter.length === 0 || userFilter.indexOf(spec.errorLevel) !== -1;
        });
        const spec = it.errorCategory.specs.some(spec => {
          const userFilter = state.FILTERS["Specifications"];
          return userFilter.length === 0 || userFilter.indexOf(spec.nameAcronym) !== -1;
        });
        return tags && err && spec;
      });
    }
  },
  actions: {
    report: ({
      commit
    }, report) => {
      commit("rawReport", report);
      commit("report", report.report);
    }
  },
  mutations: {
    filter(state, payload) {
      state.FILTERS = payload;
    },
    tabForError(state, payload) {
      state.tabForError = Object.assign({}, state.tabForError, payload);
    },
    setActive(state, payload) {
      state.activeTab = payload;
    },
    tags(state, payload) {
      state.tags = payload;
    },
    report(state, payload) {
      state.report = payload;
    },
    rawReport(state, payload) {
      state.rawReport = payload;
    }
  }
});
