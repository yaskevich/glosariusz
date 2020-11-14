/*jslint browser: true, vars: true, devel: true, nomen: true, maxerr: 50 */
/*global module, exports */

/*
 * jQuery Spoiler
 * Created 2014 Triangle717
 * <http://Triangle717.WordPress.com/>
 *
 * With code by Jarred Ballard
 * <http://jarred.io/>
 *
 * Licensed under The MIT License
 * <http://opensource.org/licenses/MIT/>
 */

(function (factory) {
  "use strict";
  if (typeof define === "function" && define.amd) {
    // AMD. Register as an anonymous module.
    define(["jquery"], factory);
  } else if (typeof exports === "object") {
    // Node/CommonJS style for Browserify
    module.exports = factory;
  } else {
    // Browser globals
    factory(jQuery);
  }
}(function ($) {
  "use strict";
  $.fn.spoiler = function (options) {
    var settings = $.extend({
      contentClass       : "spoiler-content",
      paddingValue       : 6,
      triggerEvents      : false,
      includePadding     : true,
      buttonActiveClass  : "spoiler-active",
      spoilerVisibleClass: "spoiler-content-visible"
    }, options);

    var contentClass   = "." + settings.contentClass,
        spoilerHeights = {};

    $(contentClass).each(function () {
      var $this = $(this);
      // The only CSS requirement for this to work for the spoilered content
      // to have an overflow: hidden rule applied.
      $this.css("overflow", "hidden");

      // Get the height of the content to be spoilered now,
      // as once we hide the text it cannot be restored.
      // Use the value of `scrollHeight`, which does not change
      // even if a height is applied through CSS.
      var contentHeight = $this.prop("scrollHeight");

      // Add padding to bottom of container only if enabled
      contentHeight = (settings.includePadding ?
                      contentHeight + parseInt(settings.paddingValue, 10) : contentHeight);
      var spoiler  = $this.attr("data-spoiler-link");
      spoilerHeights[spoiler] = contentHeight + "px";

      // Now that we have the height, hide all content
      $this.css("height", "0");
    });


    $(this).on("click", function () {
      // Get the ID for the clicked spoiler button so only that one is triggered
      var $this    = $(this),
          spoiler  = $this.attr("data-spoiler-link"),
          $content = $(contentClass + "[data-spoiler-link=" + spoiler + "]");

      // The container's collapsed/expanded height values
      var showContent = {"height": spoilerHeights[spoiler]},
          hideContent = {"height": "0"};

      // Check if content is visible or not
      var isVisible = $content.hasClass(settings.spoilerVisibleClass);

      // Toggle content visibility
      if (isVisible) {
        $content.css(hideContent);
      } else {
        $content.css(showContent);
      }

      // If enabled, trigger events upon show/hide
      if (settings.triggerEvents) {
        if (isVisible) {
          $this.trigger("jq-spoiler-hidden");
        } else {
          $this.trigger("jq-spoiler-visible");
        }
      }

      // Toggle active classes for both container and button
      $content.toggleClass(settings.spoilerVisibleClass);
      $this.toggleClass(settings.buttonActiveClass);
    });
    return this;
  };
}));
