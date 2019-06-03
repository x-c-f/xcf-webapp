<template>
  <div class="panel panel-danger">
    <div class="panel-heading">
      <h4 class="panel-title">Analysis failed</h4>
    </div>
    <div class="panel-body">
      <div class="row">
          <div class="col-xs-12">
          <p>
            Your file could not be checked.
          </p>
          <p>Please try again with a well-formed XML file.</p>
          <!--
            <pre><code>{{ message.toString() }}</code></pre>
          </p> -->
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "error-panel",
  props: ['message']
};
</script>

<style scoped="true" lang="less">
@brand-success:red;
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

.errormark {
  display: block;


  &.draw:after {
    // animation-delay: 2s;
    animation-duration: 2.5s;
    animation-timing-function: ease;
    animation-name: errormark;
    transform: scaleX(-1) rotate(135deg);
  }
  &.draw:before {
    // animation-delay: 2s;
    animation-duration: 1.5s;
    animation-timing-function: ease;
    animation-name: errormark;
    transform: scaleX(-1) rotate(-135deg);
  }

  &:after {
    opacity: 1;
    height: @check-height*2.5;
    width: @check-width;
    transform-origin: left top;
    border-right: @check-thickness solid @check-color;
    content: '';
    left: @check-left*-.4;
    top: @check-height*1.4;
    position: absolute;
  }
  &:before {
    opacity: 1;
    height: @check-height*2.5;
    width: @check-width;
    transform-origin: left top;
    border-right: @check-thickness solid @check-color;
    content: '';
    left: @check-left*2.8;
    top: @check-height*2.2;
    position: absolute;
  }

}
</style>
