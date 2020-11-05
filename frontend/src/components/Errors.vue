<template>
  <div class="errors">
    <template v-for="error in errors">
      <div
        :key="'e' + error"
        class="bs-callout bs-callout-default"
        v-if="error.messages.messageAssertion"
      >
        <h4 title="Assertion">{{ error.messages.messageAssertion }}</h4>
        <p>{{ error.messages.messageDiagnosticsAll }}</p>
        <pre
          v-if="error.locations && error.locations.preview"
          class="language-xml nomargin"
        ><code>{{ error.locations.preview }}</code></pre>
        <!-- <div v-else><kbd>no preview</kbd></div> -->
        <div
          class="input-group code-snippet"
          v-if="error.locations && error.locations.humanXPATH"
        >
          <span class="input-group-addon code-snippet" id="basic-addon1"
            ><var>X</var>Path</span
          >
          <input
            type="text"
            class="code-snippet form-control"
            placeholder=""
            v-model="error.locations.humanXPATH"
            readonly="true"
          />
        </div>
        <!-- /input-group -->
      </div>
      <div
        :key="'bse' + error"
        class="bs-callout bs-callout-default"
        v-if="!error.messages.messageAssertion && error.messages.messageMain"
      >
        <p>{{ error.messages.messageMain }}</p>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  name: "Errors",
  props: ["errors"]
};
</script>

<style lang="less" scoped="true">
pre {
  font-size: 10px;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 0;
  border-bottom: 0;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  &.nomargin {
    margin: 0;
  }
}
.input-group * {
  font-size: 90%;
}
.code-snippet {
  border-top: 0;
  border-top-right-radius: 0;
  border-top-left-radius: 0;
  &.input-group {
    border-top: 1px solid #ccc;
  }
}
/* Side notes for calling out things
-------------------------------------------------- */
.form-control[readonly],
fieldset[readonly] .form-control {
  background-color: white;
}
.input-group-addon {
  background-color: #ccc;
}
/* Base styles (regardless of theme) */
.bs-callout {
  padding: 20px;
  margin: 20px 0;
  border: 1px solid #eee;
  border-left-width: 5px;
  border-radius: 3px;
}
.bs-callout h4 {
  margin-top: 0;
  margin-bottom: 5px;
}
.bs-callout p:last-child {
  margin-bottom: 0;
}
.bs-callout code {
  border-radius: 3px;
}
.bs-callout + .bs-callout {
  margin-top: -5px;
}
.bs-callout-default {
  border-left-color: #777;
}
.bs-callout-default h4 {
  color: #777;
}
.bs-callout-primary {
  border-left-color: #428bca;
}
.bs-callout-primary h4 {
  color: #428bca;
}
.bs-callout-success {
  border-left-color: #5cb85c;
}
.bs-callout-success h4 {
  color: #5cb85c;
}
.bs-callout-danger {
  border-left-color: #d9534f;
}
.bs-callout-danger h4 {
  color: #d9534f;
}
.bs-callout-warning {
  border-left-color: #f0ad4e;
}
.bs-callout-warning h4 {
  color: #f0ad4e;
}
.bs-callout-info {
  border-left-color: #5bc0de;
}
.bs-callout-info h4 {
  color: #5bc0de;
}
</style>
