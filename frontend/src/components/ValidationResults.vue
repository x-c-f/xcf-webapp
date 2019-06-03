<template>
  <div class="result-list">
    <FileInformation :rawReport="rawReport"/>

    <div class="panel panel-success" v-if="filtered.length === 0">
      <div class="panel-heading">
        <h4 class="panel-title">Your file has passed validation.</h4>
      </div>
      <div class="panel-body">
        <div class="row">
          <div class="col-xs-12">
            <div class="circle-loader load-complete pull-left">
              <div class="checkmark draw"></div>
            </div>

            <p>
              Your file has been successfully checked for semantic and technical validity.
            </p>
            <p v-if="filtered.length === 0 && report.length === 0">
              No errors have been reported.
            </p>
            <p v-if="filtered.length === 0 && report.length > 0">
              No errors have been reported according to the selected filters.
            </p>
          </div>
        </div>
      </div>
    </div>
    <transition-group name="list" tag="div" mode="in-out">
      <template v-for="(item,index) in filtered" v-if="filtered.length > 0">
        <ValidationResult :FILTERS="FILTERS" :ErrorIndex="item.uuid" :key="item.uuid" :errorCategory="item.errorCategory"/>
      </template>
    </transition-group>
  </div>
</template>

<script>
import ValidationResult from "./ValidationResult.vue";
import FileInformation from "./FileInformation.vue";

export default {
  name: 'validation-results',
  props: ['report', "filtered", "rawReport", "FILTERS"],
  components: {
    ValidationResult,
    FileInformation
  }
};
</script>

<style scoped="true" lang="less">
.col-xs-12 > .circle-loader {
  margin:0 .5em 0 0;
}
.list-item {
}
.list-move {
  transition: transform 0.5s;
}
.list-enter-active, .list-leave-active {
  display:block;
  transition: all 0.5s ease-in-out;
}
.list-enter{
  transform: translate3d(-100%,0, 0);
}
.list-leave-to {
  // opacity: 0;
  // max-height: 0;
  transform: translate3d(100%,0, 500px);
}

@brand-success: #5cb85c;
@loader-size: 4em;
@check-height: @loader-size/2;
@check-width: @check-height/2;
@check-left: (@loader-size/6 + @loader-size/12);
@check-thickness: 2px;
@check-color: @brand-success;

.circle-loader {
  margin: 0 0 0px 0px;
  border: @check-thickness solid rgba(0, 0, 0, 0.2);
  border-left-color: @check-color;
  position: relative;
  display: inline-block;
  vertical-align: top;
}

.circle-loader,
.circle-loader:after {
  border-radius: 50%;
  width: @loader-size;
  height: @loader-size;
}

.load-complete {
  -webkit-animation: none;
  animation: none;
  border-color: @check-color;
  transition: border 500ms ease-out;
}

.checkmark {
  display: block;


  &.draw:after {
    // animation-delay: 2s;
    animation-duration: 2.5s;
    animation-timing-function: ease;
    animation-name: checkmark;
    transform: scaleX(-1) rotate(135deg);
  }

  &:after {
    opacity: 1;
    height: @check-height;
    width: @check-width;
    transform-origin: left top;
    border-right: @check-thickness solid @check-color;
    border-top: @check-thickness solid @check-color;
    content: '';
    left: @check-left;
    top: @check-height;
    position: absolute;
  }
}
@keyframes checkmark {
  0% {
    height: 0;
    width: 0;
    opacity: 1;
  }
  20% {
    height: 0;
    width: @check-width;
    opacity: 1;
  }
  40% {
    height: @check-height;
    width: @check-width;
    opacity: 1;
  }
  100% {
    height: @check-height;
    width: @check-width;
    opacity: 1;
  }
}

</style>
